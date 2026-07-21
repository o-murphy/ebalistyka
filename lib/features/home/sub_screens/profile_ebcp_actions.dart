import 'package:ebalistyka/core/services/ebcp_service.dart';
import 'package:ebalistyka/features/home/profiles_vm.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/action_sheet.dart';
import 'package:ebalistyka/shared/widgets/snackbars.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared `.ebcp` single-profile export/import handlers — used by both
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
    if (!context.mounted) return;
    showFeedback(context, e.toString(), isError: true);
  }
}

Future<void> importProfileFromEbcp(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  try {
    final data = await EbcpService.pickAndParse();
    if (data == null || !context.mounted) return;

    final profiles = EbcpService.profilesOf(data);
    if (profiles.isEmpty) {
      showFeedback(context, l10n.ebcpFileHasNoProfiles, isError: true);
      return;
    }

    final picked = profiles.length == 1
        ? profiles.single
        : await _pickProfile(context, profiles);
    if (picked == null || !context.mounted) return;

    await ref.read(profilesActionsProvider.notifier).importProfile(picked);
  } catch (e) {
    if (!context.mounted) return;
    showFeedback(context, '${l10n.actionImportFromFile}: $e', isError: true);
  }
}

Future<Profile?> _pickProfile(
  BuildContext context,
  List<Profile> profiles,
) async {
  final l10n = AppLocalizations.of(context)!;
  Profile? picked;
  await showActionSheet(
    context,
    title: l10n.selectProfileDialogTitle,
    entries: [
      for (final profile in profiles)
        ActionSheetItem(
          title: profile.name,
          subtitle: profile.weapon.name.isNotEmpty ? profile.weapon.name : null,
          onTap: () async => picked = profile,
        ),
    ],
  );
  return picked;
}
