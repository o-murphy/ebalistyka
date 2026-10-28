import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/features/home/profiles_vm.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/icons_definitions.dart';
import 'package:ebalistyka/shared/widgets/dividers.dart';
import 'package:ebalistyka/shared/widgets/info_tile.dart';
import 'package:ebalistyka/shared/widgets/list_section_tile.dart';
import 'package:material_ui/material_ui.dart';

/// "Edit" button in a section header — a labelled button, so the edit action
/// is not mistaken for a decorative icon.
class _EditButton extends StatelessWidget {
  const _EditButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(IconDef.edit, size: 14),
      label: Text(AppLocalizations.of(context)!.editAction),
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class ProfileWeaponSection extends StatelessWidget {
  const ProfileWeaponSection({
    required this.data,
    required this.onEdit,
    super.key,
  });

  final ProfileCardData data;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final twistDirIcon = data.rightHanded ? IconDef.twistR : IconDef.twistL;

    return Column(
      children: [
        ListSectionTile(
          l10n.weapon,
          onTap: onEdit,
          trailing: _EditButton(onPressed: onEdit),
        ),
        ListTile(
          leading: const Icon(IconDef.weapon),
          title: Text(data.weaponName),
          subtitle: Text(l10n.weaponName),
          dense: true,
        ),
        InfoListTile(
          label: l10n.caliber,
          value: data.weaponCaliber,
          icon: IconDef.caliber,
        ),
        InfoListTile(
          label: l10n.twistRate,
          value: data.twist,
          icon: twistDirIcon,
        ),
        InfoListTile(
          label: l10n.twistDirection,
          value: data.rightHanded ? l10n.rightHand : l10n.leftHand,
          icon: twistDirIcon,
        ),
      ],
    );
  }
}

class ProfileAmmoSection extends StatelessWidget {
  const ProfileAmmoSection({
    required this.data,
    required this.onEdit,
    super.key,
  });

  final ProfileCardData data;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const TileDivider(),
        ListSectionTile(
          l10n.ammo,
          onTap: onEdit,
          trailing: _EditButton(onPressed: onEdit),
        ),
        ListTile(
          leading: const Icon(IconDef.grain),
          title: Text(data.cartridgeName),
          subtitle: Text(l10n.cartridgeName),
          dense: true,
        ),
        ListTile(
          leading: const Icon(IconDef.grain),
          title: Text(data.projectileName),
          subtitle: Text(l10n.projectileName),
          dense: true,
        ),
        InfoListTile(
          label: l10n.dragModel,
          value: data.dragModel,
          icon: IconDef.dragModel,
        ),
        InfoListTile(
          label: l10n.muzzleVelocity,
          value: data.muzzleVelocity,
          icon: IconDef.velocity,
        ),
        InfoListTile(
          label: l10n.caliber,
          value: data.ammoCaliber,
          icon: IconDef.caliber,
        ),
        InfoListTile(
          label: l10n.weight,
          value: data.weight,
          icon: IconDef.weigth,
        ),
      ],
    );
  }
}

class ProfileSightSection extends StatelessWidget {
  const ProfileSightSection({
    required this.data,
    required this.onEdit,
    super.key,
  });

  final ProfileCardData data;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final fpIcon = switch (data.focalPlane) {
      FocalPlane.ffp => IconDef.ffp,
      FocalPlane.sfp => IconDef.sfp,
      FocalPlane.lwir => IconDef.lwir,
    };

    return Column(
      children: [
        const TileDivider(),
        ListSectionTile(
          l10n.sight,
          onTap: onEdit,
          trailing: _EditButton(onPressed: onEdit),
        ),
        ListTile(
          leading: const Icon(IconDef.sight),
          title: Text(data.sightName),
          subtitle: Text(l10n.sightName),
          dense: true,
        ),
        InfoListTile(
          label: l10n.sightHeight,
          value: data.sightHeight,
          icon: IconDef.height,
        ),
        InfoListTile(
          label: l10n.reticle,
          value: data.reticleImage,
          icon: IconDef.sight,
        ),
        InfoListTile(
          label: l10n.focalPlane,
          value: data.focalPlane.name.toUpperCase(),
          icon: fpIcon,
        ),
        InfoListTile(
          label: l10n.magnification,
          value: data.magnification,
          icon: IconDef.magnificationMax,
        ),
        InfoListTile(
          label: l10n.verticalClick,
          value: data.verticalClick,
          icon: IconDef.verticalClick,
        ),
        InfoListTile(
          label: l10n.horizontalClick,
          value: data.horizontalClick,
          icon: IconDef.horizontalClick,
        ),
      ],
    );
  }
}
