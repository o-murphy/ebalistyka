// Shared contract tests for IAppRepository.
// Each group is parameterised by a factory function so the same assertions
// run against both the ObjectBox and Sembast implementations.

import 'dart:io';
import 'dart:typed_data';

import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:ebalistyka_db/src/export/ammo_export.dart';
import 'package:ebalistyka_db/src/export/profile_export.dart';
import 'package:ebalistyka_db/src/export/sight_export.dart';
import 'package:ebalistyka_db/src/export/weapon_export.dart';
import 'package:ebalistyka_db/src/sembast/sembast_app_repository.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:test/test.dart';

// ── helpers ───────────────────────────────────────────────────────────────────

Ammo _makeAmmo({String name = 'Test Ammo'}) => Ammo()
  ..name = name
  ..caliberInch = 0.308
  ..weightGrain = 175.0
  ..lengthInch = 1.240
  ..dragTypeValue = 'g7'
  ..bcG1 = 0.505
  ..bcG7 = 0.278
  ..muzzleVelocityMps = 820.0
  ..muzzleVelocityTemperatureC = 15.0
  ..zeroDistanceMeter = 100.0
  ..zeroPressurehPa = 1013.25
  ..zeroHumidityFrac = 0.5
  ..zeroTemperatureC = 15.0;

Weapon _makeWeapon({String name = 'Test Rifle'}) => Weapon()
  ..name = name
  ..caliberInch = 0.308
  ..caliberName = '.308 Win'
  ..twistInch = 11.0
  ..barrelLengthInch = 24.0;

Sight _makeSight({String name = 'Test Scope'}) => Sight()
  ..name = name
  ..focalPlaneValue = 'ffp'
  ..sightHeightInch = 1.5
  ..verticalClick = 0.1
  ..horizontalClick = 0.1
  ..verticalClickUnit = 'mil'
  ..horizontalClickUnit = 'mil'
  ..minMagnification = 5.0
  ..maxMagnification = 25.0;

// ── contract ──────────────────────────────────────────────────────────────────

typedef RepoFactory = Future<(IAppRepository, Future<void> Function())> Function();

void runAppRepositoryContract(String label, RepoFactory factory) {
  group('IAppRepository [$label]', () {
    late IAppRepository repo;
    late Future<void> Function() teardown;
    late Owner owner;

    setUp(() async {
      final result = await factory();
      repo = result.$1;
      teardown = result.$2;
      owner = await repo.ensureOwner('local');
    });

    tearDown(() => teardown());

    // ── ensureOwner ────────────────────────────────────────────────────────────

    group('ensureOwner', () {
      test('creates owner with correct token', () {
        expect(owner.token, 'local');
        expect(owner.id, isNonZero);
      });

      test('returns same owner on second call', () async {
        final owner2 = await repo.ensureOwner('local');
        expect(owner2.id, owner.id);
        expect(owner2.token, 'local');
      });

      test('creates distinct owners for different tokens', () async {
        final other = await repo.ensureOwner('other');
        expect(other.id, isNot(owner.id));
      });
    });

    // ── needsSeed ──────────────────────────────────────────────────────────────

    group('needsSeed', () {
      test('returns true when no weapons exist', () async {
        expect(await repo.needsSeed(owner.id), isTrue);
      });

      test('returns false after saving a weapon', () async {
        await repo.saveWeapon(_makeWeapon(), owner.id);
        expect(await repo.needsSeed(owner.id), isFalse);
      });
    });

    // ── activeProfile ──────────────────────────────────────────────────────────

    group('activeProfile', () {
      test('returns 0 when no active profile set', () async {
        expect(await repo.getActiveProfileId(owner.id), 0);
      });

      test('set and get active profile id', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P1', weapon, owner.id);
        await repo.setActiveProfileId(owner.id, profileId);
        expect(await repo.getActiveProfileId(owner.id), profileId);
      });

      test('set to 0 clears active profile', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P1', weapon, owner.id);
        await repo.setActiveProfileId(owner.id, profileId);
        await repo.setActiveProfileId(owner.id, 0);
        expect(await repo.getActiveProfileId(owner.id), 0);
      });
    });

    // ── Weapon ─────────────────────────────────────────────────────────────────

    group('Weapon', () {
      test('saveWeapon creates with nonzero id', () async {
        final weapon = _makeWeapon();
        expect(weapon.id, 0);
        final id = await repo.saveWeapon(weapon, owner.id);
        expect(id, isNonZero);
        expect(weapon.id, id);
      });

      test('saveWeapon updates existing', () async {
        final weapon = _makeWeapon();
        await repo.saveWeapon(weapon, owner.id);
        weapon.name = 'Updated Rifle';
        await repo.saveWeapon(weapon, owner.id);

        final all = await repo.loadWeapons(owner.id);
        expect(all.length, 1);
        expect(all.first.name, 'Updated Rifle');
      });

      test('getWeapon returns correct entity', () async {
        final weapon = _makeWeapon();
        final id = await repo.saveWeapon(weapon, owner.id);
        final found = await repo.getWeapon(id);
        expect(found, isNotNull);
        expect(found!.name, 'Test Rifle');
        expect(found.caliberInch, closeTo(0.308, 1e-6));
        expect(found.twistInch, closeTo(11.0, 1e-6));
        expect(found.barrelLengthInch, closeTo(24.0, 1e-6));
      });

      test('getWeapon returns null for unknown id', () async {
        expect(await repo.getWeapon(9999), isNull);
      });

      test('loadWeapons filters by owner', () async {
        final other = await repo.ensureOwner('other');
        await repo.saveWeapon(_makeWeapon(name: 'Mine'), owner.id);
        await repo.saveWeapon(_makeWeapon(name: 'Theirs'), other.id);

        final mine = await repo.loadWeapons(owner.id);
        expect(mine.length, 1);
        expect(mine.first.name, 'Mine');
      });
    });

    // ── Ammo ───────────────────────────────────────────────────────────────────

    group('Ammo', () {
      test('saveAmmo creates with nonzero id', () async {
        final ammo = _makeAmmo();
        final id = await repo.saveAmmo(ammo, owner.id);
        expect(id, isNonZero);
        expect(ammo.id, id);
      });

      test('saveAmmo persists all scalar fields', () async {
        final ammo = _makeAmmo()
          ..vendor = 'Hornady'
          ..projectileName = 'ELD-M'
          ..zeroLookAngleRad = 0.002
          ..zeroAltitudeMeter = 150.0
          ..zeroUseCoriolis = true
          ..zeroUseDiffPowderTemperature = true
          ..zeroPowderTemperatureC = 20.0
          ..zeroLatitudeDeg = 50.0
          ..zeroAzimuthDeg = 180.0
          ..zeroOffsetX = 0.5
          ..zeroOffsetY = -0.3
          ..zeroOffsetXUnit = 'moa'
          ..zeroOffsetYUnit = 'moa';
        final id = await repo.saveAmmo(ammo, owner.id);
        final found = (await repo.getAmmo(id))!;

        expect(found.vendor, 'Hornady');
        expect(found.projectileName, 'ELD-M');
        expect(found.zeroLookAngleRad, closeTo(0.002, 1e-9));
        expect(found.zeroAltitudeMeter, closeTo(150.0, 1e-6));
        expect(found.zeroUseCoriolis, isTrue);
        expect(found.zeroUseDiffPowderTemperature, isTrue);
        expect(found.zeroPowderTemperatureC, closeTo(20.0, 1e-6));
        expect(found.zeroLatitudeDeg, closeTo(50.0, 1e-6));
        expect(found.zeroAzimuthDeg, closeTo(180.0, 1e-6));
        expect(found.zeroOffsetX, closeTo(0.5, 1e-6));
        expect(found.zeroOffsetY, closeTo(-0.3, 1e-6));
        expect(found.zeroOffsetXUnit, 'moa');
        expect(found.zeroOffsetYUnit, 'moa');
      });

      test('saveAmmo persists Float64List fields', () async {
        final ammo = _makeAmmo()
          ..useMultiBcG7 = true
          ..multiBcTableG7VMps = Float64List.fromList([900.0, 800.0, 700.0])
          ..multiBcTableG7Bc = Float64List.fromList([0.30, 0.29, 0.28])
          ..customDragTableMach = Float64List.fromList([0.5, 1.0, 2.0])
          ..customDragTableCd = Float64List.fromList([0.3, 0.4, 0.5])
          ..powderSensitivityTC = Float64List.fromList([0.0, 10.0, 20.0])
          ..powderSensitivityVMps = Float64List.fromList([820.0, 825.0, 830.0]);
        final id = await repo.saveAmmo(ammo, owner.id);
        final found = (await repo.getAmmo(id))!;

        expect(found.multiBcTableG7VMps, [900.0, 800.0, 700.0]);
        expect(found.multiBcTableG7Bc, [0.30, 0.29, 0.28]);
        expect(found.customDragTableMach, [0.5, 1.0, 2.0]);
        expect(found.customDragTableCd, [0.3, 0.4, 0.5]);
        expect(found.powderSensitivityTC, [0.0, 10.0, 20.0]);
        expect(found.powderSensitivityVMps, [820.0, 825.0, 830.0]);
      });

      test('saveAmmo updates existing', () async {
        final ammo = _makeAmmo();
        await repo.saveAmmo(ammo, owner.id);
        ammo.name = 'Updated Ammo';
        ammo.bcG7 = 0.310;
        await repo.saveAmmo(ammo, owner.id);

        final all = await repo.loadAmmo(owner.id);
        expect(all.length, 1);
        expect(all.first.name, 'Updated Ammo');
        expect(all.first.bcG7, closeTo(0.310, 1e-6));
      });

      test('saveAmmo: Float64List null → set on update', () async {
        final ammo = _makeAmmo();
        final id = await repo.saveAmmo(ammo, owner.id);

        ammo.useMultiBcG7 = true;
        ammo.multiBcTableG7VMps = Float64List.fromList([900.0, 800.0]);
        ammo.multiBcTableG7Bc = Float64List.fromList([0.30, 0.29]);
        await repo.saveAmmo(ammo, owner.id);

        final updated = (await repo.getAmmo(id))!;
        expect(updated.multiBcTableG7VMps, [900.0, 800.0]);
        expect(updated.multiBcTableG7Bc, [0.30, 0.29]);
      });

      test('saveAmmo: Float64List set → null on update', () async {
        final ammo = _makeAmmo()
          ..useMultiBcG7 = true
          ..multiBcTableG7VMps = Float64List.fromList([900.0, 800.0])
          ..multiBcTableG7Bc = Float64List.fromList([0.30, 0.29]);
        final id = await repo.saveAmmo(ammo, owner.id);

        ammo.useMultiBcG7 = false;
        ammo.multiBcTableG7VMps = null;
        ammo.multiBcTableG7Bc = null;
        await repo.saveAmmo(ammo, owner.id);

        final updated = (await repo.getAmmo(id))!;
        expect(updated.useMultiBcG7, isFalse);
        expect(updated.multiBcTableG7VMps, isNull);
        expect(updated.multiBcTableG7Bc, isNull);
      });

      test('deleteAmmo removes from list', () async {
        final ammo = _makeAmmo();
        final id = await repo.saveAmmo(ammo, owner.id);
        await repo.deleteAmmo(id);
        expect(await repo.loadAmmo(owner.id), isEmpty);
        expect(await repo.getAmmo(id), isNull);
      });

      test('deleteAmmo nulls ammoId on linked profiles', () async {
        final ammo = _makeAmmo();
        final ammoId = await repo.saveAmmo(ammo, owner.id);

        final sight = _makeSight();
        final sightId = await repo.saveSight(sight, owner.id);

        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);
        await repo.setProfileAmmo(profileId, ammoId);
        await repo.setProfileSight(profileId, sightId);

        await repo.deleteAmmo(ammoId);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.ammo.targetId, 0);
        expect(profiles.first.sight.targetId, sightId); // sight untouched
      });

      test('deleteAmmo when profile has no ammo does not throw', () async {
        final ammo = _makeAmmo();
        final ammoId = await repo.saveAmmo(ammo, owner.id);

        // profile with no ammo linked
        await repo.createProfile('P', _makeWeapon(), owner.id);

        await expectLater(repo.deleteAmmo(ammoId), completes);
        expect(await repo.loadAmmo(owner.id), isEmpty);
      });

      test('after deleteAmmo new ammo can be linked to profile', () async {
        final ammo1 = _makeAmmo(name: 'Ammo1');
        final ammoId1 = await repo.saveAmmo(ammo1, owner.id);
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);
        await repo.setProfileAmmo(profileId, ammoId1);
        await repo.deleteAmmo(ammoId1);

        // link new ammo after deletion
        final ammo2 = _makeAmmo(name: 'Ammo2');
        final ammoId2 = await repo.saveAmmo(ammo2, owner.id);
        await repo.setProfileAmmo(profileId, ammoId2);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.ammo.targetId, ammoId2);
        expect(profiles.first.ammo.target?.name, 'Ammo2');
      });

      test('duplicateAmmo creates independent copy', () async {
        final ammo = _makeAmmo()
          ..multiBcTableG7VMps = Float64List.fromList([900.0, 800.0])
          ..multiBcTableG7Bc = Float64List.fromList([0.30, 0.29]);
        final origId = await repo.saveAmmo(ammo, owner.id);

        final copyId = await repo.duplicateAmmo(origId, 'Copy', owner.id);
        expect(copyId, isNonZero);
        expect(copyId, isNot(origId));

        final copy = (await repo.getAmmo(copyId))!;
        expect(copy.name, 'Copy');
        expect(copy.caliberInch, closeTo(0.308, 1e-6));
        expect(copy.multiBcTableG7VMps, [900.0, 800.0]);
        expect(copy.multiBcTableG7Bc, [0.30, 0.29]);

        // mutating copy does not affect original
        copy.bcG7 = 0.999;
        await repo.saveAmmo(copy, owner.id);
        final orig = (await repo.getAmmo(origId))!;
        expect(orig.bcG7, closeTo(0.278, 1e-6));
      });

      test('importAmmo restores all fields', () async {
        final ammo = _makeAmmo()..vendor = 'Federal';
        await repo.saveAmmo(ammo, owner.id);
        final export = AmmoExport.fromEntity(ammo);

        final importedId = await repo.importAmmo(export, owner.id);
        final imported = (await repo.getAmmo(importedId))!;
        expect(imported.name, ammo.name);
        expect(imported.vendor, 'Federal');
        expect(imported.bcG7, closeTo(0.278, 1e-6));
      });

      test('loadAmmo filters by owner', () async {
        final other = await repo.ensureOwner('other');
        await repo.saveAmmo(_makeAmmo(name: 'Mine'), owner.id);
        await repo.saveAmmo(_makeAmmo(name: 'Theirs'), other.id);

        final mine = await repo.loadAmmo(owner.id);
        expect(mine.length, 1);
        expect(mine.first.name, 'Mine');
      });
    });

    // ── Sight ──────────────────────────────────────────────────────────────────

    group('Sight', () {
      test('saveSight creates with nonzero id', () async {
        final sight = _makeSight();
        final id = await repo.saveSight(sight, owner.id);
        expect(id, isNonZero);
      });

      test('saveSight persists all fields', () async {
        final sight = _makeSight()
          ..vendor = 'Vortex'
          ..calibratedMagnification = 15.0
          ..sightHorizontalOffsetInch = 0.1
          ..notes = 'Zero at 15x';
        final id = await repo.saveSight(sight, owner.id);

        final loaded = await repo.loadSights(owner.id);
        final found = loaded.firstWhere((s) => s.id == id);
        expect(found.vendor, 'Vortex');
        expect(found.calibratedMagnification, closeTo(15.0, 1e-6));
        expect(found.sightHorizontalOffsetInch, closeTo(0.1, 1e-6));
        expect(found.notes, 'Zero at 15x');
      });

      test('deleteSight removes from list', () async {
        final sight = _makeSight();
        final id = await repo.saveSight(sight, owner.id);
        await repo.deleteSight(id);
        expect(await repo.loadSights(owner.id), isEmpty);
      });

      test('deleteSight nulls sightId on linked profiles', () async {
        final ammo = _makeAmmo();
        final ammoId = await repo.saveAmmo(ammo, owner.id);
        final sight = _makeSight();
        final sightId = await repo.saveSight(sight, owner.id);

        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);
        await repo.setProfileAmmo(profileId, ammoId);
        await repo.setProfileSight(profileId, sightId);

        await repo.deleteSight(sightId);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.sight.targetId, 0);
        expect(profiles.first.ammo.targetId, ammoId); // ammo untouched
      });

      test('duplicateSight creates independent copy', () async {
        final sight = _makeSight();
        final origId = await repo.saveSight(sight, owner.id);
        final copyId = await repo.duplicateSight(origId, 'Copy', owner.id);

        expect(copyId, isNonZero);
        expect(copyId, isNot(origId));

        final sights = await repo.loadSights(owner.id);
        final copy = sights.firstWhere((s) => s.id == copyId);
        expect(copy.name, 'Copy');
        expect(copy.sightHeightInch, closeTo(1.5, 1e-6));
      });

      test('importSight restores all fields', () async {
        final sight = _makeSight()..vendor = 'Nightforce';
        await repo.saveSight(sight, owner.id);
        final sightExport = SightExport.fromEntity(sight);

        final importedId = await repo.importSight(sightExport, owner.id);
        final loaded = await repo.loadSights(owner.id);
        final imported = loaded.firstWhere((s) => s.id == importedId);
        expect(imported.vendor, 'Nightforce');
        expect(imported.sightHeightInch, closeTo(1.5, 1e-6));
      });
    });

    // ── Profile ────────────────────────────────────────────────────────────────

    group('Profile', () {
      test('createProfile creates weapon and profile', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('My Profile', weapon, owner.id);
        expect(profileId, isNonZero);
        expect(weapon.id, isNonZero);

        final weapons = await repo.loadWeapons(owner.id);
        expect(weapons.length, 1);
        expect(weapons.first.name, 'Test Rifle');
      });

      test('saveProfile and loadProfiles returns profile', () async {
        final weapon = _makeWeapon();
        await repo.saveWeapon(weapon, owner.id);

        final ammo = _makeAmmo();
        await repo.saveAmmo(ammo, owner.id);

        final profile = Profile()
          ..name = 'Full Profile'
          ..weapon.target = weapon
          ..ammo.target = ammo;
        final id = await repo.saveProfile(profile, owner.id);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.length, 1);
        expect(profiles.first.id, id);
        expect(profiles.first.name, 'Full Profile');
        expect(profiles.first.weapon.target?.name, 'Test Rifle');
        expect(profiles.first.ammo.target?.name, 'Test Ammo');
      });

      test('setProfileAmmo links ammo to profile', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);

        final ammo = _makeAmmo();
        final ammoId = await repo.saveAmmo(ammo, owner.id);
        await repo.setProfileAmmo(profileId, ammoId);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.ammo.targetId, ammoId);
        expect(profiles.first.ammo.target?.name, 'Test Ammo');
      });

      test('setProfileAmmo replaces existing ammo (ammo1 → ammo2)', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);

        final ammo1 = _makeAmmo(name: 'Ammo1');
        final ammoId1 = await repo.saveAmmo(ammo1, owner.id);
        await repo.setProfileAmmo(profileId, ammoId1);

        final ammo2 = _makeAmmo(name: 'Ammo2');
        final ammoId2 = await repo.saveAmmo(ammo2, owner.id);
        await repo.setProfileAmmo(profileId, ammoId2);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.ammo.targetId, ammoId2);
        expect(profiles.first.ammo.target?.name, 'Ammo2');
      });

      test('setProfileAmmo can clear ammo (set to 0)', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);
        final ammo = _makeAmmo();
        final ammoId = await repo.saveAmmo(ammo, owner.id);
        await repo.setProfileAmmo(profileId, ammoId);
        await repo.setProfileAmmo(profileId, 0);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.ammo.targetId, 0);
        expect(profiles.first.ammo.target, isNull);
      });

      test('setProfileSight links sight to profile', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);

        final sight = _makeSight();
        final sightId = await repo.saveSight(sight, owner.id);
        await repo.setProfileSight(profileId, sightId);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.sight.targetId, sightId);
        expect(profiles.first.sight.target?.name, 'Test Scope');
      });

      test('setProfileSight replaces existing sight (sight1 → sight2)', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);

        final sight1 = _makeSight(name: 'Scope1');
        final sightId1 = await repo.saveSight(sight1, owner.id);
        await repo.setProfileSight(profileId, sightId1);

        final sight2 = _makeSight(name: 'Scope2');
        final sightId2 = await repo.saveSight(sight2, owner.id);
        await repo.setProfileSight(profileId, sightId2);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.sight.targetId, sightId2);
        expect(profiles.first.sight.target?.name, 'Scope2');
      });

      test('setProfileSight can clear sight (set to 0)', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);
        final sight = _makeSight();
        final sightId = await repo.saveSight(sight, owner.id);
        await repo.setProfileSight(profileId, sightId);
        await repo.setProfileSight(profileId, 0);

        final profiles = await repo.loadProfiles(owner.id);
        expect(profiles.first.sight.targetId, 0);
        expect(profiles.first.sight.target, isNull);
      });

      test('getProfile returns stitched relations', () async {
        final weapon = _makeWeapon();
        final ammo = _makeAmmo();
        final sight = _makeSight();
        await repo.saveWeapon(weapon, owner.id);
        await repo.saveAmmo(ammo, owner.id);
        await repo.saveSight(sight, owner.id);

        final profile = Profile()
          ..name = 'Full'
          ..weapon.target = weapon
          ..ammo.target = ammo
          ..sight.target = sight;
        final id = await repo.saveProfile(profile, owner.id);

        final found = await repo.getProfile(id);
        expect(found, isNotNull);
        expect(found!.weapon.target?.name, 'Test Rifle');
        expect(found.ammo.target?.name, 'Test Ammo');
        expect(found.sight.target?.name, 'Test Scope');
      });

      test('getProfile returns null for unknown id', () async {
        expect(await repo.getProfile(9999), isNull);
      });

      test('duplicateProfile creates new weapon, shares ammo and sight', () async {
        final weapon = _makeWeapon();
        final ammo = _makeAmmo();
        final sight = _makeSight();
        await repo.saveAmmo(ammo, owner.id);
        await repo.saveSight(sight, owner.id);

        final profileId = await repo.createProfile('P1', weapon, owner.id);
        await repo.setProfileAmmo(profileId, ammo.id);
        await repo.setProfileSight(profileId, sight.id);

        final copyId = await repo.duplicateProfile(profileId, 'P1 Copy', owner.id);
        expect(copyId, isNonZero);
        expect(copyId, isNot(profileId));

        final copy = (await repo.getProfile(copyId))!;
        expect(copy.name, 'P1 Copy');
        expect(copy.ammo.targetId, ammo.id);   // shared ammo
        expect(copy.sight.targetId, sight.id); // shared sight
        expect(copy.weapon.targetId, isNot(weapon.id)); // new weapon copy

        final weapons = await repo.loadWeapons(owner.id);
        expect(weapons.length, 2);
      });

      test('deleteProfile deletes orphaned weapon', () async {
        final weapon = _makeWeapon();
        final profileId = await repo.createProfile('P', weapon, owner.id);
        await repo.deleteProfile(profileId, owner.id);

        expect(await repo.loadProfiles(owner.id), isEmpty);
        expect(await repo.loadWeapons(owner.id), isEmpty);
      });

      test('deleteProfile keeps weapon used by other profiles', () async {
        final weapon = _makeWeapon();
        await repo.saveWeapon(weapon, owner.id);

        final p1 = Profile()
          ..name = 'P1'
          ..weapon.target = weapon;
        final p2 = Profile()
          ..name = 'P2'
          ..weapon.target = weapon;
        final id1 = await repo.saveProfile(p1, owner.id);
        await repo.saveProfile(p2, owner.id);

        await repo.deleteProfile(id1, owner.id);

        expect(await repo.loadProfiles(owner.id), hasLength(1));
        expect(await repo.loadWeapons(owner.id), hasLength(1));
      });

      test('importProfile imports weapon, ammo, sight as new entities', () async {
        final weapon = _makeWeapon();
        final ammo = _makeAmmo();
        final sight = _makeSight();

        final export = ProfileExport(
          name: 'Imported Profile',
          weapon: WeaponExport.fromEntity(weapon),
          ammo: AmmoExport.fromEntity(ammo),
          sight: SightExport.fromEntity(sight),
        );

        final profileId = await repo.importProfile(export, owner.id);
        expect(profileId, isNonZero);

        final profile = (await repo.getProfile(profileId))!;
        expect(profile.name, 'Imported Profile');
        expect(profile.weapon.target?.name, 'Test Rifle');
        expect(profile.ammo.target?.name, 'Test Ammo');
        expect(profile.sight.target?.name, 'Test Scope');
      });

      test('loadProfiles filters by owner', () async {
        final other = await repo.ensureOwner('other');
        final w1 = _makeWeapon(name: 'Mine');
        final w2 = _makeWeapon(name: 'Theirs');
        await repo.createProfile('Mine', w1, owner.id);
        await repo.createProfile('Theirs', w2, other.id);

        final mine = await repo.loadProfiles(owner.id);
        expect(mine.length, 1);
        expect(mine.first.name, 'Mine');
      });
    });

    // ── Reactive streams ───────────────────────────────────────────────────────

    group('watch streams', () {
      test('watchWeapons emits on save', () async {
        final events = <void>[];
        final sub = repo.watchWeapons(owner.id).listen(events.add);
        addTearDown(sub.cancel);

        await repo.saveWeapon(_makeWeapon(), owner.id);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });

      test('watchAmmo emits on save and delete', () async {
        final ammo = _makeAmmo();
        final id = await repo.saveAmmo(ammo, owner.id);

        final events = <void>[];
        final sub = repo.watchAmmo(owner.id).listen(events.add);
        addTearDown(sub.cancel);

        await repo.saveAmmo(ammo..name = 'Changed', owner.id);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        final countAfterSave = events.length;
        expect(countAfterSave, greaterThan(0));

        await repo.deleteAmmo(id);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events.length, greaterThan(countAfterSave));
      });

      test('watchSights emits on save', () async {
        final events = <void>[];
        final sub = repo.watchSights(owner.id).listen(events.add);
        addTearDown(sub.cancel);

        await repo.saveSight(_makeSight(), owner.id);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });

      test('watchProfiles emits on createProfile', () async {
        final events = <void>[];
        final sub = repo.watchProfiles(owner.id).listen(events.add);
        addTearDown(sub.cancel);

        await repo.createProfile('P', _makeWeapon(), owner.id);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });
    });
  });
}

// ── Sembast runner ─────────────────────────────────────────────────────────────

Future<(IAppRepository, Future<void> Function())> _sembastFactory() async {
  final db = await databaseFactoryMemory.openDatabase('test_${DateTime.now().microsecondsSinceEpoch}');
  final repo = SembastAppRepository(db);
  return (repo, db.close);
}

// ── ObjectBox runner ───────────────────────────────────────────────────────────

Future<(IAppRepository, Future<void> Function())> _objectBoxFactory() async {
  final tmpDir = await Directory.systemTemp.createTemp('ebalistyka_ob_test_');
  final store = await initObjectBox(directory: tmpDir.path);
  final repo = ObjectBoxAppRepository(store);
  return (
    repo,
    () async {
      store.close();
      tmpDir.deleteSync(recursive: true);
    },
  );
}

// ── Entry point ────────────────────────────────────────────────────────────────

void main() {
  runAppRepositoryContract('Sembast', _sembastFactory);
  runAppRepositoryContract('ObjectBox', _objectBoxFactory);
}
