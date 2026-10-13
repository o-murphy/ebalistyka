import 'dart:typed_data';

import 'package:ebalistyka/core/extensions/profile_extensions.dart';
import 'package:ebalistyka/core/providers/app_state_provider.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _NullStore extends MsgStore<ProfilesData> {
  _NullStore()
    : super(
        encode: (_) => Uint8List(0),
        decode: (_) => ProfilesData(),
      );

  @override
  Future<Uint8List?> readBytes() async => null;

  @override
  Future<void> writeBytes(Uint8List bytes) async {}
}

Profile _profile({double? weaponCal, double? ammoCal, bool withAmmo = true}) {
  final p = Profile()
    ..uuid = 'p1'
    ..name = 'P';
  p.weapon = Weapon()..name = 'W';
  if (weaponCal != null) p.weapon.caliberInch = weaponCal;
  if (withAmmo) {
    final a = Ammo()..name = 'A';
    if (ammoCal != null) a.caliberInch = ammoCal;
    p.ammo = a;
  }
  return p;
}

ProviderContainer _container(List<Profile> profiles) {
  final c = ProviderContainer(
    overrides: [
      profilesProvider.overrideWith(() => ProfilesNotifier(profiles)),
      profilesStoreProvider.overrideWithValue(_NullStore()),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('ProfileExtension caliber sync', () {
    test('weapon -> ammo copies the caliber', () {
      final p = _profile(weaponCal: 0.308, ammoCal: 0.338);
      p.syncAmmoCaliberFromWeapon();
      expect(p.ammo.caliberInch, 0.308);
      expect(p.weapon.caliberInch, 0.308);
    });

    test('ammo -> weapon copies the caliber', () {
      final p = _profile(weaponCal: 0.308, ammoCal: 0.338);
      p.syncWeaponCaliberFromAmmo();
      expect(p.weapon.caliberInch, 0.338);
      expect(p.ammo.caliberInch, 0.338);
    });

    test('disabled is a no-op', () {
      final p = _profile(weaponCal: 0.308, ammoCal: 0.338);
      p.syncAmmoCaliberFromWeapon(enabled: false);
      p.syncWeaponCaliberFromAmmo(enabled: false);
      expect(p.weapon.caliberInch, 0.308);
      expect(p.ammo.caliberInch, 0.338);
    });

    test('profile without ammo: nothing to sync, ammo stays unset', () {
      final p = _profile(weaponCal: 0.308, withAmmo: false);
      p.syncAmmoCaliberFromWeapon();
      p.syncWeaponCaliberFromAmmo();
      expect(p.hasAmmo(), isFalse);
      expect(p.weapon.caliberInch, 0.308);
    });

    test('an unset caliber on the source side is not propagated', () {
      final noWeaponCal = _profile(ammoCal: 0.338);
      noWeaponCal.syncAmmoCaliberFromWeapon();
      expect(noWeaponCal.ammo.caliberInch, 0.338);

      final noAmmoCal = _profile(weaponCal: 0.308);
      noAmmoCal.syncWeaponCaliberFromAmmo();
      expect(noAmmoCal.weapon.caliberInch, 0.308);
    });

    test('does not mutate the Ammo/Weapon instance passed in', () {
      final theirAmmo = Ammo()
        ..name = 'A'
        ..caliberInch = 0.338;
      final p = _profile(weaponCal: 0.308, withAmmo: false)..ammo = theirAmmo;
      p.syncAmmoCaliberFromWeapon();
      expect(p.ammo.caliberInch, 0.308);
      expect(theirAmmo.caliberInch, 0.338, reason: 'caller-owned, untouched');
    });
  });

  group('AppStateNotifier.setProfile* with syncCaliber', () {
    test('editing the weapon caliber updates the ammo too', () async {
      final c = _container([_profile(weaponCal: 0.308, ammoCal: 0.308)]);
      final edited = c.read(appStateProvider).value!.profiles.first.weapon
          .deepCopy()
        ..caliberInch = 0.338;

      await c
          .read(appStateProvider.notifier)
          .setProfileWeapon('p1', edited, syncCaliber: true);

      final p = c.read(profilesProvider).first;
      expect(p.weapon.caliberInch, closeTo(0.338, 1e-9));
      expect(p.ammo.caliberInch, closeTo(0.338, 1e-9));
    });

    test('editing the ammo caliber updates the weapon too', () async {
      final c = _container([_profile(weaponCal: 0.308, ammoCal: 0.308)]);
      final edited = c.read(profilesProvider).first.ammo.deepCopy()
        ..caliberInch = 0.224;

      await c
          .read(appStateProvider.notifier)
          .setProfileAmmo('p1', edited, syncCaliber: true);

      final p = c.read(profilesProvider).first;
      expect(p.ammo.caliberInch, closeTo(0.224, 1e-9));
      expect(p.weapon.caliberInch, closeTo(0.224, 1e-9));
    });

    test('without syncCaliber a replacement leaves the other side alone', () async {
      final c = _container([_profile(weaponCal: 0.308, ammoCal: 0.308)]);
      final swapped = Weapon()
        ..name = 'Other'
        ..caliberInch = 0.338;

      await c.read(appStateProvider.notifier).setProfileWeapon('p1', swapped);

      final p = c.read(profilesProvider).first;
      expect(p.weapon.caliberInch, closeTo(0.338, 1e-9));
      expect(
        p.ammo.caliberInch,
        closeTo(0.308, 1e-9),
        reason: 'hotswap: mismatch is offered to the user, not overwritten',
      );
    });

    test('only the targeted profile changes', () async {
      final other = _profile(weaponCal: 0.308, ammoCal: 0.308)..uuid = 'p2';
      final c = _container([
        _profile(weaponCal: 0.308, ammoCal: 0.308),
        other,
      ]);
      final edited = Weapon()
        ..name = 'W'
        ..caliberInch = 0.338;

      await c
          .read(appStateProvider.notifier)
          .setProfileWeapon('p1', edited, syncCaliber: true);

      final profiles = c.read(profilesProvider);
      expect(profiles[1].weapon.caliberInch, closeTo(0.308, 1e-9));
      expect(profiles[1].ammo.caliberInch, closeTo(0.308, 1e-9));
    });
  });
}
