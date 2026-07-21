import 'package:ebc_db/ebc_db.dart';
import 'package:test/test.dart';

Profile _profile(String uuid, {String name = ''}) =>
    Profile()
      ..uuid = uuid
      ..name = name.isEmpty ? uuid : name;

void main() {
  group('activeProfileOf', () {
    test('returns the first profile', () {
      final profiles = [_profile('a'), _profile('b')];
      expect(activeProfileOf(profiles)?.uuid, 'a');
    });

    test('returns null for an empty list', () {
      expect(activeProfileOf(const []), isNull);
    });
  });

  group('setActiveProfileOf', () {
    test('moves the matching profile to index 0, keeps others in order', () {
      final profiles = [_profile('a'), _profile('b'), _profile('c')];
      final next = setActiveProfileOf(profiles, 'c');
      expect(next.map((p) => p.uuid), ['c', 'a', 'b']);
    });

    test('is a no-op when the uuid is already at index 0', () {
      final profiles = [_profile('a'), _profile('b')];
      final next = setActiveProfileOf(profiles, 'a');
      expect(next.map((p) => p.uuid), ['a', 'b']);
    });

    test('is a no-op when the uuid is not found', () {
      final profiles = [_profile('a'), _profile('b')];
      final next = setActiveProfileOf(profiles, 'does-not-exist');
      expect(next.map((p) => p.uuid), ['a', 'b']);
    });

    test('does not mutate the original list', () {
      final profiles = [_profile('a'), _profile('b'), _profile('c')];
      setActiveProfileOf(profiles, 'c');
      expect(profiles.map((p) => p.uuid), ['a', 'b', 'c']);
    });
  });

  group('copyWithFreshUuid', () {
    test('returns a copy with a different uuid, same other fields', () {
      final original = _profile('a', name: 'Test Profile');
      final copy = copyWithFreshUuid(original);

      expect(copy.uuid, isNot('a'));
      expect(copy.uuid, isNotEmpty);
      expect(copy.name, 'Test Profile');
    });

    test('does not mutate the original', () {
      final original = _profile('a');
      copyWithFreshUuid(original);
      expect(original.uuid, 'a');
    });

    test('two copies get different fresh uuids', () {
      final original = _profile('a');
      final copy1 = copyWithFreshUuid(original);
      final copy2 = copyWithFreshUuid(original);
      expect(copy1.uuid, isNot(copy2.uuid));
    });
  });

  group('sanitizeProfile', () {
    Profile outOfRangeProfile() =>
        Profile()
          ..uuid = 'a'
          ..weapon = (Weapon()
            ..twistInch = 999 // signed range is [-30, 30]
            ..barrelLengthInch = 999)
          ..sight = (Sight()
            ..sightHeightInch = 999
            ..minMagnification = 999)
          ..ammo = (Ammo()
            ..weightGrain = 999
            ..muzzleVelocityTemperatureC = 999
            ..zero = (Zero()
              ..lookAngleRad = 999
              ..humidityFrac = 999));

    test('clamps out-of-range fields into their FieldLimits role', () {
      final next = sanitizeProfile(outOfRangeProfile());
      expect(next.weapon.twistInch, FieldLimits.twistInch.maxRaw);
      expect(next.weapon.barrelLengthInch, FieldLimits.barrelLengthInch.maxRaw);
      expect(next.sight.sightHeightInch, FieldLimits.sightHeightInch.maxRaw);
      expect(next.sight.minMagnification, FieldLimits.magnification.maxRaw);
      expect(next.ammo.weightGrain, FieldLimits.projectileWeightGrain.maxRaw);
      expect(next.ammo.muzzleVelocityTemperatureC, FieldLimits.temperatureC.maxRaw);
      expect(next.ammo.zero.lookAngleRad, FieldLimits.lookAngleRad.maxRaw);
      expect(next.ammo.zero.humidityFrac, FieldLimits.humidityFrac.maxRaw);
    });

    test('leaves in-range fields untouched', () {
      final profile = _profile('a')
        ..weapon = (Weapon()..twistInch = 5)
        ..ammo = (Ammo()..zero = (Zero()..humidityFrac = 0.5));
      final next = sanitizeProfile(profile);
      expect(next.weapon.twistInch, 5);
      expect(next.ammo.zero.humidityFrac, 0.5);
    });

    test('leaves unset optional fields unset (no clamp on absent values)', () {
      final profile = _profile('a')..weapon = Weapon();
      final next = sanitizeProfile(profile);
      expect(next.weapon.hasCaliberInch(), isFalse);
      expect(next.ammo.hasBcG1(), isFalse);
    });

    test('does not mutate the original', () {
      final profile = outOfRangeProfile();
      sanitizeProfile(profile);
      expect(profile.weapon.twistInch, 999);
    });
  });
}
