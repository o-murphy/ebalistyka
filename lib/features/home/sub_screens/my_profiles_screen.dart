import 'package:ebalistyka/core/providers/app_state_provider.dart';
import 'package:ebalistyka/core/services/a7p_converter.dart';
import 'package:ebalistyka/core/services/a7p_service.dart';
import 'package:ebalistyka/features/home/profiles_vm.dart';
import 'package:ebalistyka/features/home/sub_screens/profile_ebcp_actions.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/profile_control_tile.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/profile_sections.dart';
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
import 'package:dart_bclibc/unit.dart';
import 'package:ebalistyka/core/providers/formatter_provider.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  Future<String?> _askProfileName(BuildContext context, {String? initial}) {
    final l10n = AppLocalizations.of(context)!;
    return showTextInputDialog(
      context,
      title: l10n.newProfile,
      initialValue: initial,
      labelText: l10n.profileName,
      confirmLabel: l10n.nextButton,
    );
  }

  /// Warns that swapping in a new weapon/ammo/sight discards whatever is
  /// currently there, and offers a way out: duplicate the profile first
  /// (auto-named `[COPY] <name>`, no extra prompt — this is a one-tap
  /// escape hatch, not the deliberate "Duplicate" action) and apply the
  /// hotswap to the copy instead. The copy is made active immediately —
  /// otherwise the hotswap would land on a profile that isn't the one on
  /// screen, and the *original* (now untouched) would still be showing,
  /// making it look like nothing happened. Returns the uuid the hotswap
  /// should target, or null if the sheet was dismissed without a choice.
  Future<String?> _resolveHotswapTargetUuid(
    BuildContext context,
    WidgetRef ref,
    Profile profile, {
    required bool hasExisting,
    required String warningTitle,
    required String warningContent,
  }) async {
    if (!hasExisting) return profile.uuid;

    final l10n = AppLocalizations.of(context)!;
    String? targetUuid;
    await showActionSheet(
      context,
      title: warningTitle,
      subtitle: warningContent,
      entries: [
        ActionSheetItem(
          icon: IconDef.copy,
          title: l10n.duplicateAction,
          onTap: () async {
            final uuid = await ref
                .read(profilesActionsProvider.notifier)
                .duplicateProfile(profile.uuid, '[COPY] ${profile.name}');
            if (uuid != null) {
              await ref
                  .read(profilesActionsProvider.notifier)
                  .selectProfile(uuid);
            }
            targetUuid = uuid;
          },
        ),
        ActionSheetItem(
          icon: IconDef.replace,
          title: l10n.replaceAction,
          isDestructive: true,
          onTap: () async {
            targetUuid = profile.uuid;
          },
        ),
      ],
    );
    return targetUuid;
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
          onTap: () => importProfileFromFile(context, ref),
        ),
      ],
    );
  }

  Future<void> _onEditWeapon(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final result = await context.push<Weapon?>(
      Routes.profileEditWeapon,
      extra: profile.weapon,
    );
    if (result != null && context.mounted) {
      await ref
          .read(appStateProvider.notifier)
          .setProfileWeapon(profile.uuid, result);
    }
  }

  Future<void> _onEditAmmo(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final weapon = profile.weapon;
    final result = await context.push<Ammo?>(
      Routes.profileEditAmmo,
      extra: (
        profile.ammo,
        weapon.hasCaliberInch() ? weapon.caliberInch : null,
        profile.uuid,
      ),
    );
    if (result != null && context.mounted) {
      await ref
          .read(appStateProvider.notifier)
          .setProfileAmmo(profile.uuid, result);
    }
  }

  Future<void> _onEditSight(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final result = await context.push<Sight?>(
      Routes.profileEditSight,
      extra: profile.sight,
    );
    if (result != null && context.mounted) {
      await ref
          .read(appStateProvider.notifier)
          .setProfileSight(profile.uuid, result);
    }
  }

  /// After swapping in a new weapon, if the target profile already has ammo
  /// whose caliber no longer matches the new weapon, offer to update the
  /// ammo's caliber to match — mirrors [AmmoWizardScreen]'s own
  /// caliber-mismatch sheet, just triggered from the weapon side instead of
  /// the ammo side. [targetUuid]/[currentAmmo] are the profile the hotswap
  /// actually landed on (the original, or its duplicate — see
  /// [_resolveHotswapTargetUuid]), not necessarily the profile the sheet was
  /// opened from.
  Future<void> _maybeWarnWeaponAmmoCaliberMismatch(
    BuildContext context,
    WidgetRef ref,
    String targetUuid,
    Ammo currentAmmo,
    Weapon newWeapon,
  ) async {
    if (currentAmmo.name.isEmpty) return;
    if (!newWeapon.hasCaliberInch() || !currentAmmo.hasCaliberInch()) return;
    final weaponCaliberInch = newWeapon.caliberInch;
    final ammoCaliberInch = currentAmmo.caliberInch;
    if ((weaponCaliberInch - ammoCaliberInch).abs() < 0.0001) return;
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final formatter = ref.read(unitFormatterProvider);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.caliberMismatchTitle,
      content: l10n.weaponAmmoCaliberMismatchContent(
        formatter.diameter(Distance.inch(weaponCaliberInch)),
        formatter.diameter(Distance.inch(ammoCaliberInch)),
      ),
      confirmLabel: l10n.updateAmmoCaliberAction,
    );
    if (confirmed && context.mounted) {
      final updatedAmmo = currentAmmo.deepCopy()
        ..caliberInch = weaponCaliberInch;
      await ref
          .read(appStateProvider.notifier)
          .setProfileAmmo(targetUuid, updatedAmmo);
    }
  }

  Future<void> _onReplaceWeapon(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final targetUuid = await _resolveHotswapTargetUuid(
      context,
      ref,
      profile,
      hasExisting: profile.weapon.name.isNotEmpty,
      warningTitle: l10n.replaceWeaponWarningTitle,
      warningContent: l10n.replaceWeaponWarningContent,
    );
    if (targetUuid == null || !context.mounted) return;

    Future<void> replace(Future<Weapon?> Function() pick) async {
      final result = await pick();
      if (result != null && context.mounted) {
        await ref
            .read(appStateProvider.notifier)
            .setProfileWeapon(targetUuid, result);
        if (!context.mounted) return;
        await _maybeWarnWeaponAmmoCaliberMismatch(
          context,
          ref,
          targetUuid,
          profile.ammo,
          result,
        );
      }
    }

    return showActionSheet(
      context,
      title: l10n.actionAddWeapon,
      entries: [
        ActionSheetItem(
          icon: IconDef.addCircle,
          title: l10n.createNewAction,
          onTap: () => replace(
            () => context.push<Weapon?>(Routes.profileAddWeaponCreate),
          ),
        ),
        ActionSheetItem(
          icon: IconDef.openCollection,
          title: l10n.fromCollectionAction,
          onTap: () => replace(
            () => context.push<Weapon?>(Routes.profileAddWeaponCollection),
          ),
        ),
        ActionSheetItem(
          icon: IconDef.import,
          title: l10n.actionImportFromFile,
          onTap: () => replace(() async {
            try {
              final imported = await A7pService.pickAndParse();
              return imported?.weapon;
            } catch (e) {
              debugPrint('Weapon import failed: $e');
              if (context.mounted) {
                showFeedback(context, e.toString(), isError: true);
              }
              return null;
            }
          }),
        ),
      ],
    );
  }

  Future<void> _onReplaceAmmo(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final weapon = profile.weapon;
    final defaultCaliberInch = weapon.hasCaliberInch()
        ? weapon.caliberInch
        : null;

    final targetUuid = await _resolveHotswapTargetUuid(
      context,
      ref,
      profile,
      hasExisting: profile.ammo.name.isNotEmpty,
      warningTitle: l10n.replaceAmmoWarningTitle,
      warningContent: l10n.replaceAmmoWarningContent,
    );
    if (targetUuid == null || !context.mounted) return;

    Future<void> replace(Future<Ammo?> Function() pick) async {
      final result = await pick();
      if (result != null && context.mounted) {
        await ref
            .read(appStateProvider.notifier)
            .setProfileAmmo(targetUuid, result);
      }
    }

    return showActionSheet(
      context,
      title: l10n.actionAddAmmo,
      entries: [
        ActionSheetItem(
          icon: IconDef.addCircle,
          title: l10n.createNewAction,
          onTap: () => replace(
            () => context.push<Ammo?>(
              Routes.ammoCreate,
              extra: defaultCaliberInch,
            ),
          ),
        ),
        ActionSheetItem(
          icon: IconDef.openCollection,
          title: l10n.selectCartridgeFromCollection,
          onTap: () => replace(() async {
            final template = await context.push<Ammo?>(
              Routes.cartridgeCollection,
              extra: defaultCaliberInch,
            );
            if (template == null || !context.mounted) return null;
            return context.push<Ammo?>(
              Routes.profileEditAmmo,
              extra: (template, defaultCaliberInch, targetUuid),
            );
          }),
        ),
        ActionSheetItem(
          icon: IconDef.openCollection,
          title: l10n.selectBulletFromCollection,
          onTap: () => replace(() async {
            final template = await context.push<Ammo?>(
              Routes.bulletCollection,
              extra: defaultCaliberInch,
            );
            if (template == null || !context.mounted) return null;
            return context.push<Ammo?>(
              Routes.profileEditAmmo,
              extra: (template, defaultCaliberInch, targetUuid),
            );
          }),
        ),
        ActionSheetItem(
          icon: IconDef.import,
          title: l10n.actionImportFromFile,
          onTap: () => replace(() async {
            try {
              final imported = await A7pService.pickAndParse();
              return imported?.ammo;
            } catch (e) {
              debugPrint('Ammo import failed: $e');
              if (context.mounted) showFeedback(context, e.toString(), isError: true);
              return null;
            }
          }),
        ),
      ],
    );
  }

  Future<void> _onReplaceSight(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final targetUuid = await _resolveHotswapTargetUuid(
      context,
      ref,
      profile,
      hasExisting: profile.sight.name.isNotEmpty,
      warningTitle: l10n.replaceSightWarningTitle,
      warningContent: l10n.replaceSightWarningContent,
    );
    if (targetUuid == null || !context.mounted) return;

    Future<void> replace(Future<Sight?> Function() pick) async {
      final result = await pick();
      if (result != null && context.mounted) {
        await ref
            .read(appStateProvider.notifier)
            .setProfileSight(targetUuid, result);
      }
    }

    return showActionSheet(
      context,
      title: l10n.actionAddSight,
      entries: [
        ActionSheetItem(
          icon: IconDef.addCircle,
          title: l10n.createNewAction,
          onTap: () => replace(() => context.push<Sight?>(Routes.sightCreate)),
        ),
        ActionSheetItem(
          icon: IconDef.openCollection,
          title: l10n.actionSelectSightFromCollection,
          onTap: () => replace(
            () => context.push<Sight?>(Routes.sightCollection),
          ),
        ),
        ActionSheetItem(
          icon: IconDef.import,
          title: l10n.actionImportFromFile,
          onTap: () => replace(() async {
            try {
              final imported = await A7pService.pickAndParse();
              return imported?.sight;
            } catch (e) {
              debugPrint('Sight import failed: $e');
              if (context.mounted) showFeedback(context, e.toString(), isError: true);
              return null;
            }
          }),
        ),
      ],
    );
  }

  Future<void> _onDuplicate(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final name = await _askProfileName(
      context,
      initial: '[COPY] ${profile.name}',
    );
    if (name == null) return;
    await ref
        .read(profilesActionsProvider.notifier)
        .duplicateProfile(profile.uuid, name);
  }

  Future<void> _onRemove(
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

  Future<void> _onExport(BuildContext context, Profile profile) async {
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
          onTap: () => _onExportA7p(context, profile),
        ),
      ],
    );
  }

  Future<void> _onExportA7p(BuildContext context, Profile profile) async {
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

  Future<void> _onRename(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
    String name,
  ) async {
    await ref
        .read(profilesActionsProvider.notifier)
        .renameProfile(profile.uuid, name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStateAsync = ref.watch(appStateProvider);
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      title: l10n.myProfile,
      actions: [
        IconButton(
          onPressed: () => context.push(Routes.profilesList),
          icon: const Icon(IconDef.profilesList),
        ),
        HelpAction(HelpData.profilesScreen),
      ],
      floatingActionButton: appStateAsync.value?.profiles.isEmpty ?? false
          ? FloatingActionButton(
              heroTag: 'generalFab',
              onPressed: () => _onAddTap(context, ref),
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              elevation: 6,
              child: const Icon(IconDef.add),
            )
          : null,
      body: appStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(error: error),
        data: (state) {
          final profile = state.activeProfile;
          if (profile == null) {
            return Center(child: Text(l10n.noProfiles));
          }

          final data = ref.watch(profileCardProvider(profile.uuid));
          if (data == null) return const SizedBox.shrink();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  children: [
                    ProfileControlTile(
                      profileId: profile.uuid,
                      profileName: data.name,
                      weaponImage: data.weaponImage,
                      hasWeapon: profile.weapon.name.isNotEmpty,
                      hasAmmo: profile.ammo.name.isNotEmpty,
                      hasSight: profile.sight.name.isNotEmpty,
                      onDuplicate: () => _onDuplicate(context, ref, profile),
                      onExport: () => _onExport(context, profile),
                      onSelectWeapon: () =>
                          _onReplaceWeapon(context, ref, profile),
                      onSelectAmmo: () => _onReplaceAmmo(context, ref, profile),
                      onSelectSight: () =>
                          _onReplaceSight(context, ref, profile),
                      onRemove: () => _onRemove(context, ref, profile),
                      onRename: (name) =>
                          _onRename(context, ref, profile, name),
                    ),
                    if (profile.weapon.name.isNotEmpty)
                      ProfileWeaponSection(
                        data: data,
                        onEdit: () => _onEditWeapon(context, ref, profile),
                      ),
                    if (profile.ammo.name.isNotEmpty)
                      ProfileAmmoSection(
                        data: data,
                        onEdit: () => _onEditAmmo(context, ref, profile),
                      ),
                    if (profile.sight.name.isNotEmpty)
                      ProfileSightSection(
                        data: data,
                        onEdit: () => _onEditSight(context, ref, profile),
                      ),
                  ],
                ),
              ),
              if (!data.isReadyForCalculation)
                _IncompleteProfileBanner(hint: l10n.selectAmmoSightHint),
            ],
          );
        },
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _IncompleteProfileBanner extends StatelessWidget {
  const _IncompleteProfileBanner({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ColoredBox(
      color: cs.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            hint,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onErrorContainer),
          ),
        ),
      ),
    );
  }
}
