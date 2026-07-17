import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ebc_db/ebc_db.dart';
import 'package:test/test.dart';

SettingsData _sampleSettingsData() {
  return SettingsData()
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
      ..pressureHPa = 1013.25);
}

void main() {
  group('SettingsFile', () {
    test('encode/decode round-trips structurally equal data', () {
      final data = _sampleSettingsData();
      final bytes = SettingsFile.encode(data);
      final decoded = SettingsFile.decode(bytes);

      expect(decoded.generalSettings.languageCode, 'en');
      expect(decoded.unitSettings, UnitSettings());
      expect(decoded.tablesSettings.distanceEndMeter, 2000.0);
      expect(decoded.convertorsState.angles.angularValueMil, 1.0);
      expect(decoded.writeToBuffer(), data.writeToBuffer());
    });

    test('decode rejects a corrupted buffer', () {
      final data = _sampleSettingsData();
      final bytes = SettingsFile.encode(data);
      final corrupted = Uint8List.fromList(bytes)..[40] ^= 0xFF;

      expect(
        () => SettingsFile.decode(corrupted),
        throwsA(isA<MsgParseException>()),
      );
    });

    test('decode rejects a too-small buffer', () {
      expect(
        () => SettingsFile.decode(Uint8List(10)),
        throwsA(isA<MsgParseException>()),
      );
    });
  });

  group('SettingsValidator', () {
    test('validates a well-formed SettingsData', () {
      expect(
        () => SettingsValidator.validate(_sampleSettingsData()),
        returnsNormally,
      );
    });

    test('rejects a non-enum GeneralSettings.themeMode', () {
      final data = _sampleSettingsData()..generalSettings.themeMode = 'not-a-theme';
      expect(
        () => SettingsValidator.validate(data),
        throwsA(isA<SettingsValidationException>()),
      );
    });

    test('rejects an out-of-range ShootingConditions.windSpeedMps', () {
      // FC.windSpeed caps at 30 mps.
      final data = _sampleSettingsData()..shootingConditions.windSpeedMps = 999.0;
      expect(
        () => SettingsValidator.validate(data),
        throwsA(isA<SettingsValidationException>()),
      );
    });
  });

  group('MsgStore<SettingsData>', () {
    late Directory tmpDir;

    MsgStore<SettingsData> storeFor(File file, {Duration debounce = Duration.zero}) =>
        MsgStore<SettingsData>(
          file,
          encode: SettingsFile.encode,
          decode: SettingsFile.decode,
          debounce: debounce,
        );

    setUp(() async {
      tmpDir = await Directory.systemTemp.createTemp('ebc_db_test_');
    });

    tearDown(() {
      tmpDir.deleteSync(recursive: true);
    });

    test('load() falls back to seed when file is missing', () async {
      final store = storeFor(File('${tmpDir.path}/settings.ebcp'));
      var seeded = false;
      final data = await store.load(
        orElseSeed: () {
          seeded = true;
          return _sampleSettingsData();
        },
      );
      expect(seeded, isTrue);
      expect(data.generalSettings.languageCode, 'en');
    });

    test('save() then load() round-trips via disk', () async {
      final store = storeFor(File('${tmpDir.path}/settings.ebcp'));
      await store.save(_sampleSettingsData());

      final loaded = await store.load(orElseSeed: SettingsData.new);
      expect(loaded.generalSettings.languageCode, 'en');
    });

    test('save() leaves a .bak of the previous version', () async {
      final store = storeFor(File('${tmpDir.path}/settings.ebcp'));
      final first = _sampleSettingsData();
      await store.save(first);

      final second = _sampleSettingsData()..generalSettings.languageCode = 'uk';
      await store.save(second);

      final bak = File('${tmpDir.path}/settings.ebcp.bak');
      expect(bak.existsSync(), isTrue);
      final bakData = SettingsFile.decode(await bak.readAsBytes());
      expect(bakData.generalSettings.languageCode, 'en');
    });

    test('load() falls back to seed when the file is corrupted', () async {
      final file = File('${tmpDir.path}/settings.ebcp');
      await file.writeAsBytes(Uint8List(10));

      final store = storeFor(file);
      var seeded = false;
      await store.load(
        orElseSeed: () {
          seeded = true;
          return _sampleSettingsData();
        },
      );
      expect(seeded, isTrue);
    });

    test('debounce coalesces rapid saves into one write of the latest value', () async {
      final file = File('${tmpDir.path}/settings.ebcp');
      final store = storeFor(file, debounce: const Duration(milliseconds: 30));

      final first = _sampleSettingsData();
      final second = _sampleSettingsData()..generalSettings.languageCode = 'uk';
      final third = _sampleSettingsData()..generalSettings.languageCode = 'de';

      unawaited(store.save(first));
      unawaited(store.save(second));
      final lastSave = store.save(third);

      // Nothing written yet — still inside the debounce window.
      expect(file.existsSync(), isFalse);

      await lastSave;
      final loaded = SettingsFile.decode(await file.readAsBytes());
      expect(loaded.generalSettings.languageCode, 'de');
    });

    test('flush() immediately writes a pending debounced save', () async {
      final file = File('${tmpDir.path}/settings.ebcp');
      final store = storeFor(file, debounce: const Duration(seconds: 10));

      final saveFuture = store.save(_sampleSettingsData());
      expect(file.existsSync(), isFalse);

      await store.flush();
      await saveFuture; // the original save() future must also complete.

      expect(file.existsSync(), isTrue);
    });

    test('flush() is a no-op when nothing is pending', () async {
      final store = storeFor(
        File('${tmpDir.path}/settings.ebcp'),
        debounce: const Duration(seconds: 10),
      );
      await store.flush();
    });
  });
}
