import 'dart:async';
import 'dart:io';

import 'db_file.dart';
import 'db_validator.dart';
import 'proto/ebc_db.pb.dart' as proto;

/// Reads/writes a single [proto.Db] to disk. `Db` itself is the app's
/// in-memory global state — this class is purely the durability layer:
/// callers own the in-memory instance and decide when to call [save].
class DbStore {
  final File file;

  /// Coalesces rapid [save] calls into one write. `Duration.zero` (the
  /// default) writes immediately on every call. The UI layer already
  /// debounces its own inputs — this is a second, independent safety net
  /// against hammering disk if some caller doesn't.
  final Duration debounce;

  DbStore(this.file, {this.debounce = Duration.zero});

  File get _tmpFile => File('${file.path}.tmp');
  File get _bakFile => File('${file.path}.bak');

  Timer? _debounceTimer;
  proto.Db? _pendingDb;
  Completer<void>? _pendingCompleter;

  /// Loads [Db] from disk. Falls back to [orElseSeed] if the file is
  /// missing, fails to decode, or fails schema validation — mirrors the
  /// reset-on-corruption behavior ObjectBox-era code used.
  Future<proto.Db> load({required proto.Db Function() orElseSeed}) async {
    if (!await file.exists()) return orElseSeed();

    try {
      final bytes = await file.readAsBytes();
      final db = DbFile.decode(bytes);
      DbValidator.validate(db);
      return db;
    } catch (_) {
      return orElseSeed();
    }
  }

  /// Persists [db]. With [debounce] set, rapid calls coalesce into a
  /// single write after the quiet period; the returned future completes
  /// when that write actually happens, not immediately. Call [flush] on
  /// app pause/dispose so a pending debounced write isn't lost.
  Future<void> save(proto.Db db) {
    if (debounce == Duration.zero) return _writeNow(db);

    _pendingDb = db;
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

    final db = _pendingDb;
    final completer = _pendingCompleter;
    _pendingDb = null;
    _pendingCompleter = null;
    if (db == null || completer == null) return;

    try {
      await _writeNow(db);
      completer.complete();
    } catch (e, st) {
      completer.completeError(e, st);
    }
  }

  /// Atomically persists [db]: write to a temp file, flush, then rename
  /// over the real path (atomic on all target platforms' filesystems).
  /// The previous good file is rotated to `<path>.bak` first, so a crash
  /// mid-write always leaves either the old file or the new one intact,
  /// never a torn one.
  Future<void> _writeNow(proto.Db db) async {
    final bytes = DbFile.encode(db);

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
