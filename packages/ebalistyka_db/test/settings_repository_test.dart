// Shared contract tests for ISettingsRepository.
// Runs the same assertions against both ObjectBox and Sembast implementations.

import 'dart:io';

import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:test/test.dart';

// ── contract ──────────────────────────────────────────────────────────────────

typedef SettingsRepoFactory
    = Future<(ISettingsRepository, int, Future<void> Function())> Function();

void runSettingsRepositoryContract(String label, SettingsRepoFactory factory) {
  group('ISettingsRepository [$label]', () {
    late ISettingsRepository repo;
    late int ownerId;
    late Future<void> Function() teardown;

    setUp(() async {
      final result = await factory();
      repo = result.$1;
      ownerId = result.$2;
      teardown = result.$3;
    });

    tearDown(() => teardown());

    // ── GeneralSettings ────────────────────────────────────────────────────────

    group('GeneralSettings', () {
      test('loadOrCreate returns entity with defaults', () async {
        final s = await repo.loadOrCreateGeneralSettings(ownerId);
        expect(s.languageCode, isEmpty);
        expect(s.themeMode, isNotEmpty);
      });

      test('loadOrCreate is idempotent', () async {
        await repo.loadOrCreateGeneralSettings(ownerId);
        await repo.loadOrCreateGeneralSettings(ownerId);
        // second call must not throw and must return same data
        final s = await repo.loadOrCreateGeneralSettings(ownerId);
        expect(s.languageCode, isEmpty);
      });

      test('save and reload persists all fields', () async {
        final s = await repo.loadOrCreateGeneralSettings(ownerId);
        s.languageCode = 'uk';
        s.themeMode = 'dark';
        s.homeShowMil = true;
        s.homeShowMrad = false;
        s.homeShowMoa = true;
        s.homeShowCmPer100m = true;
        s.homeShowInPer100yd = false;
        s.homeShowInClicks = true;
        s.homeChartDistanceStep = 25.0;
        s.homeTableDistanceStep = 50.0;
        s.homeShowSubsonicTransition = true;
        s.adjustmentDisplayFormatValue = 'values';
        await repo.saveGeneralSettings(s, ownerId);

        final loaded = await repo.loadOrCreateGeneralSettings(ownerId);
        expect(loaded.languageCode, 'uk');
        expect(loaded.themeMode, 'dark');
        expect(loaded.homeShowMil, isTrue);
        expect(loaded.homeShowMrad, isFalse);
        expect(loaded.homeShowMoa, isTrue);
        expect(loaded.homeShowCmPer100m, isTrue);
        expect(loaded.homeShowInPer100yd, isFalse);
        expect(loaded.homeShowInClicks, isTrue);
        expect(loaded.homeChartDistanceStep, closeTo(25.0, 1e-6));
        expect(loaded.homeTableDistanceStep, closeTo(50.0, 1e-6));
        expect(loaded.homeShowSubsonicTransition, isTrue);
        expect(loaded.adjustmentDisplayFormatValue, 'values');
      });

      test('restoreGeneralSettings replaces data', () async {
        final s = await repo.loadOrCreateGeneralSettings(ownerId);
        s.languageCode = 'pl';
        await repo.saveGeneralSettings(s, ownerId);

        final export = GeneralSettingsExport.fromEntity(s);
        await repo.restoreGeneralSettings(export, ownerId);

        final loaded = await repo.loadOrCreateGeneralSettings(ownerId);
        expect(loaded.languageCode, 'pl');
      });

      test('watchGeneralSettings emits on save', () async {
        final events = <void>[];
        final sub = repo.watchGeneralSettings(ownerId).listen(events.add);
        addTearDown(sub.cancel);

        final s = await repo.loadOrCreateGeneralSettings(ownerId);
        s.languageCode = 'de';
        await repo.saveGeneralSettings(s, ownerId);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });
    });

    // ── UnitSettings ───────────────────────────────────────────────────────────

    group('UnitSettings', () {
      test('save and reload persists all unit strings', () async {
        final s = await repo.loadOrCreateUnitSettings(ownerId);
        s.angular = 'mil';
        s.distance = 'yard';
        s.velocity = 'fps';
        s.pressure = 'mmHg';
        s.temperature = 'fahrenheit';
        s.diameter = 'mm';
        s.length = 'cm';
        s.weight = 'gram';
        s.drop = 'inch';
        s.energy = 'ftlbf';
        s.sightHeight = 'mm';
        s.torque = 'inchPound';
        s.targetSize = 'moa';
        await repo.saveUnitSettings(s, ownerId);

        final loaded = await repo.loadOrCreateUnitSettings(ownerId);
        expect(loaded.angular, 'mil');
        expect(loaded.distance, 'yard');
        expect(loaded.velocity, 'fps');
        expect(loaded.pressure, 'mmHg');
        expect(loaded.temperature, 'fahrenheit');
        expect(loaded.diameter, 'mm');
        expect(loaded.length, 'cm');
        expect(loaded.weight, 'gram');
        expect(loaded.drop, 'inch');
        expect(loaded.energy, 'ftlbf');
        expect(loaded.sightHeight, 'mm');
        expect(loaded.torque, 'inchPound');
        expect(loaded.targetSize, 'moa');
      });

      test('restoreUnitSettings replaces data', () async {
        final s = await repo.loadOrCreateUnitSettings(ownerId);
        s.velocity = 'fps';
        await repo.saveUnitSettings(s, ownerId);

        final export = UnitSettingsExport.fromEntity(s);
        await repo.restoreUnitSettings(export, ownerId);

        final loaded = await repo.loadOrCreateUnitSettings(ownerId);
        expect(loaded.velocity, 'fps');
      });

      test('watchUnitSettings emits on save', () async {
        final events = <void>[];
        final sub = repo.watchUnitSettings(ownerId).listen(events.add);
        addTearDown(sub.cancel);

        final s = await repo.loadOrCreateUnitSettings(ownerId);
        s.distance = 'yard';
        await repo.saveUnitSettings(s, ownerId);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });
    });

    // ── TablesSettings ─────────────────────────────────────────────────────────

    group('TablesSettings', () {
      test('save and reload persists all fields', () async {
        final s = await repo.loadOrCreateTablesSettings(ownerId);
        s.distanceStartMeter = 50.0;
        s.distanceEndMeter = 800.0;
        s.distanceStepMeter = 25.0;
        s.showZeros = false;
        s.showSubsonicTransition = false;
        s.hiddenCols = ['drop', 'energy'];
        s.showMil = true;
        s.showMrad = true;
        s.showMoa = false;
        s.showCmPer100m = true;
        s.showInPer100yd = false;
        s.showInClicks = true;
        await repo.saveTablesSettings(s, ownerId);

        final loaded = await repo.loadOrCreateTablesSettings(ownerId);
        expect(loaded.distanceStartMeter, closeTo(50.0, 1e-6));
        expect(loaded.distanceEndMeter, closeTo(800.0, 1e-6));
        expect(loaded.distanceStepMeter, closeTo(25.0, 1e-6));
        expect(loaded.showZeros, isFalse);
        expect(loaded.showSubsonicTransition, isFalse);
        expect(loaded.hiddenCols, containsAll(['drop', 'energy']));
        expect(loaded.showMil, isTrue);
        expect(loaded.showMrad, isTrue);
        expect(loaded.showMoa, isFalse);
        expect(loaded.showCmPer100m, isTrue);
        expect(loaded.showInPer100yd, isFalse);
        expect(loaded.showInClicks, isTrue);
      });

      test('restoreTablesSettings replaces data', () async {
        final s = await repo.loadOrCreateTablesSettings(ownerId);
        s.distanceEndMeter = 500.0;
        await repo.saveTablesSettings(s, ownerId);

        final export = TablesSettingsExport.fromEntity(s);
        await repo.restoreTablesSettings(export, ownerId);

        final loaded = await repo.loadOrCreateTablesSettings(ownerId);
        expect(loaded.distanceEndMeter, closeTo(500.0, 1e-6));
      });

      test('watchTablesSettings emits on save', () async {
        final events = <void>[];
        final sub = repo.watchTablesSettings(ownerId).listen(events.add);
        addTearDown(sub.cancel);

        final s = await repo.loadOrCreateTablesSettings(ownerId);
        s.distanceEndMeter = 600.0;
        await repo.saveTablesSettings(s, ownerId);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });
    });

    // ── ReticleSettings ────────────────────────────────────────────────────────

    group('ReticleSettings', () {
      test('save and reload persists all fields', () async {
        final s = await repo.loadOrCreateReticleSettings(ownerId);
        s.verticalAdjustment = 1.5;
        s.verticalAdjustmentUnit = 'moa';
        s.horizontalAdjustment = -0.5;
        s.horizontalAdjustmentUnit = 'mil';
        s.targetImage = 'assets/target.png';
        await repo.saveReticleSettings(s, ownerId);

        final loaded = await repo.loadOrCreateReticleSettings(ownerId);
        expect(loaded.verticalAdjustment, closeTo(1.5, 1e-6));
        expect(loaded.verticalAdjustmentUnit, 'moa');
        expect(loaded.horizontalAdjustment, closeTo(-0.5, 1e-6));
        expect(loaded.horizontalAdjustmentUnit, 'mil');
        expect(loaded.targetImage, 'assets/target.png');
      });

      test('restore via save replaces data', () async {
        final s = await repo.loadOrCreateReticleSettings(ownerId);
        s.verticalAdjustment = 3.0;
        await repo.saveReticleSettings(s, ownerId);

        // Simulate what ReticleSettingsNotifier.restore does:
        final current = await repo.loadOrCreateReticleSettings(ownerId);
        final export = ReticleSettingsExport.fromEntity(current);
        final updated = export.toEntity()..id = current.id;
        await repo.saveReticleSettings(updated, ownerId);

        final loaded = await repo.loadOrCreateReticleSettings(ownerId);
        expect(loaded.verticalAdjustment, closeTo(3.0, 1e-6));
      });

      test('watchReticleSettings emits on save', () async {
        final events = <void>[];
        final sub = repo.watchReticleSettings(ownerId).listen(events.add);
        addTearDown(sub.cancel);

        final s = await repo.loadOrCreateReticleSettings(ownerId);
        s.verticalAdjustment = 2.0;
        await repo.saveReticleSettings(s, ownerId);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });
    });

    // ── ShootingConditions ─────────────────────────────────────────────────────

    group('ShootingConditions', () {
      test('save and reload persists all fields', () async {
        final s = await repo.loadOrCreateShootingConditions(ownerId);
        s.distanceMeter = 300.0;
        s.lookAngleRad = 0.05;
        s.altitudeMeter = 500.0;
        s.temperatureC = 25.0;
        s.pressurehPa = 995.0;
        s.humidityFrac = 0.7;
        s.powderTemperatureC = 30.0;
        s.usePowderSensitivity = true;
        s.useDiffPowderTemp = true;
        s.useCoriolis = true;
        s.latitudeDeg = 48.5;
        s.azimuthDeg = 270.0;
        s.windDirectionDeg = 90.0;
        s.windSpeedMps = 5.0;
        await repo.saveShootingConditions(s, ownerId);

        final loaded = await repo.loadOrCreateShootingConditions(ownerId);
        expect(loaded.distanceMeter, closeTo(300.0, 1e-6));
        expect(loaded.lookAngleRad, closeTo(0.05, 1e-9));
        expect(loaded.altitudeMeter, closeTo(500.0, 1e-6));
        expect(loaded.temperatureC, closeTo(25.0, 1e-6));
        expect(loaded.pressurehPa, closeTo(995.0, 1e-6));
        expect(loaded.humidityFrac, closeTo(0.7, 1e-6));
        expect(loaded.powderTemperatureC, closeTo(30.0, 1e-6));
        expect(loaded.usePowderSensitivity, isTrue);
        expect(loaded.useDiffPowderTemp, isTrue);
        expect(loaded.useCoriolis, isTrue);
        expect(loaded.latitudeDeg, closeTo(48.5, 1e-6));
        expect(loaded.azimuthDeg, closeTo(270.0, 1e-6));
        expect(loaded.windDirectionDeg, closeTo(90.0, 1e-6));
        expect(loaded.windSpeedMps, closeTo(5.0, 1e-6));
      });

      test('restoreShootingConditions replaces data', () async {
        final s = await repo.loadOrCreateShootingConditions(ownerId);
        s.distanceMeter = 800.0;
        s.temperatureC = -10.0;
        await repo.saveShootingConditions(s, ownerId);

        final export = ConditionsExport.fromEntity(s);
        await repo.restoreShootingConditions(export, ownerId);

        final loaded = await repo.loadOrCreateShootingConditions(ownerId);
        expect(loaded.distanceMeter, closeTo(800.0, 1e-6));
        expect(loaded.temperatureC, closeTo(-10.0, 1e-6));
      });

      test('watchShootingConditions emits on save', () async {
        final events = <void>[];
        final sub = repo.watchShootingConditions(ownerId).listen(events.add);
        addTearDown(sub.cancel);

        final s = await repo.loadOrCreateShootingConditions(ownerId);
        s.windSpeedMps = 8.0;
        await repo.saveShootingConditions(s, ownerId);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });
    });

    // ── ConvertorsState ────────────────────────────────────────────────────────

    group('ConvertorsState', () {
      test('save and reload persists all fields', () async {
        final s = await repo.loadOrCreateConvertorsState(ownerId);
        s.lengthValueInch = 200.0;
        s.lengthLastUnit = 'centimeter';
        s.weightValueGrain = 500.0;
        s.weightLastUnit = 'gram';
        s.pressureValueMmHg = 750.0;
        s.pressureLastUnit = 'mmHg';
        s.temperatureValueF = 32.0;
        s.temperatureLastUnit = 'fahrenheit';
        s.torqueValueNewtonMeter = 20.0;
        s.torqueLastUnit = 'inchPound';
        s.velocityValueMps = 400.0;
        s.velocityLastUnit = 'fps';
        s.velocityMachInputValue = 1.2;
        s.velocityMachUseCustomAtmo = true;
        s.velocityAtmoTemperatureC = 20.0;
        s.velocityAtmoPressureHPa = 980.0;
        s.velocityAtmoHumidityFrac = 0.3;
        s.velocityAtmoAltitudeMeter = 200.0;
        s.anglesConvDistanceValueMeter = 500.0;
        s.anglesConvDistanceLastUnit = 'yard';
        s.anglesConvAngularValueMil = 2.5;
        s.anglesConvAngularLastUnit = 'moa';
        s.anglesConvOutputLastUnit = 'inch';
        s.distanceConvTargetSizeInch = 12.0;
        s.distanceConvTargetSizeUnit = 'cm';
        s.distanceConvTargetSizeAngularMil = 3.0;
        s.distanceConvTargetSizeAngularUnit = 'moa';
        await repo.saveConvertorsState(s, ownerId);

        final loaded = await repo.loadOrCreateConvertorsState(ownerId);
        expect(loaded.lengthValueInch, closeTo(200.0, 1e-6));
        expect(loaded.lengthLastUnit, 'centimeter');
        expect(loaded.weightValueGrain, closeTo(500.0, 1e-6));
        expect(loaded.weightLastUnit, 'gram');
        expect(loaded.pressureValueMmHg, closeTo(750.0, 1e-6));
        expect(loaded.pressureLastUnit, 'mmHg');
        expect(loaded.temperatureValueF, closeTo(32.0, 1e-6));
        expect(loaded.temperatureLastUnit, 'fahrenheit');
        expect(loaded.torqueValueNewtonMeter, closeTo(20.0, 1e-6));
        expect(loaded.torqueLastUnit, 'inchPound');
        expect(loaded.velocityValueMps, closeTo(400.0, 1e-6));
        expect(loaded.velocityLastUnit, 'fps');
        expect(loaded.velocityMachInputValue, closeTo(1.2, 1e-6));
        expect(loaded.velocityMachUseCustomAtmo, isTrue);
        expect(loaded.velocityAtmoTemperatureC, closeTo(20.0, 1e-6));
        expect(loaded.velocityAtmoPressureHPa, closeTo(980.0, 1e-6));
        expect(loaded.velocityAtmoHumidityFrac, closeTo(0.3, 1e-6));
        expect(loaded.velocityAtmoAltitudeMeter, closeTo(200.0, 1e-6));
        expect(loaded.anglesConvDistanceValueMeter, closeTo(500.0, 1e-6));
        expect(loaded.anglesConvDistanceLastUnit, 'yard');
        expect(loaded.anglesConvAngularValueMil, closeTo(2.5, 1e-6));
        expect(loaded.anglesConvAngularLastUnit, 'moa');
        expect(loaded.anglesConvOutputLastUnit, 'inch');
        expect(loaded.distanceConvTargetSizeInch, closeTo(12.0, 1e-6));
        expect(loaded.distanceConvTargetSizeUnit, 'cm');
        expect(loaded.distanceConvTargetSizeAngularMil, closeTo(3.0, 1e-6));
        expect(loaded.distanceConvTargetSizeAngularUnit, 'moa');
      });

      test('watchConvertorsState emits on save', () async {
        final events = <void>[];
        final sub = repo.watchConvertorsState(ownerId).listen(events.add);
        addTearDown(sub.cancel);

        final s = await repo.loadOrCreateConvertorsState(ownerId);
        s.lengthValueInch = 999.0;
        await repo.saveConvertorsState(s, ownerId);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(events, isNotEmpty);
      });
    });

    // ── owner isolation ────────────────────────────────────────────────────────

    group('owner isolation', () {
      test('settings for different owners are independent', () async {
        final otherId = ownerId + 1000; // use a different id directly

        final s1 = await repo.loadOrCreateGeneralSettings(ownerId);
        s1.languageCode = 'uk';
        await repo.saveGeneralSettings(s1, ownerId);

        final s2 = await repo.loadOrCreateGeneralSettings(otherId);
        s2.languageCode = 'pl';
        await repo.saveGeneralSettings(s2, otherId);

        final loaded1 = await repo.loadOrCreateGeneralSettings(ownerId);
        final loaded2 = await repo.loadOrCreateGeneralSettings(otherId);
        expect(loaded1.languageCode, 'uk');
        expect(loaded2.languageCode, 'pl');
      });
    });
  });
}

// ── factories ─────────────────────────────────────────────────────────────────

Future<(ISettingsRepository, int, Future<void> Function())>
    _sembastFactory() async {
  final db = await databaseFactoryMemory
      .openDatabase('settings_test_${DateTime.now().microsecondsSinceEpoch}');
  final appRepo = SembastAppRepository(db);
  final settingsRepo = SembastSettingsRepository(db);
  final owner = await appRepo.ensureOwner('local');
  return (settingsRepo, owner.id, db.close);
}

Future<(ISettingsRepository, int, Future<void> Function())>
    _objectBoxFactory() async {
  final tmpDir =
      await Directory.systemTemp.createTemp('ebalistyka_ob_settings_test_');
  final store = await initObjectBox(directory: tmpDir.path);
  final appRepo = ObjectBoxAppRepository(store);
  final settingsRepo = ObjectBoxSettingsRepository(store);
  final owner = await appRepo.ensureOwner('local');
  return (
    settingsRepo,
    owner.id,
    () async {
      store.close();
      tmpDir.deleteSync(recursive: true);
    },
  );
}

// ── Entry point ────────────────────────────────────────────────────────────────

void main() {
  runSettingsRepositoryContract('Sembast', _sembastFactory);
  runSettingsRepositoryContract('ObjectBox', _objectBoxFactory);
}
