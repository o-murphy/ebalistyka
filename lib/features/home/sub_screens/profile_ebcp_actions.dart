import 'dart:io';

import 'package:a7p/a7p.dart' hide Profile;
import 'package:ebalistyka/core/services/a7p_converter.dart';
import 'package:ebalistyka/core/services/ebcp_service.dart';
import 'package:ebalistyka/features/home/profiles_vm.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/profile_selection_sheet.dart';
import 'package:ebalistyka/shared/widgets/snackbars.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared single-profile export/import handlers — used by both
/// [ProfilesScreen] (my_profiles_screen.dart) and [ProfilesListScreen]
/// (profiles_list_screen.dart), which show the same profile actions on two
/// different tile shapes. Keeps the actual async/format logic in one place
/// even though each screen builds its own surrounding action sheet.

Future<void> shareProfileAsEbcp(BuildContext context, Profile profile) async {
  try {
    await EbcpService.shareFile(
      EbcpService.buildProfileShare(profile),
      profile.name,
    );
  } catch (e) {
    debugPrint('Profile export failed: $e');
    if (!context.mounted) return;
    showFeedback(context, e.toString(), isError: true);
  }
}

/// Imports a profile from either an `.ebcp` or `.a7p` file, resolved from
/// the picked file's extension — the user isn't asked which format it is,
/// only which file.
Future<void> importProfileFromFile(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  try {
    final result = await FilePicker.pickFiles(
      type: Platform.isAndroid ? FileType.any : FileType.custom,
      allowedExtensions: Platform.isAndroid ? null : ['ebcp', 'a7p'],
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final lowerName = file.name.toLowerCase();
    final bytes = await file.readAsBytes();

    final List<Profile> profiles;
    if (lowerName.endsWith('.ebcp')) {
      // No EbcpValidator here — see EbcpService.pickAndParse's doc comment:
      // sanitizeProfile (run by importProfile below) is the repair gate for
      // out-of-range fields, not a pre-import hard reject.
      final data = EbcpFile.decode(bytes); // throws MsgParseException
      profiles = EbcpService.profilesOf(data);
    } else if (lowerName.endsWith('.a7p')) {
      final payload = A7pFile.decode(bytes); // throws A7pParseException
      profiles = [A7pConverter.fromPayload(payload, validate: false)];
    } else {
      throw FormatException('Unsupported file type: ${file.name}');
    }

    if (!context.mounted) return;
    if (profiles.isEmpty) {
      showFeedback(context, l10n.ebcpFileHasNoProfiles, isError: true);
      return;
    }

    final selected = profiles.length == 1
        ? profiles
        : await showProfileSelectionSheet(context, profiles);
    if (selected == null || selected.isEmpty || !context.mounted) return;

    await ref.read(profilesActionsProvider.notifier).importProfiles(selected);
  } catch (e) {
    debugPrint('Profile import failed: $e');
    if (!context.mounted) return;
    showFeedback(context, '${l10n.actionImportFromFile}: $e', isError: true);
  }
}
