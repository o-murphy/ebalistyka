import 'dart:async';
import 'dart:typed_data';

/// Reads/writes a single message of type [T] to a durable backing store. In
/// memory, the decoded value *is* that slice of the app's state — this class
/// is purely the durability layer: callers own the in-memory instance and
/// decide when to call [save]. One instance per file/key (e.g. one for
/// `profiles.ebcp`, a separate one for `settings.ebcp`) — each instance's
/// atomicity/debounce is fully independent of any other's.
///
/// Platform-specific: [FileMsgStore] persists to a `dart:io` [File]
/// (desktop/mobile); a web counterpart backed by IndexedDB lives at
/// `src/persistence/indexed_db_msg_store.dart` (not exported from this
/// package's main barrel — see that file's own doc comment for why).
/// Subclasses only implement the byte-level [readBytes]/[writeBytes]
/// primitives; debounce/write-serialization/encode-decode are handled once,
/// here.
abstract class MsgStore<T> {
  MsgStore({
    required Uint8List Function(T) encode,
    required T Function(Uint8List) decode,
    this.debounce = Duration.zero,
  }) : _encode = encode,
       _decode = decode;

  /// Coalesces rapid [save] calls into one write. `Duration.zero` (the
  /// default) writes immediately on every call. The UI layer already
  /// debounces its own inputs — this is a second, independent safety net
  /// against hammering the backing store if some caller doesn't.
  final Duration debounce;

  final Uint8List Function(T) _encode;
  final T Function(Uint8List) _decode;

  Timer? _debounceTimer;
  T? _pending;
  Completer<void>? _pendingCompleter;

  // Serializes calls to writeBytes: two overlapping writes to the same
  // backing store shouldn't interleave (e.g. a file's tmp-write+rename can
  // race another write's). Chained rather than awaited per-call so one
  // write's failure doesn't jam the queue for the next.
  Future<void> _writeQueue = Future.value();

  /// Returns the raw persisted bytes, or `null` if nothing is stored yet.
  Future<Uint8List?> readBytes();

  /// Atomically persists [bytes]. Only ever called one at a time — the
  /// write queue above serializes overlapping [save]/[flush] calls.
  Future<void> writeBytes(Uint8List bytes);

  /// Loads [T] from the backing store. Falls back to [orElseSeed] if
  /// nothing is stored yet, or if reading/decoding fails (validation is the
  /// caller's job — pass a `validate` step inside [orElseSeed]'s caller, or
  /// wrap [load] — this class only owns the byte-level round-trip and
  /// atomic write).
  Future<T> load({required T Function() orElseSeed}) async {
    try {
      final bytes = await readBytes();
      if (bytes == null) return orElseSeed();
      return _decode(bytes);
    } catch (_) {
      return orElseSeed();
    }
  }

  /// Persists [value]. With [debounce] set, rapid calls coalesce into a
  /// single write after the quiet period; the returned future completes
  /// when that write actually happens, not immediately. Call [flush] on
  /// app pause/dispose so a pending debounced write isn't lost.
  Future<void> save(T value) {
    if (debounce == Duration.zero) return _writeNow(value);

    _pending = value;
    _pendingCompleter ??= Completer<void>();
    final completer = _pendingCompleter!;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () {
      unawaited(flush());
    });

    return completer.future;
  }

  /// Immediately writes any pending debounced [save], if one is queued.
  /// No-op if nothing is pending.
  Future<void> flush() async {
    _debounceTimer?.cancel();
    _debounceTimer = null;

    final value = _pending;
    final completer = _pendingCompleter;
    _pending = null;
    _pendingCompleter = null;
    if (value == null || completer == null) return;

    try {
      await _writeNow(value);
      completer.complete();
    } catch (e, st) {
      completer.completeError(e, st);
    }
  }

  /// Queues [value] behind any write already in flight, so overlapping
  /// `save()` calls never race on the backing store (see [_writeQueue]'s
  /// doc comment). Returns a future for *this* write's own outcome — a
  /// prior write's failure doesn't propagate here, and this write's failure
  /// doesn't block whatever's queued after it.
  Future<void> _writeNow(T value) {
    final scheduled = _writeQueue.then((_) => writeBytes(_encode(value)));
    _writeQueue = scheduled.then((_) {}, onError: (_) {});
    return scheduled;
  }
}
