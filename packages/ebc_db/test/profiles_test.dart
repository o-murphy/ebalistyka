import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ebc_db/ebc_db.dart';
import 'package:test/test.dart';

ProfilesData _sampleProfilesData() {
  final weapon = Weapon()
    ..name = 'Test Rifle'
    ..caliberInch = 0.308
    ..caliberName = '.308 Win'
    ..twistInch = 11.0
    ..barrelLengthInch = 24.0
    ..vendor = 'Acme';

  final sight = Sight()
    ..name = 'Test Scope'
    ..focalPlaneValue = 'ffp'
    ..verticalClick = 0.1
    ..horizontalClick = 0.1
    ..verticalClickUnit = 'mil'
    ..horizontalClickUnit = 'mil'
    ..minMagnification = 4
    ..maxMagnification = 16;
  // calibratedMagnification left unset — optional field, null when absent.

  final ammo = Ammo()
    ..name = '.308 175gr'
    ..caliberInch = 0.308
    ..weightGrain = 175.0
    ..lengthInch = 1.2
    ..dragTypeValue = 'g7'
    ..bcG1 = 0.5
    ..bcG7 = 0.475
    ..muzzleVelocityMps = 800.0
    ..muzzleVelocityTemperatureC = 15.0
    ..zero = (Zero()
      ..distanceMeter = 100.0
      ..temperatureC = 15.0
      ..pressureHPa = 1013.25
      ..offsetXUnit = 'mil'
      ..offsetYUnit = 'mil');

  final profile = Profile()
    ..uuid = 'profile-1'
    ..name = 'Test Profile'
    ..weapon = weapon
    ..ammo = ammo
    ..sight = sight;

  return ProfilesData()
    ..schemaVersion = 1
    ..profiles.add(profile);
}

void main() {
  group('ProfilesFile', () {
    test('encode/decode round-trips structurally equal data', () {
      final data = _sampleProfilesData();
      final bytes = ProfilesFile.encode(data);
      final decoded = ProfilesFile.decode(bytes);

      expect(decoded.profiles.single.name, 'Test Profile');
      expect(decoded.profiles.single.weapon.name, 'Test Rifle');
      expect(decoded.profiles.single.ammo.name, '.308 175gr');
      expect(decoded.profiles.single.ammo.zero.distanceMeter, 100.0);
      expect(decoded.profiles.single.sight.name, 'Test Scope');
      expect(decoded.writeToBuffer(), data.writeToBuffer());
    });

    test('decode rejects a corrupted buffer', () {
      final data = _sampleProfilesData();
      final bytes = ProfilesFile.encode(data);
      final corrupted = Uint8List.fromList(bytes)..[40] ^= 0xFF;

      expect(
        () => ProfilesFile.decode(corrupted),
        throwsA(isA<MsgParseException>()),
      );
    });

    test('decode rejects a too-small buffer', () {
      expect(
        () => ProfilesFile.decode(Uint8List(10)),
        throwsA(isA<MsgParseException>()),
      );
    });
  });

  group('ProfilesValidator', () {
    test('validates a well-formed ProfilesData', () {
      expect(
        () => ProfilesValidator.validate(_sampleProfilesData()),
        returnsNormally,
      );
    });

    test('accepts an unset (optional) Ammo.caliberInch as null', () {
      final data = _sampleProfilesData()..profiles.single.ammo.clearCaliberInch();
      expect(data.profiles.single.ammo.hasCaliberInch(), isFalse);
      expect(() => ProfilesValidator.validate(data), returnsNormally);
    });

    test('rejects a present but out-of-range Ammo.caliberInch', () {
      // Sentinel-style -1 is no longer special-cased now that the field is
      // optional — a present value must fall within the real range.
      final data = _sampleProfilesData()..profiles.single.ammo.caliberInch = -1.0;
      expect(
        () => ProfilesValidator.validate(data),
        throwsA(isA<ProfilesValidationException>()),
      );
    });

    test('rejects an out-of-range Ammo.weightGrain', () {
      // FC.projectileWeight caps at 800 grain.
      final data = _sampleProfilesData()..profiles.single.ammo.weightGrain = 5000.0;
      expect(
        () => ProfilesValidator.validate(data),
        throwsA(isA<ProfilesValidationException>()),
      );
    });
  });

  group('MsgStore<ProfilesData>', () {
    late Directory tmpDir;

    MsgStore<ProfilesData> storeFor(File file, {Duration debounce = Duration.zero}) =>
        MsgStore<ProfilesData>(
          file,
          encode: ProfilesFile.encode,
          decode: ProfilesFile.decode,
          debounce: debounce,
        );

    setUp(() async {
      tmpDir = await Directory.systemTemp.createTemp('ebc_db_test_');
    });

    tearDown(() {
      tmpDir.deleteSync(recursive: true);
    });

    test('load() falls back to seed when file is missing', () async {
      final store = storeFor(File('${tmpDir.path}/profiles.ebcp'));
      var seeded = false;
      final data = await store.load(
        orElseSeed: () {
          seeded = true;
          return _sampleProfilesData();
        },
      );
      expect(seeded, isTrue);
      expect(data.profiles.single.name, 'Test Profile');
    });

    test('save() then load() round-trips via disk', () async {
      final store = storeFor(File('${tmpDir.path}/profiles.ebcp'));
      await store.save(_sampleProfilesData());

      final loaded = await store.load(orElseSeed: ProfilesData.new);
      expect(loaded.profiles.single.name, 'Test Profile');
    });

    test('save() leaves a .bak of the previous version', () async {
      final store = storeFor(File('${tmpDir.path}/profiles.ebcp'));
      final first = _sampleProfilesData();
      await store.save(first);

      final second = _sampleProfilesData()..profiles.first.name = 'Second';
      await store.save(second);

      final bak = File('${tmpDir.path}/profiles.ebcp.bak');
      expect(bak.existsSync(), isTrue);
      final bakData = ProfilesFile.decode(await bak.readAsBytes());
      expect(bakData.profiles.single.name, 'Test Profile');
    });

    test('load() falls back to seed when the file is corrupted', () async {
      final file = File('${tmpDir.path}/profiles.ebcp');
      await file.writeAsBytes(Uint8List(10));

      final store = storeFor(file);
      var seeded = false;
      await store.load(
        orElseSeed: () {
          seeded = true;
          return _sampleProfilesData();
        },
      );
      expect(seeded, isTrue);
    });

    test('debounce coalesces rapid saves into one write of the latest value', () async {
      final file = File('${tmpDir.path}/profiles.ebcp');
      final store = storeFor(file, debounce: const Duration(milliseconds: 30));

      final first = _sampleProfilesData();
      final second = _sampleProfilesData()..profiles.first.name = 'Second';
      final third = _sampleProfilesData()..profiles.first.name = 'Third';

      unawaited(store.save(first));
      unawaited(store.save(second));
      final lastSave = store.save(third);

      // Nothing written yet — still inside the debounce window.
      expect(file.existsSync(), isFalse);

      await lastSave;
      final loaded = ProfilesFile.decode(await file.readAsBytes());
      expect(loaded.profiles.single.name, 'Third');
    });

    test('flush() immediately writes a pending debounced save', () async {
      final file = File('${tmpDir.path}/profiles.ebcp');
      final store = storeFor(file, debounce: const Duration(seconds: 10));

      final saveFuture = store.save(_sampleProfilesData());
      expect(file.existsSync(), isFalse);

      await store.flush();
      await saveFuture; // the original save() future must also complete.

      expect(file.existsSync(), isTrue);
    });

    test('flush() is a no-op when nothing is pending', () async {
      final store = storeFor(
        File('${tmpDir.path}/profiles.ebcp'),
        debounce: const Duration(seconds: 10),
      );
      await store.flush();
    });

    test('two stores on different files do not interfere', () async {
      final profilesStore = storeFor(File('${tmpDir.path}/profiles.ebcp'));
      await profilesStore.save(_sampleProfilesData());

      // A second store pointed at a different, still-nonexistent file
      // must not see the first store's data.
      final otherStore = storeFor(File('${tmpDir.path}/other.ebcp'));
      var seeded = false;
      await otherStore.load(
        orElseSeed: () {
          seeded = true;
          return ProfilesData();
        },
      );
      expect(seeded, isTrue);
    });
  });
}
