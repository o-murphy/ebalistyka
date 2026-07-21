import 'dart:io';

import 'package:ebc_db/ebc_db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class EbcpService {
  // ── Export ──────────────────────────────────────────────────────────────────────────

  /// Wraps [profile] as a single-profile share — `settings_data` unset, no
  /// picker. Always mints a fresh `uuid` (export is a copy, same as
  /// import — see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 3.5
  /// Sketch's `uuid` lifecycle invariant).
  static EbcpData buildProfileShare(Profile profile) => EbcpData(
    profilesData: [
      ProfilesData(profiles: [copyWithFreshUuid(profile)]),
    ],
  );

  /// Wraps every local [profiles] plus [settings] as a full backup.
  static EbcpData buildFullBackup(
    List<Profile> profiles,
    SettingsData settings,
  ) => EbcpData(
    profilesData: [
      ProfilesData(profiles: profiles.map(copyWithFreshUuid).toList()),
    ],
    settingsData: settings,
  );

  /// Every [Profile] carried by [data], flattened across its (possibly
  /// several) `profiles_data` blocks.
  static List<Profile> profilesOf(EbcpData data) =>
      data.profilesData.expand((pd) => pd.profiles).toList();

  static Future<void> shareFile(EbcpData data, String fileName) async {
    final bytes = EbcpFile.encode(data);
    final name =
        '${sanitizeName(fileName).replaceFirst(RegExp(r'^\.'), '')}.ebcp';

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

  /// Opens a file picker for `.ebcp` files and returns the parsed, validated
  /// [EbcpData]. Returns `null` if the user cancels.
  ///
  /// Throws [MsgParseException] if the bytes aren't a valid md5+ebcpbuf
  /// `EbcpData` (corrupt file, or a file from a different format entirely),
  /// or [EbcpValidationException] if they decode but fail schema validation.
  static Future<EbcpData?> pickAndParse() async {
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

    final data = EbcpFile.decode(bytes); // throws MsgParseException on error
    EbcpValidator.validate(data); // throws EbcpValidationException on error
    return data;
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────────────

  static String sanitizeName(String name) =>
      name.replaceAll(RegExp(r'[^\w\-. ]'), '_').trim();
}
