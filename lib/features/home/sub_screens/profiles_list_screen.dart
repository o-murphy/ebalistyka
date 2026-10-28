import 'package:ebalistyka/core/models/collection_item.dart';
import 'package:ebalistyka/core/providers/app_state_provider.dart';
import 'package:ebalistyka/features/home/profiles_vm.dart';
import 'package:ebalistyka/features/home/sub_screens/profile_actions.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_body.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_item_tile.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/profile_list_tile_body.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/icons_definitions.dart';
import 'package:ebalistyka/shared/widgets/error_display.dart';
import 'package:ebalistyka/shared/widgets/text_input_dialog.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _ProfileCollectionItem implements CollectionItem<Profile> {
  _ProfileCollectionItem({required this.ref});

  @override
  final Profile ref;

  @override
  String get id => ref.uuid;
}

class ProfilesListScreen extends ConsumerWidget {
  const ProfilesListScreen({super.key});

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

  Future<void> _onSelect(BuildContext context, WidgetRef ref, String uuid) async {
    await ref.read(profilesActionsProvider.notifier).selectProfile(uuid);
    // Embedded as the "My Profiles" tab (see my_profiles_screen.dart) rather
    // than pushed as its own route — switch back to the "My Profile" tab
    // instead of popping.
    if (context.mounted) DefaultTabController.of(context).animateTo(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStateAsync = ref.watch(appStateProvider);
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        appStateAsync.when(
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
                      ),
                      item: _ProfileCollectionItem(ref: profile),
                      isSelected: profile.uuid == activeUuid,
                      searchText: [
                        profile.name,
                        profile.weapon.name,
                      ].join(' '),
                      onSelect: () => _onSelect(context, ref, profile.uuid),
                      onEdit: () =>
                          _onRename(context, ref, profile.uuid, profile.name),
                      editLabel: l10n.editProfileName,
                      onDuplicate: () =>
                          duplicateProfileWithPrompt(context, ref, profile),
                      onExport: () => showExportProfileSheet(context, profile),
                      onRemove: () =>
                          removeProfileWithConfirm(context, ref, profile),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'profilesListFab',
            onPressed: () => showAddProfileSheet(context, ref),
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 6,
            child: const Icon(IconDef.add),
          ),
        ),
      ],
    );
  }
}
