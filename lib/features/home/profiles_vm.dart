import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/shared/constants/null_string.dart';
import 'package:ebalistyka/shared/helpers/drag_model_info_formatter.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/profile_extensions.dart';
import 'package:ebalistyka/core/extensions/weapon_extensions.dart';
import 'package:ebalistyka/core/formatting/unit_formatter.dart';
import 'package:ebalistyka/core/providers/app_state_provider.dart';
import 'package:ebalistyka/core/providers/formatter_provider.dart';
import 'package:ebalistyka/core/providers/reticle_provider.dart';

// ── Profile card data ─────────────────────────────────────────────────────────
//
// Per-profile formatting DTO. Riverpod's own `select()`/`==` on the
// underlying `Profile` (protobuf deep equality) is what avoids unnecessary
// rebuilds now — no more hand-rolled fingerprint hashing of individual
// entity fields (that scaffolding existed only to work around ObjectBox
// entities not having usable value equality).

class ProfileCardData {
  const ProfileCardData({
    required this.uuid,
    required this.name,
    required this.weaponName,
    this.weaponImage,
    required this.weaponCaliber,
    required this.twist,
    required this.rightHanded,
    required this.ammoCaliber,
    required this.cartridgeName,
    required this.projectileName,
    required this.dragModel,
    required this.muzzleVelocity,
    required this.weight,
    required this.sightName,
    required this.sightHeight,
    required this.focalPlane,
    required this.reticleImage,
    required this.magnification,
    required this.verticalClick,
    required this.horizontalClick,
    required this.isReadyForCalculation,
  });

  final String uuid;
  final String name;

  final String weaponName;
  final String? weaponImage;
  final String weaponCaliber;
  final String twist;
  final bool rightHanded;

  final String ammoCaliber;
  final String cartridgeName;
  final String projectileName;
  final String dragModel;
  final String muzzleVelocity;
  final String weight;

  final String sightName;
  final String sightHeight;
  final FocalPlane focalPlane;
  final String reticleImage;
  final String magnification;
  final String verticalClick;
  final String horizontalClick;

  final bool isReadyForCalculation;

  @override
  bool operator ==(Object other) =>
      other is ProfileCardData &&
      uuid == other.uuid &&
      name == other.name &&
      weaponName == other.weaponName &&
      weaponImage == other.weaponImage &&
      weaponCaliber == other.weaponCaliber &&
      twist == other.twist &&
      rightHanded == other.rightHanded &&
      ammoCaliber == other.ammoCaliber &&
      cartridgeName == other.cartridgeName &&
      projectileName == other.projectileName &&
      dragModel == other.dragModel &&
      muzzleVelocity == other.muzzleVelocity &&
      weight == other.weight &&
      sightName == other.sightName &&
      sightHeight == other.sightHeight &&
      focalPlane == other.focalPlane &&
      reticleImage == other.reticleImage &&
      magnification == other.magnification &&
      verticalClick == other.verticalClick &&
      horizontalClick == other.horizontalClick &&
      isReadyForCalculation == other.isReadyForCalculation;

  @override
  int get hashCode => Object.hashAll([
    uuid,
    name,
    weaponName,
    weaponImage,
    weaponCaliber,
    twist,
    rightHanded,
    ammoCaliber,
    cartridgeName,
    projectileName,
    dragModel,
    muzzleVelocity,
    weight,
    sightName,
    sightHeight,
    focalPlane,
    reticleImage,
    magnification,
    verticalClick,
    horizontalClick,
    isReadyForCalculation,
  ]);
}

final profileCardProvider = Provider.autoDispose
    .family<ProfileCardData?, String>((ref, profileUuid) {
      final profiles = ref.watch(appStateProvider).value?.profiles;
      final profile = profiles?.where((p) => p.uuid == profileUuid).firstOrNull;
      if (profile == null) return null;

      final formatter = ref.read(unitFormatterProvider);
      return _buildCardData(profile, formatter);
    });

ProfileCardData _buildCardData(Profile profile, UnitFormatter formatter) {
  final weapon = profile.weapon;
  final ammo = profile.ammo;
  final sight = profile.sight;

  return ProfileCardData(
    uuid: profile.uuid,
    name: profile.name,
    weaponName: weapon.name.isNotEmpty ? weapon.name : nullStr,
    weaponImage: weapon.image,
    weaponCaliber: formatter.diameter(weapon.caliber),
    twist: weapon.twistInch.abs() > 0 ? formatter.twist(weapon.twist) : nullStr,
    rightHanded: weapon.isRightHandTwist,
    ammoCaliber: formatter.diameter(ammo.caliber),
    cartridgeName: ammo.name.isNotEmpty ? ammo.name : nullStr,
    projectileName: ammo.projectileName.isNotEmpty ? ammo.projectileName : nullStr,
    dragModel: ammo.dragModelFormattedInfo,
    muzzleVelocity: formatter.velocity(ammo.mv),
    weight: formatter.weight(ammo.weight),
    sightName: sight.name.isNotEmpty ? sight.name : nullStr,
    sightHeight: formatter.sightHeight(sight.sightHeight),
    focalPlane: sight.focalPlane,
    reticleImage: sight.reticleImage.isNotEmpty
        ? sight.reticleImage
        : defaultReticleId,
    magnification: formatter.magnificationRange(
      sight.minMagnification,
      sight.maxMagnification,
    ),
    verticalClick: formatter.click(
      sight.verticalClick,
      sight.verticalClickUnitValue,
    ),
    horizontalClick: formatter.click(
      sight.horizontalClick,
      sight.horizontalClickUnitValue,
    ),
    isReadyForCalculation: profile.isReadyForCalculation,
  );
}

// ── Profile actions ───────────────────────────────────────────────────────────

class ProfilesActions extends Notifier<void> {
  @override
  void build() {}

  Future<void> selectProfile(String uuid) async {
    await ref.read(appStateProvider.notifier).setActiveProfile(uuid);
  }

  Future<void> removeProfile(String uuid) async {
    await ref.read(appStateProvider.notifier).deleteProfile(uuid);
  }

  Future<String> createProfile(String name, Weapon weapon) async {
    return ref.read(appStateProvider.notifier).createProfile(name, weapon);
  }

  Future<String?> duplicateProfile(String uuid, String newName) async {
    return ref
        .read(appStateProvider.notifier)
        .duplicateProfile(uuid, newName);
  }

  Future<void> renameProfile(String uuid, String name) async {
    await ref.read(appStateProvider.notifier).renameProfile(uuid, name);
  }
}

final profilesActionsProvider = NotifierProvider<ProfilesActions, void>(
  ProfilesActions.new,
);
