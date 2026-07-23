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
/// `implementation_imports` shape `dart_bclibc_flutter`'s
/// `async_calculator.dart` already uses to reach into `dart_bclibc`'s
/// `lib/src`, for the same reason: `ebc_db` and `ebalistyka` are versioned
/// and developed together in this one repo.
class IndexedDbMsgStore<T> extends MsgStore<T> {
  IndexedDbMsgStore(
    this.key, {
    required super.encode,
    required super.decode,
    super.debounce,
  });

  static const _dbName = 'ebc_db';
  static const _storeName = 'kv';
  static const _dbVersion = 1;

  final String key;

  Future<web.IDBDatabase>? _dbFuture;

  Future<web.IDBDatabase> _openDatabase() => _dbFuture ??= _openDatabaseNow();

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
    final store = db
        .transaction(_storeName.toJS, 'readwrite')
        .objectStore(_storeName);
    final request = store.put(bytes.toJS, key.toJS);

    final completer = Completer<void>();

    void onSuccess(web.Event _) => completer.complete();

    void onError(web.Event _) {
      completer.completeError(
        request.error ?? StateError('IndexedDB write failed'),
      );
    }

    request.addEventListener('success', onSuccess.toJS);
    request.addEventListener('error', onError.toJS);
    return completer.future;
  }
}
