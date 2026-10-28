import 'package:a7p/a7p.dart' hide Profile;
import 'package:ebalistyka/core/services/a7p_converter.dart';
import 'package:ebalistyka/core/services/a7p_service.dart';
import 'package:ebalistyka/core/services/ebcp_service.dart';
import 'package:ebalistyka/features/home/profiles_vm.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/router.dart';
import 'package:ebalistyka/shared/icons_definitions.dart';
import 'package:ebalistyka/shared/widgets/action_sheet.dart';
import 'package:ebalistyka/shared/widgets/confirm_dialog.dart';
import 'package:ebalistyka/shared/helpers/is_mobile.dart';
import 'package:ebalistyka/shared/widgets/profile_selection_sheet.dart';
import 'package:ebalistyka/shared/widgets/snackbars.dart';
import 'package:ebalistyka/shared/widgets/text_input_dialog.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Profile actions shared by [ProfilesScreen] (my_profiles_screen.dart) and
/// [ProfilesListScreen] (profiles_list_screen.dart), which show the same
/// actions on two different tile shapes: add / import / export / duplicate /
/// remove. Rename and the hot-swap flows stay in the screens — they differ.

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
    final file = await FilePicker.pickFile(
      type: isAndroid ? FileType.any : FileType.custom,
      allowedExtensions: isAndroid ? null : ['ebcp', 'a7p'],
    );
    if (file == null) return;
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

Future<String?> askProfileName(BuildContext context, {String? initial}) {
  final l10n = AppLocalizations.of(context)!;
  return showTextInputDialog(
    context,
    title: l10n.newProfile,
    initialValue: initial,
    labelText: l10n.profileName,
    confirmLabel: l10n.nextButton,
  );
}

Future<void> showAddProfileSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  return showActionSheet(
    context,
    title: l10n.addProfileDialogTitle,
    entries: [
      ActionSheetItem(
        icon: IconDef.addCircle,
        title: l10n.createNewAction,
        onTap: () async {
          final name = await askProfileName(context);
          if (name == null || !context.mounted) return;
          final weapon = await context.push<Weapon?>(
            Routes.profileAddWeaponCreate,
          );
          if (weapon != null && context.mounted) {
            await ref
                .read(profilesActionsProvider.notifier)
                .createProfile(name, weapon);
          }
        },
      ),
      ActionSheetItem(
        icon: IconDef.openCollection,
        title: l10n.fromCollectionAction,
        onTap: () async {
          final name = await askProfileName(context);
          if (name == null || !context.mounted) return;
          final weapon = await context.push<Weapon?>(
            Routes.profileAddWeaponCollection,
          );
          if (weapon != null && context.mounted) {
            await ref
                .read(profilesActionsProvider.notifier)
                .createProfile(name, weapon);
          }
        },
      ),
      ActionSheetItem(
        icon: IconDef.import,
        title: l10n.actionImportFromFile,
        onTap: () => importProfileFromFile(context, ref),
      ),
    ],
  );
}

Future<void> duplicateProfileWithPrompt(
  BuildContext context,
  WidgetRef ref,
  Profile profile,
) async {
  final name = await askProfileName(context, initial: '[COPY] ${profile.name}');
  if (name == null) return;
  await ref
      .read(profilesActionsProvider.notifier)
      .duplicateProfile(profile.uuid, name);
}

Future<void> removeProfileWithConfirm(
  BuildContext context,
  WidgetRef ref,
  Profile profile,
) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showConfirmDialog(
    context,
    title: l10n.removeProfile,
    content: l10n.removeProfileContent(profile.name),
    confirmLabel: l10n.removeAction,
    isDestructive: true,
  );
  if (confirmed) {
    await ref
        .read(profilesActionsProvider.notifier)
        .removeProfile(profile.uuid);
  }
}

Future<void> showExportProfileSheet(
  BuildContext context,
  Profile profile,
) async {
  final l10n = AppLocalizations.of(context)!;
  await showActionSheet(
    context,
    title: l10n.exportFormatDialogTitle,
    entries: [
      ActionSheetItem(
        icon: IconDef.export,
        title: '.ebcp (eBalistyka)',
        onTap: () => shareProfileAsEbcp(context, profile),
      ),
      ActionSheetItem(
        icon: IconDef.export,
        title: '.a7p (Archer Ballistic Profile)',
        onTap: () => _showA7pRangeSheet(context, profile),
      ),
    ],
  );
}

Future<void> _showA7pRangeSheet(BuildContext context, Profile profile) async {
  final l10n = AppLocalizations.of(context)!;
  await showActionSheet(
    context,
    title: l10n.selectRangeDialogTitle,
    entries: [
      ActionSheetItem(
        title: l10n.rangeSubsonic,
        subtitle: '25-400m',
        onTap: () => _shareA7p(context, profile, A7pRange.subsonic),
      ),
      ActionSheetItem(
        title: l10n.rangeLow,
        subtitle: '100-700m',
        onTap: () => _shareA7p(context, profile, A7pRange.low),
      ),
      ActionSheetItem(
        title: l10n.rangeMiddle,
        subtitle: '100-1000m',
        onTap: () => _shareA7p(context, profile, A7pRange.medium),
      ),
      ActionSheetItem(
        title: l10n.rangeLong,
        subtitle: '100-1700m',
        onTap: () => _shareA7p(context, profile, A7pRange.long),
      ),
      ActionSheetItem(
        title: l10n.rangeUltraLong,
        subtitle: '100-2000m',
        onTap: () => _shareA7p(context, profile, A7pRange.ultra),
      ),
    ],
  );
}

Future<void> _shareA7p(
  BuildContext context,
  Profile profile,
  A7pRange range,
) async {
  try {
    await A7pService.shareFile(profile, range);
  } catch (e) {
    if (!context.mounted) return;
    showFeedback(context, e.toString(), isError: true);
  }
}
