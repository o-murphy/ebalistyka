import 'dart:io';
import 'dart:typed_data';

import 'msg_store.dart';

/// [MsgStore] backed by a `dart:io` [File] — desktop/mobile. See
/// `indexed_db_msg_store.dart` for the web counterpart.
class FileMsgStore<T> extends MsgStore<T> {
  FileMsgStore(
    this.file, {
    required super.encode,
    required super.decode,
    super.debounce,
  });

  final File file;

  File get _tmpFile => File('${file.path}.tmp');
  File get _bakFile => File('${file.path}.bak');

  @override
  Future<Uint8List?> readBytes() async {
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  /// Atomically persists [bytes]: write to a temp file, flush, then rename
  /// over the real path (atomic on all target platforms' filesystems). The
  /// previous good file is rotated to `<path>.bak` first, so a crash
  /// mid-write always leaves either the old file or the new one intact,
  /// never a torn one.
  @override
  Future<void> writeBytes(Uint8List bytes) async {
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
