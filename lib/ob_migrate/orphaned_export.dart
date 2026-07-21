import 'dart:convert';
import 'dart:io';

import 'package:ebalistyka/core/services/ebcp_service.dart';
import 'package:ebc_db/ebc_db.dart';
// Not part of ebc_db's public barrel (package-internal), but this is
// exactly the schema-shaped JSON mapping this export wants to reuse
// rather than re-derive by hand — see legacy_migrator.dart's header note.
// ignore: implementation_imports
import 'package:ebc_db/src/validation/profiles_json.dart'
    show ammoToJson, sightToJson, weaponToJson;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Shares/saves [weapons]/[ammo]/[sights] (old-library items never
/// referenced by any migrated profile) as one `.json` file, shaped exactly
/// like `ebc_db`'s own schema (reusing its `weaponToJson`/`ammoToJson`/
/// `sightToJson` rather than re-deriving the mapping by hand) — so the data
/// isn't silently dropped, even though the new app has nowhere to put a
/// standalone weapon/ammo/sight library. What to do with the export is
/// deferred (see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 5).
Future<void> shareOrphanedDataJson({
  required List<Weapon> weapons,
  required List<Ammo> ammo,
  required List<Sight> sights,
}) async {
  final data = {
    'weapons': weapons.map(weaponToJson).toList(),
    'ammo': ammo.map(ammoToJson).toList(),
    'sights': sights.map(sightToJson).toList(),
  };
  final bytes = utf8.encode(const JsonEncoder.withIndent('  ').convert(data));
  final name = '${EbcpService.sanitizeName('orphaned-legacy-data')}.json';

  if (Platform.isAndroid || Platform.isIOS) {
    final tmp = await getTemporaryDirectory();
    final path = '${tmp.path}/$name';
    await File(path).writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(path, mimeType: 'application/json', name: name)]),
    );
  } else {
    final savePath = await FilePicker.saveFile(
      fileName: name,
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: bytes,
    );
    if (savePath != null && !kIsWeb) {
      await File(savePath).writeAsBytes(bytes);
    }
  }
}
