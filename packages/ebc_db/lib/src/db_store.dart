import 'dart:io';

import 'db_file.dart';
import 'db_validator.dart';
import 'proto/ebc_db.pb.dart' as proto;

/// Reads/writes a single [proto.Db] to disk. `Db` itself is the app's
/// in-memory global state — this class is purely the durability layer:
/// callers own the in-memory instance and decide when to call [save].
class DbStore {
  final File file;
  DbStore(this.file);

  File get _tmpFile => File('${file.path}.tmp');
  File get _bakFile => File('${file.path}.bak');

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

  /// Atomically persists [db]: write to a temp file, flush, then rename
  /// over the real path (atomic on all target platforms' filesystems).
  /// The previous good file is rotated to `<path>.bak` first, so a crash
  /// mid-write always leaves either the old file or the new one intact,
  /// never a torn one.
  Future<void> save(proto.Db db) async {
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
