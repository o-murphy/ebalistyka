import 'dart:io';

import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class EbcpService {
  // ── Export ──────────────────────────────────────────────────────────────────────────

  static Future<void> shareFile(EbcpFile file, String fileName) async {
    final bytes = file.toEbcp();
    final name =
        '${EbcpService.sanitizeName(fileName).replaceFirst(RegExp(r'^\.'), '')}.ebcp';

    if (Platform.isAndroid || Platform.isIOS) {
      final tmp = await getTemporaryDirectory();
      final path = '${tmp.path}/$name';
      await File(path).writeAsBytes(bytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(path, mimeType: 'application/octet-stream', name: name),
          ],
        ),
      );
    } else {
      final savePath = await FilePicker.saveFile(
        fileName: name,
        type: FileType.custom,
        allowedExtensions: ['ebcp'],
        bytes: bytes,
      );
      if (savePath != null && !kIsWeb) {
        await File(savePath).writeAsBytes(bytes);
      }
    }
  }

  // ── Import ─────────────────────────────────────────────────────────────────────────

  /// Opens a file picker for .ebcp files and returns the parsed [EbcpFile].
  /// Returns `null` if the user cancels or the file is invalid.
  static Future<EbcpFile?> pickAndParse() async {
    final result = await FilePicker.pickFiles(
      type: Platform.isAndroid ? FileType.any : FileType.custom,
      allowedExtensions: Platform.isAndroid ? null : ['ebcp'],
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.single;
    if (!file.name.toLowerCase().endsWith('.ebcp')) {
      throw FormatException('Expected an .ebcp file, got: ${file.name}');
    }

    final bytes = await file.readAsBytes();

    return EbcpFile.fromEbcp(bytes);
  }

  // ── Full backup ──────────────────────────────────────────────────────────────────────
  //
  // Whole-app backup/export/import against the new ebc_db storage format is
  // not implemented yet (Phase 3.5) — see ImportNotAvailableException in
  // app_state_provider.dart. The old buildFullExport/restoreFromExport built
  // ebalistyka_db (ObjectBox) *Export DTOs and no longer apply.

  // ── Helpers ─────────────────────────────────────────────────────────────────────────

  static String sanitizeName(String name) =>
      name.replaceAll(RegExp(r'[^\w\-. ]'), '_').trim();
}
