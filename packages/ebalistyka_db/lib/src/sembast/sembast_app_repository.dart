import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:ebalistyka_db/src/entities.dart';
import 'package:ebalistyka_db/src/export/ammo_export.dart';
import 'package:ebalistyka_db/src/export/profile_export.dart';
import 'package:ebalistyka_db/src/export/sight_export.dart';
import 'package:ebalistyka_db/src/repository.dart';
import 'package:sembast/sembast.dart';

class SembastAppRepository implements IAppRepository {
  final Database _db;

  final _ownerStore = intMapStoreFactory.store('owners');
  final _weaponStore = intMapStoreFactory.store('weapons');
  final _ammoStore = intMapStoreFactory.store('ammo');
  final _sightStore = intMapStoreFactory.store('sights');
  final _profileStore = intMapStoreFactory.store('profiles');

  SembastAppRepository(this._db);

  // ── Owner ─────────────────────────────────────────────────────────────────────

  @override
  Future<Owner> ensureOwner(String token) async {
    final existing = await _ownerStore.findFirst(
      _db,
      finder: Finder(filter: Filter.equals('token', token)),
    );
    if (existing != null) {
      return Owner()
        ..id = existing.key
        ..token = token;
    }
    final id = await _ownerStore.add(_db, {
      'token': token,
      'activeProfileId': 0,
    });
    return Owner()
      ..id = id
      ..token = token;
  }

  @override
  Stream<void> watchOwner(int ownerId) => _ownerStore
      .record(ownerId)
      .onSnapshot(_db)
      .map((_) => null);

  @override
  Stream<void> watchWeapons(int ownerId) => _weaponStore
      .query(finder: Finder(filter: Filter.equals('ownerId', ownerId)))
      .onSnapshots(_db)
      .map((_) => null);

  @override
  Stream<void> watchAmmo(int ownerId) => _ammoStore
      .query(finder: Finder(filter: Filter.equals('ownerId', ownerId)))
      .onSnapshots(_db)
      .map((_) => null);

  @override
  Stream<void> watchSights(int ownerId) => _sightStore
      .query(finder: Finder(filter: Filter.equals('ownerId', ownerId)))
      .onSnapshots(_db)
      .map((_) => null);

  @override
  Stream<void> watchProfiles(int ownerId) => _profileStore
      .query(finder: Finder(filter: Filter.equals('ownerId', ownerId)))
      .onSnapshots(_db)
      .map((_) => null);

  // ── Load ──────────────────────────────────────────────────────────────────────

  @override
  Future<List<Weapon>> loadWeapons(int ownerId) async {
    final records = await _weaponStore.find(
      _db,
      finder: Finder(filter: Filter.equals('ownerId', ownerId)),
    );
    return records.map((r) => _weaponFromMap(r.key, r.value)).toList();
  }

  @override
  Future<List<Ammo>> loadAmmo(int ownerId) async {
    final records = await _ammoStore.find(
      _db,
      finder: Finder(filter: Filter.equals('ownerId', ownerId)),
    );
    return records.map((r) => _ammoFromMap(r.key, r.value)).toList();
  }

  @override
  Future<List<Sight>> loadSights(int ownerId) async {
    final records = await _sightStore.find(
      _db,
      finder: Finder(filter: Filter.equals('ownerId', ownerId)),
    );
    return records.map((r) => _sightFromMap(r.key, r.value)).toList();
  }

  @override
  Future<List<Profile>> loadProfiles(int ownerId) async {
    final weapons = await loadWeapons(ownerId);
    final ammoList = await loadAmmo(ownerId);
    final sights = await loadSights(ownerId);

    final records = await _profileStore.find(
      _db,
      finder: Finder(filter: Filter.equals('ownerId', ownerId)),
    );
    return records.map((r) {
      final p = _profileFromMap(r.key, r.value);
      _stitchProfile(p, weapons, ammoList, sights);
      return p;
    }).toList();
  }

  @override
  Future<int> getActiveProfileId(int ownerId) async {
    final record = await _ownerStore.record(ownerId).get(_db);
    return record?['activeProfileId'] as int? ?? 0;
  }

  @override
  Future<void> setActiveProfileId(int ownerId, int profileId) async {
    await _ownerStore.record(ownerId).update(_db, {'activeProfileId': profileId});
  }

  @override
  Future<bool> needsSeed(int ownerId) async {
    final count = await _weaponStore.count(
      _db,
      filter: Filter.equals('ownerId', ownerId),
    );
    return count == 0;
  }

  // ── Ammo ──────────────────────────────────────────────────────────────────────

  @override
  Future<int> saveAmmo(Ammo ammo, int ownerId) async {
    final map = _ammoToMap(ammo, ownerId);
    if (ammo.id == 0) {
      final id = await _ammoStore.add(_db, map);
      ammo.id = id;
      return id;
    }
    await _ammoStore.record(ammo.id).put(_db, map);
    return ammo.id;
  }

  @override
  Future<int> duplicateAmmo(int id, String newName, int ownerId) async {
    final record = await _ammoStore.record(id).get(_db);
    if (record == null) return 0;
    final copy = Map<String, dynamic>.from(record)
      ..['name'] = newName
      ..remove('id');
    return _ammoStore.add(_db, copy);
  }

  @override
  Future<void> deleteAmmo(int id) async {
    await _db.transaction((txn) async {
      final linked = await _profileStore.find(
        txn,
        finder: Finder(filter: Filter.equals('ammoId', id)),
      );
      for (final p in linked) {
        await _profileStore.record(p.key).update(txn, {'ammoId': 0});
      }
      await _ammoStore.record(id).delete(txn);
    });
  }

  @override
  Future<int> importAmmo(AmmoExport export, int ownerId) async {
    final ammo = export.toEntity();
    return saveAmmo(ammo, ownerId);
  }

  @override
  Future<Ammo?> getAmmo(int id) async {
    final record = await _ammoStore.record(id).get(_db);
    if (record == null) return null;
    return _ammoFromMap(id, record);
  }

  // ── Weapon ────────────────────────────────────────────────────────────────────

  @override
  Future<int> saveWeapon(Weapon weapon, int ownerId) async {
    final map = _weaponToMap(weapon, ownerId);
    if (weapon.id == 0) {
      final id = await _weaponStore.add(_db, map);
      weapon.id = id;
      return id;
    }
    await _weaponStore.record(weapon.id).put(_db, map);
    return weapon.id;
  }

  @override
  Future<Weapon?> getWeapon(int id) async {
    final record = await _weaponStore.record(id).get(_db);
    if (record == null) return null;
    return _weaponFromMap(id, record);
  }

  // ── Sight ─────────────────────────────────────────────────────────────────────

  @override
  Future<int> saveSight(Sight sight, int ownerId) async {
    final map = _sightToMap(sight, ownerId);
    if (sight.id == 0) {
      final id = await _sightStore.add(_db, map);
      sight.id = id;
      return id;
    }
    await _sightStore.record(sight.id).put(_db, map);
    return sight.id;
  }

  @override
  Future<int> duplicateSight(int id, String newName, int ownerId) async {
    final record = await _sightStore.record(id).get(_db);
    if (record == null) return 0;
    final copy = Map<String, dynamic>.from(record)
      ..['name'] = newName
      ..remove('id');
    return _sightStore.add(_db, copy);
  }

  @override
  Future<void> deleteSight(int id) async {
    await _db.transaction((txn) async {
      final linked = await _profileStore.find(
        txn,
        finder: Finder(filter: Filter.equals('sightId', id)),
      );
      for (final p in linked) {
        await _profileStore.record(p.key).update(txn, {'sightId': 0});
      }
      await _sightStore.record(id).delete(txn);
    });
  }

  @override
  Future<int> importSight(SightExport export, int ownerId) async {
    final sight = export.toEntity();
    return saveSight(sight, ownerId);
  }

  // ── Profile ───────────────────────────────────────────────────────────────────

  @override
  Future<void> setProfileAmmo(int profileId, int ammoId) async {
    await _profileStore.record(profileId).update(_db, {'ammoId': ammoId});
  }

  @override
  Future<void> setProfileSight(int profileId, int sightId) async {
    await _profileStore.record(profileId).update(_db, {'sightId': sightId});
  }

  @override
  Future<int> saveProfile(Profile profile, int ownerId) async {
    final map = _profileToMap(profile, ownerId);
    if (profile.id == 0) {
      final id = await _profileStore.add(_db, map);
      profile.id = id;
      return id;
    }
    await _profileStore.record(profile.id).put(_db, map);
    return profile.id;
  }

  @override
  Future<int> createProfile(String name, Weapon weapon, int ownerId) async {
    return _db.transaction((txn) async {
      final weaponId = await _weaponStore.add(txn, _weaponToMap(weapon, ownerId));
      weapon.id = weaponId;
      final profile = Profile()
        ..name = name
        ..weapon.target = weapon;
      final profileId = await _profileStore.add(txn, _profileToMap(profile, ownerId));
      profile.id = profileId;
      return profileId;
    });
  }

  @override
  Future<int> duplicateProfile(int id, String newName, int ownerId) async {
    return _db.transaction((txn) async {
      final original = await _profileStore.record(id).get(txn);
      if (original == null) return 0;

      final originalWeaponId = original['weaponId'] as int? ?? 0;
      if (originalWeaponId == 0) return 0;

      final originalWeaponMap =
          await _weaponStore.record(originalWeaponId).get(txn);
      if (originalWeaponMap == null) return 0;

      final weaponCopyMap = Map<String, dynamic>.from(originalWeaponMap)
        ..remove('id');
      final weaponCopyId = await _weaponStore.add(txn, weaponCopyMap);

      final profileMap = {
        'name': newName,
        'ownerId': ownerId,
        'weaponId': weaponCopyId,
        'ammoId': original['ammoId'] ?? 0,
        'sightId': original['sightId'] ?? 0,
      };
      return _profileStore.add(txn, profileMap);
    });
  }

  @override
  Future<int> importProfile(ProfileExport export, int ownerId) async {
    final (profileData, weaponData, ammoData, sightData) = export.toEntities();
    return _db.transaction((txn) async {
      final weaponId =
          await _weaponStore.add(txn, _weaponToMap(weaponData, ownerId));
      weaponData.id = weaponId;

      int ammoId = 0;
      if (ammoData != null) {
        ammoId = await _ammoStore.add(txn, _ammoToMap(ammoData, ownerId));
        ammoData.id = ammoId;
      }

      int sightId = 0;
      if (sightData != null) {
        sightId = await _sightStore.add(txn, _sightToMap(sightData, ownerId));
        sightData.id = sightId;
      }

      final profileMap = {
        'name': profileData.name,
        'ownerId': ownerId,
        'weaponId': weaponId,
        'ammoId': ammoId,
        'sightId': sightId,
      };
      return _profileStore.add(txn, profileMap);
    });
  }

  @override
  Future<void> deleteProfile(int id, int ownerId) async {
    await _db.transaction((txn) async {
      final profile = await _profileStore.record(id).get(txn);
      final weaponId = profile?['weaponId'] as int? ?? 0;
      await _profileStore.record(id).delete(txn);
      if (weaponId != 0) {
        final stillLinked = await _profileStore.count(
          txn,
          filter: Filter.equals('weaponId', weaponId),
        );
        if (stillLinked == 0) {
          await _weaponStore.record(weaponId).delete(txn);
        }
      }
    });
  }

  @override
  Future<Profile?> getProfile(int id) async {
    final record = await _profileStore.record(id).get(_db);
    if (record == null) return null;
    final p = _profileFromMap(id, record);
    final wId = p.weapon.targetId;
    final aId = p.ammo.targetId;
    final sId = p.sight.targetId;
    if (wId != 0) {
      final w = await getWeapon(wId);
      if (w != null) p.weapon.target = w;
    }
    if (aId != 0) {
      final a = await getAmmo(aId);
      if (a != null) p.ammo.target = a;
    }
    if (sId != 0) {
      final s = await _sightStore.record(sId).get(_db);
      if (s != null) p.sight.target = _sightFromMap(sId, s);
    }
    return p;
  }

  // ── Serialization helpers ─────────────────────────────────────────────────────

  void _stitchProfile(Profile p, List<Weapon> weapons, List<Ammo> ammoList,
      List<Sight> sights) {
    final wId = p.weapon.targetId;
    final aId = p.ammo.targetId;
    final sId = p.sight.targetId;
    if (wId != 0) {
      final w = weapons.firstWhereOrNull((w) => w.id == wId);
      if (w != null) p.weapon.target = w;
    }
    if (aId != 0) {
      final a = ammoList.firstWhereOrNull((a) => a.id == aId);
      if (a != null) p.ammo.target = a;
    }
    if (sId != 0) {
      final s = sights.firstWhereOrNull((s) => s.id == sId);
      if (s != null) p.sight.target = s;
    }
  }

  Map<String, dynamic> _weaponToMap(Weapon w, int ownerId) => {
        'name': w.name,
        'ownerId': ownerId,
        'caliberInch': w.caliberInch,
        'caliberName': w.caliberName,
        'twistInch': w.twistInch,
        'barrelLengthInch': w.barrelLengthInch,
        'zeroElevationRad': w.zeroElevationRad,
        'vendor': w.vendor,
        'notes': w.notes,
        'image': w.image,
      };

  Weapon _weaponFromMap(int id, Map<String, dynamic> m) => Weapon()
    ..id = id
    ..name = m['name'] as String? ?? ''
    ..caliberInch = (m['caliberInch'] as num?)?.toDouble() ?? -1.0
    ..caliberName = m['caliberName'] as String? ?? ''
    ..twistInch = (m['twistInch'] as num?)?.toDouble() ?? 0.0
    ..barrelLengthInch = (m['barrelLengthInch'] as num?)?.toDouble() ?? -1.0
    ..zeroElevationRad = (m['zeroElevationRad'] as num?)?.toDouble() ?? 0.0
    ..vendor = m['vendor'] as String?
    ..notes = m['notes'] as String?
    ..image = m['image'] as String?;

  Map<String, dynamic> _ammoToMap(Ammo a, int ownerId) => {
        'name': a.name,
        'ownerId': ownerId,
        'caliberInch': a.caliberInch,
        'weightGrain': a.weightGrain,
        'lengthInch': a.lengthInch,
        'dragTypeValue': a.dragTypeValue,
        'bcG1': a.bcG1,
        'bcG7': a.bcG7,
        'useMultiBcG1': a.useMultiBcG1,
        'useMultiBcG7': a.useMultiBcG7,
        'muzzleVelocityMps': a.muzzleVelocityMps,
        'muzzleVelocityTemperatureC': a.muzzleVelocityTemperatureC,
        'usePowderSensitivity': a.usePowderSensitivity,
        'powderSensitivityFrac': a.powderSensitivityFrac,
        'powderSensitivityTC': a.powderSensitivityTC?.toList(),
        'powderSensitivityVMps': a.powderSensitivityVMps?.toList(),
        'multiBcTableG1VMps': a.multiBcTableG1VMps?.toList(),
        'multiBcTableG1Bc': a.multiBcTableG1Bc?.toList(),
        'multiBcTableG7VMps': a.multiBcTableG7VMps?.toList(),
        'multiBcTableG7Bc': a.multiBcTableG7Bc?.toList(),
        'customDragTableMach': a.customDragTableMach?.toList(),
        'customDragTableCd': a.customDragTableCd?.toList(),
        'zeroDistanceMeter': a.zeroDistanceMeter,
        'zeroLookAngleRad': a.zeroLookAngleRad,
        'zeroAltitudeMeter': a.zeroAltitudeMeter,
        'zeroTemperatureC': a.zeroTemperatureC,
        'zeroPressurehPa': a.zeroPressurehPa,
        'zeroHumidityFrac': a.zeroHumidityFrac,
        'zeroUseDiffPowderTemperature': a.zeroUseDiffPowderTemperature,
        'zeroUseCoriolis': a.zeroUseCoriolis,
        'zeroPowderTemperatureC': a.zeroPowderTemperatureC,
        'zeroLatitudeDeg': a.zeroLatitudeDeg,
        'zeroAzimuthDeg': a.zeroAzimuthDeg,
        'zeroOffsetX': a.zeroOffsetX,
        'zeroOffsetY': a.zeroOffsetY,
        'zeroOffsetXUnit': a.zeroOffsetXUnit,
        'zeroOffsetYUnit': a.zeroOffsetYUnit,
        'projectileName': a.projectileName,
        'vendor': a.vendor,
        'image': a.image,
      };

  Ammo _ammoFromMap(int id, Map<String, dynamic> m) {
    Float64List? f64(String key) {
      final raw = m[key] as List?;
      if (raw == null) return null;
      return Float64List.fromList(raw.cast<num>().map((e) => e.toDouble()).toList());
    }

    return Ammo()
      ..id = id
      ..name = m['name'] as String? ?? ''
      ..caliberInch = (m['caliberInch'] as num?)?.toDouble() ?? -1.0
      ..weightGrain = (m['weightGrain'] as num?)?.toDouble() ?? -1.0
      ..lengthInch = (m['lengthInch'] as num?)?.toDouble() ?? -1.0
      ..dragTypeValue = m['dragTypeValue'] as String? ?? 'g1'
      ..bcG1 = (m['bcG1'] as num?)?.toDouble() ?? -1.0
      ..bcG7 = (m['bcG7'] as num?)?.toDouble() ?? -1.0
      ..useMultiBcG1 = m['useMultiBcG1'] as bool? ?? false
      ..useMultiBcG7 = m['useMultiBcG7'] as bool? ?? false
      ..muzzleVelocityMps = (m['muzzleVelocityMps'] as num?)?.toDouble() ?? -1.0
      ..muzzleVelocityTemperatureC =
          (m['muzzleVelocityTemperatureC'] as num?)?.toDouble() ?? 15.0
      ..usePowderSensitivity = m['usePowderSensitivity'] as bool? ?? false
      ..powderSensitivityFrac =
          (m['powderSensitivityFrac'] as num?)?.toDouble() ?? 0.0
      ..powderSensitivityTC = f64('powderSensitivityTC')
      ..powderSensitivityVMps = f64('powderSensitivityVMps')
      ..multiBcTableG1VMps = f64('multiBcTableG1VMps')
      ..multiBcTableG1Bc = f64('multiBcTableG1Bc')
      ..multiBcTableG7VMps = f64('multiBcTableG7VMps')
      ..multiBcTableG7Bc = f64('multiBcTableG7Bc')
      ..customDragTableMach = f64('customDragTableMach')
      ..customDragTableCd = f64('customDragTableCd')
      ..zeroDistanceMeter =
          (m['zeroDistanceMeter'] as num?)?.toDouble() ?? 100.0
      ..zeroLookAngleRad = (m['zeroLookAngleRad'] as num?)?.toDouble() ?? 0.0
      ..zeroAltitudeMeter =
          (m['zeroAltitudeMeter'] as num?)?.toDouble() ?? 0.0
      ..zeroTemperatureC = (m['zeroTemperatureC'] as num?)?.toDouble() ?? 15.0
      ..zeroPressurehPa = (m['zeroPressurehPa'] as num?)?.toDouble() ?? 1013.0
      ..zeroHumidityFrac = (m['zeroHumidityFrac'] as num?)?.toDouble() ?? 0.0
      ..zeroUseDiffPowderTemperature =
          m['zeroUseDiffPowderTemperature'] as bool? ?? false
      ..zeroUseCoriolis = m['zeroUseCoriolis'] as bool? ?? false
      ..zeroPowderTemperatureC =
          (m['zeroPowderTemperatureC'] as num?)?.toDouble() ?? 15.0
      ..zeroLatitudeDeg = (m['zeroLatitudeDeg'] as num?)?.toDouble() ?? 0.0
      ..zeroAzimuthDeg = (m['zeroAzimuthDeg'] as num?)?.toDouble() ?? 0.0
      ..zeroOffsetX = (m['zeroOffsetX'] as num?)?.toDouble() ?? 0.0
      ..zeroOffsetY = (m['zeroOffsetY'] as num?)?.toDouble() ?? 0.0
      ..zeroOffsetXUnit = m['zeroOffsetXUnit'] as String? ?? 'mil'
      ..zeroOffsetYUnit = m['zeroOffsetYUnit'] as String? ?? 'mil'
      ..projectileName = m['projectileName'] as String?
      ..vendor = m['vendor'] as String?
      ..image = m['image'] as String?;
  }

  Map<String, dynamic> _sightToMap(Sight s, int ownerId) => {
        'name': s.name,
        'ownerId': ownerId,
        'focalPlaneValue': s.focalPlaneValue,
        'sightHeightInch': s.sightHeightInch,
        'sightHorizontalOffsetInch': s.sightHorizontalOffsetInch,
        'verticalClick': s.verticalClick,
        'horizontalClick': s.horizontalClick,
        'verticalClickUnit': s.verticalClickUnit,
        'horizontalClickUnit': s.horizontalClickUnit,
        'minMagnification': s.minMagnification,
        'maxMagnification': s.maxMagnification,
        'reticleImage': s.reticleImage,
        'calibratedMagnification': s.calibratedMagnification,
        'vendor': s.vendor,
        'notes': s.notes,
        'image': s.image,
      };

  Sight _sightFromMap(int id, Map<String, dynamic> m) => Sight()
    ..id = id
    ..name = m['name'] as String? ?? ''
    ..focalPlaneValue = m['focalPlaneValue'] as String? ?? 'ffp'
    ..sightHeightInch = (m['sightHeightInch'] as num?)?.toDouble() ?? 0.0
    ..sightHorizontalOffsetInch =
        (m['sightHorizontalOffsetInch'] as num?)?.toDouble() ?? 0.0
    ..verticalClick = (m['verticalClick'] as num?)?.toDouble() ?? 0.1
    ..horizontalClick = (m['horizontalClick'] as num?)?.toDouble() ?? 0.1
    ..verticalClickUnit = m['verticalClickUnit'] as String? ?? 'mil'
    ..horizontalClickUnit = m['horizontalClickUnit'] as String? ?? 'mil'
    ..minMagnification = (m['minMagnification'] as num?)?.toDouble() ?? 1.0
    ..maxMagnification = (m['maxMagnification'] as num?)?.toDouble() ?? 1.0
    ..reticleImage = m['reticleImage'] as String?
    ..calibratedMagnification =
        (m['calibratedMagnification'] as num?)?.toDouble() ?? -1.0
    ..vendor = m['vendor'] as String?
    ..notes = m['notes'] as String?
    ..image = m['image'] as String?;

  Map<String, dynamic> _profileToMap(Profile p, int ownerId) => {
        'name': p.name,
        'ownerId': ownerId,
        'weaponId': p.weapon.targetId,
        'ammoId': p.ammo.targetId,
        'sightId': p.sight.targetId,
      };

  Profile _profileFromMap(int id, Map<String, dynamic> m) => Profile()
    ..id = id
    ..name = m['name'] as String? ?? ''
    ..weapon.targetId = m['weaponId'] as int? ?? 0
    ..ammo.targetId = m['ammoId'] as int? ?? 0
    ..sight.targetId = m['sightId'] as int? ?? 0;
}
