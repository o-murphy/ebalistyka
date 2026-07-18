import 'package:ebalistyka/core/models/collection_item.dart';
import 'package:ebalistyka/core/providers/app_state_provider.dart';
import 'package:ebalistyka/features/home/profiles_vm.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_body.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_item_tile.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/profile_list_tile_body.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/router.dart';
import 'package:ebalistyka/shared/icons_definitions.dart';
import 'package:ebalistyka/shared/widgets/action_sheet.dart';
import 'package:ebalistyka/shared/widgets/base_screen.dart';
import 'package:ebalistyka/shared/widgets/confirm_dialog.dart';
import 'package:ebalistyka/shared/widgets/error_display.dart';
import 'package:ebalistyka/shared/widgets/help_dialog.dart';
import 'package:ebalistyka/shared/widgets/snackbars.dart';
import 'package:ebalistyka/shared/widgets/text_input_dialog.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _ProfileCollectionItem implements CollectionItem<Profile> {
  _ProfileCollectionItem({required this.ref});

  @override
  final Profile ref;

  @override
  String get id => ref.uuid;
}

class ProfilesListScreen extends ConsumerWidget {
  const ProfilesListScreen({super.key});

  Future<String?> _askProfileName(
    BuildContext context, {
    String? initial,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showTextInputDialog(
      context,
      title: l10n.newProfile,
      initialValue: initial,
      labelText: l10n.profileName,
      confirmLabel: l10n.nextButton,
    );
  }

  Future<void> _onAddTap(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return showActionSheet(
      context,
      title: l10n.addProfileDialogTitle,
      entries: [
        ActionSheetItem(
          icon: IconDef.addCircle,
          title: l10n.createNewAction,
          onTap: () async {
            final name = await _askProfileName(context);
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
            final name = await _askProfileName(context);
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
          onTap: () async => showNotAvailableSnackBar(
            context,
            l10n.actionImportFromFile,
          ),
        ),
      ],
    );
  }

  Future<void> _onRename(
    BuildContext context,
    WidgetRef ref,
    String uuid,
    String currentName,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final name = await showTextInputDialog(
      context,
      title: l10n.editProfileName,
      initialValue: currentName,
      labelText: l10n.profileName,
      confirmLabel: l10n.saveButton,
    );
    if (name == null) return;
    await ref.read(profilesActionsProvider.notifier).renameProfile(uuid, name);
  }

  Future<void> _onDuplicate(
    BuildContext context,
    WidgetRef ref,
    String uuid,
    String currentName,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final name = await _askProfileName(
      context,
      initial: '${l10n.copyOf} $currentName',
    );
    if (name == null) return;
    await ref
        .read(profilesActionsProvider.notifier)
        .duplicateProfile(uuid, name);
  }

  Future<void> _onRemove(
    BuildContext context,
    WidgetRef ref,
    String uuid,
    String name,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.removeProfile,
      content: l10n.removeProfileContent(name),
      confirmLabel: l10n.removeAction,
      isDestructive: true,
    );
    if (confirmed) {
      await ref.read(profilesActionsProvider.notifier).removeProfile(uuid);
    }
  }

  Future<void> _onSelect(BuildContext context, WidgetRef ref, String uuid) async {
    await ref.read(profilesActionsProvider.notifier).selectProfile(uuid);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStateAsync = ref.watch(appStateProvider);
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      title: l10n.profilesListScreenTitle,
      isSubscreen: true,
      actions: [HelpAction(HelpData.profilesScreen)],
      floatingActionButton: FloatingActionButton(
        heroTag: 'generalFab',
        onPressed: () => _onAddTap(context, ref),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 6,
        child: const Icon(IconDef.add),
      ),
      body: appStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(error: error),
        data: (state) {
          final activeUuid = state.activeProfile?.uuid;

          return BaseCollectionBody(
            tiles: state.profiles
                .map(
                  (profile) => CollectionItemTile(
                    key: ValueKey(profile.uuid),
                    body: ProfileListTileBody(
                      profile: profile,
                      isActive: profile.uuid == activeUuid,
                    ),
                    item: _ProfileCollectionItem(ref: profile),
                    isSelected: profile.uuid == activeUuid,
                    searchText: [profile.name, profile.weapon.name].join(' '),
                    onSelect: () => _onSelect(context, ref, profile.uuid),
                    onEdit: () =>
                        _onRename(context, ref, profile.uuid, profile.name),
                    onDuplicate: () =>
                        _onDuplicate(context, ref, profile.uuid, profile.name),
                    onExport: () => showNotAvailableSnackBar(
                      context,
                      l10n.exportAction,
                    ),
                    onRemove: () =>
                        _onRemove(context, ref, profile.uuid, profile.name),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
