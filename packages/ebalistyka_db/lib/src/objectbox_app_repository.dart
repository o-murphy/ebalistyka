import 'dart:typed_data';

import 'package:ebalistyka_db/objectbox.g.dart';
import 'package:ebalistyka_db/src/entities.dart';
import 'package:ebalistyka_db/src/export/ammo_export.dart';
import 'package:ebalistyka_db/src/export/profile_export.dart';
import 'package:ebalistyka_db/src/export/sight_export.dart';
import 'package:ebalistyka_db/src/repository.dart';

class ObjectBoxAppRepository implements IAppRepository {
  final Store _store;
  ObjectBoxAppRepository(this._store);

  @override
  Future<Owner> ensureOwner(String token) async {
    final box = _store.box<Owner>();
    final existing = box.query(Owner_.token.equals(token)).build().findFirst();
    if (existing != null) return existing;
    final owner = Owner()..token = token;
    box.put(owner);
    return owner;
  }

  @override
  Stream<void> watchOwner(int ownerId) => _store
      .box<Owner>()
      .query(Owner_.id.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Stream<void> watchWeapons(int ownerId) => _store
      .box<Weapon>()
      .query(Weapon_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Stream<void> watchAmmo(int ownerId) => _store
      .box<Ammo>()
      .query(Ammo_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Stream<void> watchSights(int ownerId) => _store
      .box<Sight>()
      .query(Sight_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Stream<void> watchProfiles(int ownerId) => _store
      .box<Profile>()
      .query(Profile_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Future<List<Weapon>> loadWeapons(int ownerId) async =>
      _store.box<Weapon>().query(Weapon_.owner.equals(ownerId)).build().find();

  @override
  Future<List<Ammo>> loadAmmo(int ownerId) async =>
      _store.box<Ammo>().query(Ammo_.owner.equals(ownerId)).build().find();

  @override
  Future<List<Sight>> loadSights(int ownerId) async =>
      _store.box<Sight>().query(Sight_.owner.equals(ownerId)).build().find();

  @override
  Future<List<Profile>> loadProfiles(int ownerId) async =>
      _store.box<Profile>().query(Profile_.owner.equals(ownerId)).build().find();

  @override
  Future<int> getActiveProfileId(int ownerId) async {
    final owner = _store.box<Owner>().get(ownerId);
    return owner?.activeProfile.targetId ?? 0;
  }

  @override
  Future<void> setActiveProfileId(int ownerId, int profileId) async {
    final owner = _store.box<Owner>().get(ownerId);
    if (owner == null) return;
    owner.activeProfile.targetId = profileId;
    _store.box<Owner>().put(owner);
  }

  @override
  Future<bool> needsSeed(int ownerId) async {
    return _store
            .box<Weapon>()
            .query(Weapon_.owner.equals(ownerId))
            .build()
            .count() ==
        0;
  }

  // ── Ammo ──────────────────────────────────────────────────────────────────────

  @override
  Future<int> saveAmmo(Ammo ammo, int ownerId) async {
    final owner = _store.box<Owner>().get(ownerId);
    ammo.owner.target = owner;
    return _store.box<Ammo>().put(ammo);
  }

  @override
  Future<int> duplicateAmmo(int id, String newName, int ownerId) async {
    final original = _store.box<Ammo>().get(id);
    if (original == null) return 0;
    final owner = _store.box<Owner>().get(ownerId);
    final copy = Ammo()
      ..name = newName
      ..caliberInch = original.caliberInch
      ..weightGrain = original.weightGrain
      ..lengthInch = original.lengthInch
      ..dragTypeValue = original.dragTypeValue
      ..bcG1 = original.bcG1
      ..bcG7 = original.bcG7
      ..useMultiBcG1 = original.useMultiBcG1
      ..useMultiBcG7 = original.useMultiBcG7
      ..muzzleVelocityMps = original.muzzleVelocityMps
      ..muzzleVelocityTemperatureC = original.muzzleVelocityTemperatureC
      ..powderSensitivityFrac = original.powderSensitivityFrac
      ..usePowderSensitivity = original.usePowderSensitivity
      ..powderSensitivityTC = original.powderSensitivityTC != null
          ? Float64List.fromList(original.powderSensitivityTC!)
          : null
      ..powderSensitivityVMps = original.powderSensitivityVMps != null
          ? Float64List.fromList(original.powderSensitivityVMps!)
          : null
      ..multiBcTableG1VMps = original.multiBcTableG1VMps != null
          ? Float64List.fromList(original.multiBcTableG1VMps!)
          : null
      ..multiBcTableG1Bc = original.multiBcTableG1Bc != null
          ? Float64List.fromList(original.multiBcTableG1Bc!)
          : null
      ..multiBcTableG7VMps = original.multiBcTableG7VMps != null
          ? Float64List.fromList(original.multiBcTableG7VMps!)
          : null
      ..multiBcTableG7Bc = original.multiBcTableG7Bc != null
          ? Float64List.fromList(original.multiBcTableG7Bc!)
          : null
      ..customDragTableMach = original.customDragTableMach != null
          ? Float64List.fromList(original.customDragTableMach!)
          : null
      ..customDragTableCd = original.customDragTableCd != null
          ? Float64List.fromList(original.customDragTableCd!)
          : null
      ..zeroDistanceMeter = original.zeroDistanceMeter
      ..zeroLookAngleRad = original.zeroLookAngleRad
      ..zeroAltitudeMeter = original.zeroAltitudeMeter
      ..zeroTemperatureC = original.zeroTemperatureC
      ..zeroPressurehPa = original.zeroPressurehPa
      ..zeroHumidityFrac = original.zeroHumidityFrac
      ..zeroPowderTemperatureC = original.zeroPowderTemperatureC
      ..zeroUseDiffPowderTemperature = original.zeroUseDiffPowderTemperature
      ..zeroUseCoriolis = original.zeroUseCoriolis
      ..zeroLatitudeDeg = original.zeroLatitudeDeg
      ..zeroAzimuthDeg = original.zeroAzimuthDeg
      ..zeroOffsetX = original.zeroOffsetX
      ..zeroOffsetY = original.zeroOffsetY
      ..zeroOffsetXUnit = original.zeroOffsetXUnit
      ..zeroOffsetYUnit = original.zeroOffsetYUnit
      ..projectileName = original.projectileName
      ..vendor = original.vendor
      ..owner.target = owner;
    return _store.box<Ammo>().put(copy);
  }

  @override
  Future<void> deleteAmmo(int id) async {
    _store.runInTransaction(TxMode.write, () {
      final linked = _store
          .box<Profile>()
          .query(Profile_.ammo.equals(id))
          .build()
          .find();
      for (final p in linked) {
        p.ammo.targetId = 0;
        _store.box<Profile>().put(p);
      }
      _store.box<Ammo>().remove(id);
    });
  }

  @override
  Future<int> importAmmo(AmmoExport export, int ownerId) async {
    final owner = _store.box<Owner>().get(ownerId);
    final ammo = export.toEntity()..owner.target = owner;
    return _store.box<Ammo>().put(ammo);
  }

  @override
  Future<Ammo?> getAmmo(int id) async => _store.box<Ammo>().get(id);

  // ── Weapon ────────────────────────────────────────────────────────────────────

  @override
  Future<int> saveWeapon(Weapon weapon, int ownerId) async {
    final owner = _store.box<Owner>().get(ownerId);
    weapon.owner.target = owner;
    return _store.box<Weapon>().put(weapon);
  }

  @override
  Future<Weapon?> getWeapon(int id) async => _store.box<Weapon>().get(id);

  // ── Sight ─────────────────────────────────────────────────────────────────────

  @override
  Future<int> saveSight(Sight sight, int ownerId) async {
    final owner = _store.box<Owner>().get(ownerId);
    sight.owner.target = owner;
    return _store.box<Sight>().put(sight);
  }

  @override
  Future<int> duplicateSight(int id, String newName, int ownerId) async {
    final original = _store.box<Sight>().get(id);
    if (original == null) return 0;
    final owner = _store.box<Owner>().get(ownerId);
    final copy = Sight()
      ..name = newName
      ..focalPlaneValue = original.focalPlaneValue
      ..sightHeightInch = original.sightHeightInch
      ..sightHorizontalOffsetInch = original.sightHorizontalOffsetInch
      ..verticalClick = original.verticalClick
      ..horizontalClick = original.horizontalClick
      ..verticalClickUnit = original.verticalClickUnit
      ..horizontalClickUnit = original.horizontalClickUnit
      ..minMagnification = original.minMagnification
      ..maxMagnification = original.maxMagnification
      ..reticleImage = original.reticleImage
      ..vendor = original.vendor
      ..notes = original.notes
      ..owner.target = owner;
    return _store.box<Sight>().put(copy);
  }

  @override
  Future<void> deleteSight(int id) async {
    _store.runInTransaction(TxMode.write, () {
      final linked = _store
          .box<Profile>()
          .query(Profile_.sight.equals(id))
          .build()
          .find();
      for (final p in linked) {
        p.sight.targetId = 0;
        _store.box<Profile>().put(p);
      }
      _store.box<Sight>().remove(id);
    });
  }

  @override
  Future<int> importSight(SightExport export, int ownerId) async {
    final owner = _store.box<Owner>().get(ownerId);
    final sight = export.toEntity()..owner.target = owner;
    return _store.box<Sight>().put(sight);
  }

  // ── Profile ───────────────────────────────────────────────────────────────────

  @override
  Future<void> setProfileAmmo(int profileId, int ammoId) async {
    final profile = _store.box<Profile>().get(profileId);
    if (profile == null) return;
    profile.ammo.targetId = ammoId;
    _store.box<Profile>().put(profile);
  }

  @override
  Future<void> setProfileSight(int profileId, int sightId) async {
    final profile = _store.box<Profile>().get(profileId);
    if (profile == null) return;
    profile.sight.targetId = sightId;
    _store.box<Profile>().put(profile);
  }

  @override
  Future<int> saveProfile(Profile profile, int ownerId) async {
    final owner = _store.box<Owner>().get(ownerId);
    profile.owner.target = owner;
    return _store.box<Profile>().put(profile);
  }

  @override
  Future<int> createProfile(String name, Weapon weapon, int ownerId) async {
    int profileId = 0;
    final owner = _store.box<Owner>().get(ownerId);
    _store.runInTransaction(TxMode.write, () {
      weapon.owner.target = owner;
      _store.box<Weapon>().put(weapon);
      final profile = Profile()
        ..name = name
        ..weapon.target = weapon
        ..owner.target = owner;
      profileId = _store.box<Profile>().put(profile);
    });
    return profileId;
  }

  @override
  Future<int> duplicateProfile(int id, String newName, int ownerId) async {
    int newProfileId = 0;
    final owner = _store.box<Owner>().get(ownerId);
    _store.runInTransaction(TxMode.write, () {
      final original = _store.box<Profile>().get(id);
      if (original == null) return;
      final originalWeapon =
          _store.box<Weapon>().get(original.weapon.targetId);
      if (originalWeapon == null) return;
      final weaponCopy = Weapon()
        ..name = originalWeapon.name
        ..caliberInch = originalWeapon.caliberInch
        ..caliberName = originalWeapon.caliberName
        ..twistInch = originalWeapon.twistInch
        ..barrelLengthInch = originalWeapon.barrelLengthInch
        ..zeroElevationRad = originalWeapon.zeroElevationRad
        ..vendor = originalWeapon.vendor
        ..image = originalWeapon.image
        ..owner.target = owner;
      _store.box<Weapon>().put(weaponCopy);
      final profile = Profile()
        ..name = newName
        ..weapon.target = weaponCopy
        ..ammo.targetId = original.ammo.targetId
        ..sight.targetId = original.sight.targetId
        ..owner.target = owner;
      newProfileId = _store.box<Profile>().put(profile);
    });
    return newProfileId;
  }

  @override
  Future<int> importProfile(ProfileExport export, int ownerId) async {
    int profileId = 0;
    final owner = _store.box<Owner>().get(ownerId);
    final (profileData, weaponData, ammoData, sightData) = export.toEntities();
    _store.runInTransaction(TxMode.write, () {
      weaponData.owner.target = owner;
      _store.box<Weapon>().put(weaponData);
      if (ammoData != null) {
        ammoData.owner.target = owner;
        _store.box<Ammo>().put(ammoData);
      }
      if (sightData != null) {
        sightData.owner.target = owner;
        _store.box<Sight>().put(sightData);
      }
      profileData
        ..weapon.target = weaponData
        ..ammo.target = ammoData
        ..sight.target = sightData
        ..owner.target = owner;
      profileId = _store.box<Profile>().put(profileData);
    });
    return profileId;
  }

  @override
  Future<void> deleteProfile(int id, int ownerId) async {
    _store.runInTransaction(TxMode.write, () {
      final profile = _store.box<Profile>().get(id);
      final weaponId = profile?.weapon.targetId ?? 0;
      _store.box<Profile>().remove(id);
      if (weaponId != 0) {
        final stillLinked = _store
            .box<Profile>()
            .query(Profile_.weapon.equals(weaponId))
            .build()
            .count();
        if (stillLinked == 0) {
          _store.box<Weapon>().remove(weaponId);
        }
      }
    });
  }

  @override
  Future<Profile?> getProfile(int id) async => _store.box<Profile>().get(id);
}
