import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'msg_store.dart';

/// [MsgStore] backed by IndexedDB — web. See `file_msg_store.dart` for the
/// desktop/mobile counterpart.
///
/// One IndexedDB database (`_dbName`), one object store (`_storeName`),
/// keyed by [key] — no cursors/indexes, since the app only ever needs "one
/// blob per key" (today: `settings`/`profiles`, see docs/backlogs/
/// 9.FIELD_CONSTRAINTS_UX_WEB.md Phase 9). Raw `package:web` IndexedDB
/// bindings rather than a wrapper package (`idb_shim` etc.) — matches this
/// codebase's existing convention of hand-wrapping `package:web`'s
/// event-based JS APIs in a `Completer` (see `bclibc_ffi_web.dart`'s wasm
/// module loader), and two operations (get/put) don't justify a dependency
/// whose main value is abstracting query/cursor/index shapes this store
/// never uses.
///
/// Not exported from `ebc_db.dart`'s main barrel: this file imports
/// `dart:js_interop` (via `package:web`), which doesn't exist for a
/// non-web compile target — `dart test`/`flutter test` (both run on the
/// VM) would fail to compile this file if the barrel pulled it in
/// unconditionally. Import it directly
/// (`package:ebc_db/src/persistence/indexed_db_msg_store.dart`) from a
/// web-only entry point instead (e.g. `app_bootstrap_web.dart`) — the same
/// `implementation_imports` shape `bclibc_flutter`'s
/// `async_calculator.dart` already uses to reach into `bclibc`'s
/// `lib/src`, for the same reason: `ebc_db` and `ebalistyka` are versioned
/// and developed together in this one repo.
const _dbName = 'ebc_db';
const _storeName = 'kv';
const _dbVersion = 1;
const _epochKey = '__session_epoch';

// One connection for the whole page, shared by every store and the fence.
Future<web.IDBDatabase>? _sharedDb;
Future<web.IDBDatabase> _openDatabase() => _sharedDb ??= _openDatabaseNow();

Future<web.IDBDatabase> _openDatabaseNow() {
  final completer = Completer<web.IDBDatabase>();
  final request = web.window.indexedDB.open(_dbName, _dbVersion);

  void onUpgradeNeeded(web.Event _) {
    final db = request.result! as web.IDBDatabase;
    if (!db.objectStoreNames.contains(_storeName)) {
      db.createObjectStore(_storeName);
    }
  }

  void onSuccess(web.Event _) {
    completer.complete(request.result! as web.IDBDatabase);
  }

  void onError(web.Event _) {
    completer.completeError(
      request.error ?? StateError('IndexedDB open failed'),
    );
  }

  request.addEventListener('upgradeneeded', onUpgradeNeeded.toJS);
  request.addEventListener('success', onSuccess.toJS);
  request.addEventListener('error', onError.toJS);
  return completer.future;
}

/// A fencing token for writes: makes sure a page that has lost the right to
/// write (another tab took the session over) can never land a write — not
/// even one that was already in flight when the takeover happened.
///
/// [claim] atomically bumps a monotonic epoch stored beside the data and
/// remembers the value this page got. Every write made through a store that
/// carries this fence runs the check **inside the same IndexedDB
/// transaction** as the `put`: if the stored epoch is no longer ours, the
/// transaction is aborted and nothing is written ([onStale] fires). IndexedDB
/// transactions are atomic, so a write can't interleave with a newer claim.
///
/// Independent of `navigator.locks` / any messaging: it holds even if those
/// are missing or delayed.
class IndexedDbWriteFence {
  IndexedDbWriteFence({this.onStale});

  /// Called (at most once) when a write is rejected because a newer session
  /// claimed the epoch.
  final void Function()? onStale;

  int? _epoch;
  bool _stale = false;

  /// This page's epoch, or `null` before [claim].
  int? get epoch => _epoch;

  /// `true` once a write was rejected as stale.
  bool get isStale => _stale;

  void _markStale() {
    if (_stale) return;
    _stale = true;
    onStale?.call();
  }

  /// Takes the session: epoch := stored + 1, atomically.
  Future<int> claim() async {
    final db = await _openDatabase();
    final tx = db.transaction(_storeName.toJS, 'readwrite');
    final store = tx.objectStore(_storeName);
    final getReq = store.get(_epochKey.toJS);
    final completer = Completer<int>();
    var next = 0;

    getReq.addEventListener(
      'success',
      ((web.Event _) {
        final cur = getReq.result;
        next = (cur == null ? 0 : (cur as JSNumber).toDartInt) + 1;
        store.put(next.toJS, _epochKey.toJS);
      }).toJS,
    );
    tx.addEventListener(
      'complete',
      ((web.Event _) {
        _epoch = next;
        _stale = false;
        completer.complete(next);
      }).toJS,
    );
    void fail(web.Event _) => completer.completeError(
      tx.error ?? StateError('IndexedDB epoch claim failed'),
    );
    tx.addEventListener('error', fail.toJS);
    tx.addEventListener('abort', fail.toJS);
    return completer.future;
  }
}

class IndexedDbMsgStore<T> extends MsgStore<T> {
  IndexedDbMsgStore(
    this.key, {
    required super.encode,
    required super.decode,
    super.debounce,
    this.fence,
  });

  final String key;

  /// When set, every write is guarded by the fence (see
  /// [IndexedDbWriteFence]). Reads are never fenced.
  final IndexedDbWriteFence? fence;

  @override
  Future<Uint8List?> readBytes() async {
    final db = await _openDatabase();
    final store = db
        .transaction(_storeName.toJS, 'readonly')
        .objectStore(_storeName);
    final request = store.get(key.toJS);

    final completer = Completer<Uint8List?>();

    void onSuccess(web.Event _) {
      final result = request.result;
      completer.complete(
        result == null ? null : (result as JSUint8Array).toDart,
      );
    }

    void onError(web.Event _) {
      completer.completeError(
        request.error ?? StateError('IndexedDB read failed'),
      );
    }

    request.addEventListener('success', onSuccess.toJS);
    request.addEventListener('error', onError.toJS);
    return completer.future;
  }

  @override
  Future<void> writeBytes(Uint8List bytes) async {
    final db = await _openDatabase();
    final tx = db.transaction(_storeName.toJS, 'readwrite');
    final store = tx.objectStore(_storeName);
    final completer = Completer<void>();

    final f = fence;
    if (f == null) {
      store.put(bytes.toJS, key.toJS);
    } else {
      // Check-and-put in ONE transaction — see IndexedDbWriteFence.
      final epochReq = store.get(_epochKey.toJS);
      epochReq.addEventListener(
        'success',
        ((web.Event _) {
          final cur = epochReq.result;
          final stored = cur == null ? null : (cur as JSNumber).toDartInt;
          if (f.epoch != null && stored == f.epoch) {
            store.put(bytes.toJS, key.toJS);
          } else {
            tx.abort();
            f._markStale();
            // Dropped on purpose: this page no longer owns the data.
            if (!completer.isCompleted) completer.complete();
          }
        }).toJS,
      );
    }

    tx.addEventListener(
      'complete',
      ((web.Event _) {
        if (!completer.isCompleted) completer.complete();
      }).toJS,
    );
    void fail(web.Event _) {
      if (completer.isCompleted) return; // an intentional stale abort
      completer.completeError(tx.error ?? StateError('IndexedDB write failed'));
    }

    tx.addEventListener('error', fail.toJS);
    tx.addEventListener('abort', fail.toJS);
    return completer.future;
  }
}
