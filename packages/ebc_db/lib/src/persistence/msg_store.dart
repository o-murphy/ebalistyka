import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

/// Reads/writes a single message of type [T] to disk. In memory, the
/// decoded value *is* that slice of the app's state — this class is purely
/// the durability layer: callers own the in-memory instance and decide when
/// to call [save]. One instance per file (e.g. one for `profiles.ebcp`, a
/// separate one for `settings.ebcp`) — each file's atomicity/debounce is
/// fully independent of any other file's.
class MsgStore<T> {
  final File file;

  /// Coalesces rapid [save] calls into one write. `Duration.zero` (the
  /// default) writes immediately on every call. The UI layer already
  /// debounces its own inputs — this is a second, independent safety net
  /// against hammering disk if some caller doesn't.
  final Duration debounce;

  final Uint8List Function(T) _encode;
  final T Function(Uint8List) _decode;

  MsgStore(
    this.file, {
    required Uint8List Function(T) encode,
    required T Function(Uint8List) decode,
    this.debounce = Duration.zero,
  }) : _encode = encode,
       _decode = decode;

  File get _tmpFile => File('${file.path}.tmp');
  File get _bakFile => File('${file.path}.bak');

  Timer? _debounceTimer;
  T? _pending;
  Completer<void>? _pendingCompleter;

  /// Loads [T] from disk. Falls back to [orElseSeed] if the file is
  /// missing, fails to decode, or fails schema validation (validation is
  /// the caller's job — pass a `validate` step inside [orElseSeed]'s
  /// caller, or wrap [load] — this class only owns the byte-level
  /// round-trip and atomic write).
  Future<T> load({required T Function() orElseSeed}) async {
    if (!await file.exists()) return orElseSeed();

    try {
      final bytes = await file.readAsBytes();
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

  /// Atomically persists [value]: write to a temp file, flush, then rename
  /// over the real path (atomic on all target platforms' filesystems). The
  /// previous good file is rotated to `<path>.bak` first, so a crash
  /// mid-write always leaves either the old file or the new one intact,
  /// never a torn one.
  Future<void> _writeNow(T value) async {
    final bytes = _encode(value);

    final sink = _tmpFile.openWrite();
    sink.add(bytes);
    await sink.flush();
    await sink.close();

    if (await file.exists()) {
      await file.copy(_bakFile.path);
    }
    await _tmpFile.rename(file.path);
  }
}
