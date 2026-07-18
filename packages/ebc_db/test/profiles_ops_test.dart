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
}
