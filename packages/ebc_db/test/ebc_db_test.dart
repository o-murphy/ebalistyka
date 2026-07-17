import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ebc_db/ebc_db.dart';
import 'package:test/test.dart';

Db _sampleDb() {
  final weapon = Weapon()
    ..name = 'Test Rifle'
    ..caliberInch = 0.308
    ..caliberName = '.308 Win'
    ..twistInch = 11.0
    ..barrelLengthInch = 24.0
    ..vendor = 'Acme';

  final sight = Sight()
    ..uiKey = 'sight-1'
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
    ..uiKey = 'ammo-1'
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
    ..uiKey = 'profile-1'
    ..name = 'Test Profile'
    ..weapon = weapon
    ..ammo.add(ammo)
    ..sights.add(sight);

  return Db()
    ..schemaVersion = 1
    ..generalSettings = (GeneralSettings()
      ..languageCode = 'en'
      ..themeMode = 'system'
      ..adjustmentDisplayFormatValue = 'arrows'
      ..homeChartDistanceStep = 10.0
      ..homeTableDistanceStep = 10.0)
    ..unitSettings = UnitSettings()
    ..tablesSettings = (TablesSettings()
      ..distanceStartMeter = 0.0
      ..distanceEndMeter = 2000.0
      ..distanceStepMeter = 100.0)
    ..reticleSettings = ReticleSettings()
    ..convertorsState = (ConvertorsState()
      ..length = (UnitValue()
        ..value = 100.0
        ..lastUnit = 'inch')
      ..weight = (UnitValue()
        ..value = 100.0
        ..lastUnit = 'grain')
      ..pressure = (UnitValue()
        ..value = 1013.0
        ..lastUnit = 'hPa')
      ..temperature = (UnitValue()
        ..value = 68.0
        ..lastUnit = 'celsius')
      ..torque = (UnitValue()
        ..value = 100.0
        ..lastUnit = 'newtonMeter')
      ..angles = (AnglesConv()
        ..distanceValueMeter = 100.0
        ..angularValueMil = 1.0)
      ..velocity = (VelocityConv()
        ..valueMps = 300.0
        ..atmoPressureHPa = 1013.25)
      ..distanceConvTargetSize = (DistanceConvTargetSize()
        ..sizeInch = 8.0
        ..sizeAngularMil = 1.0))
    ..shootingConditions = (ShootingConditions()
      ..distanceMeter = 100.0
      ..pressureHPa = 1013.25)
    ..profiles.add(profile);
}

void main() {
  group('DbFile', () {
    test('encode/decode round-trips structurally equal data', () {
      final db = _sampleDb();
      final bytes = DbFile.encode(db);
      final decoded = DbFile.decode(bytes);

      expect(decoded.profiles.single.name, 'Test Profile');
      expect(decoded.profiles.single.weapon.name, 'Test Rifle');
      expect(decoded.profiles.single.ammo.single.name, '.308 175gr');
      expect(decoded.profiles.single.ammo.single.zero.distanceMeter, 100.0);
      expect(decoded.profiles.single.sights.single.name, 'Test Scope');
      expect(decoded.writeToBuffer(), db.writeToBuffer());
    });

    test('decode rejects a corrupted buffer', () {
      final db = _sampleDb();
      final bytes = DbFile.encode(db);
      final corrupted = Uint8List.fromList(bytes)..[40] ^= 0xFF;

      expect(() => DbFile.decode(corrupted), throwsA(isA<DbParseException>()));
    });

    test('decode rejects a too-small buffer', () {
      expect(
        () => DbFile.decode(Uint8List(10)),
        throwsA(isA<DbParseException>()),
      );
    });
  });

  group('DbValidator', () {
    test('validates a well-formed Db', () {
      expect(() => DbValidator.validate(_sampleDb()), returnsNormally);
    });

    test('accepts an unset (optional) Ammo.caliberInch as null', () {
      final db = _sampleDb()..profiles.single.ammo.single.clearCaliberInch();
      expect(db.profiles.single.ammo.single.hasCaliberInch(), isFalse);
      expect(() => DbValidator.validate(db), returnsNormally);
    });

    test('rejects a present but out-of-range Ammo.caliberInch', () {
      // Sentinel-style -1 is no longer special-cased now that the field is
      // optional — a present value must fall within the real range.
      final db = _sampleDb()..profiles.single.ammo.single.caliberInch = -1.0;
      expect(
        () => DbValidator.validate(db),
        throwsA(isA<DbValidationException>()),
      );
    });

    test('rejects an out-of-range Ammo.weightGrain', () {
      // FC.projectileWeight caps at 800 grain.
      final db = _sampleDb()..profiles.single.ammo.single.weightGrain = 5000.0;
      expect(
        () => DbValidator.validate(db),
        throwsA(isA<DbValidationException>()),
      );
    });

    test('rejects a non-enum GeneralSettings.themeMode', () {
      final db = _sampleDb()..generalSettings.themeMode = 'not-a-theme';
      expect(
        () => DbValidator.validate(db),
        throwsA(isA<DbValidationException>()),
      );
    });
  });

  group('DbStore', () {
    late Directory tmpDir;

    setUp(() async {
      tmpDir = await Directory.systemTemp.createTemp('ebc_db_test_');
    });

    tearDown(() {
      tmpDir.deleteSync(recursive: true);
    });

    test('load() falls back to seed when file is missing', () async {
      final store = DbStore(File('${tmpDir.path}/db.pb'));
      var seeded = false;
      final db = await store.load(
        orElseSeed: () {
          seeded = true;
          return _sampleDb();
        },
      );
      expect(seeded, isTrue);
      expect(db.profiles.single.name, 'Test Profile');
    });

    test('save() then load() round-trips via disk', () async {
      final store = DbStore(File('${tmpDir.path}/db.pb'));
      await store.save(_sampleDb());

      final loaded = await store.load(orElseSeed: Db.new);
      expect(loaded.profiles.single.name, 'Test Profile');
    });

    test('save() leaves a .bak of the previous version', () async {
      final store = DbStore(File('${tmpDir.path}/db.pb'));
      final first = _sampleDb();
      await store.save(first);

      final second = _sampleDb()..profiles.first.name = 'Second';
      await store.save(second);

      final bak = File('${tmpDir.path}/db.pb.bak');
      expect(bak.existsSync(), isTrue);
      final bakDb = DbFile.decode(await bak.readAsBytes());
      expect(bakDb.profiles.single.name, 'Test Profile');
    });

    test('load() falls back to seed when the file is corrupted', () async {
      final dbFile = File('${tmpDir.path}/db.pb');
      await dbFile.writeAsBytes(Uint8List(10));

      final store = DbStore(dbFile);
      var seeded = false;
      await store.load(
        orElseSeed: () {
          seeded = true;
          return _sampleDb();
        },
      );
      expect(seeded, isTrue);
    });

    test('debounce coalesces rapid saves into one write of the latest value', () async {
      final dbFile = File('${tmpDir.path}/db.pb');
      final store = DbStore(
        dbFile,
        debounce: const Duration(milliseconds: 30),
      );

      final first = _sampleDb();
      final second = _sampleDb()..profiles.first.name = 'Second';
      final third = _sampleDb()..profiles.first.name = 'Third';

      unawaited(store.save(first));
      unawaited(store.save(second));
      final lastSave = store.save(third);

      // Nothing written yet — still inside the debounce window.
      expect(dbFile.existsSync(), isFalse);

      await lastSave;
      final loaded = DbFile.decode(await dbFile.readAsBytes());
      expect(loaded.profiles.single.name, 'Third');
    });

    test('flush() immediately writes a pending debounced save', () async {
      final dbFile = File('${tmpDir.path}/db.pb');
      final store = DbStore(
        dbFile,
        debounce: const Duration(seconds: 10),
      );

      final saveFuture = store.save(_sampleDb());
      expect(dbFile.existsSync(), isFalse);

      await store.flush();
      await saveFuture; // the original save() future must also complete.

      expect(dbFile.existsSync(), isTrue);
    });

    test('flush() is a no-op when nothing is pending', () async {
      final store = DbStore(
        File('${tmpDir.path}/db.pb'),
        debounce: const Duration(seconds: 10),
      );
      await store.flush();
    });
  });
}
