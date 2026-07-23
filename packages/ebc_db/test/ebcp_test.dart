import 'dart:io';
import 'dart:typed_data';

import 'package:ebc_db/ebc_db.dart';
import 'package:test/test.dart';

ProfilesData _sampleProfilesData({String name = 'Test Profile'}) {
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
    ..name = name
    ..weapon = weapon
    ..ammo = ammo
    ..sight = sight;

  return ProfilesData()
    ..schemaVersion = 1
    ..profiles.add(profile);
}

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

/// A single-profile share: one ProfilesData block, no settings — the shape
/// a "share this profile" export would produce.
EbcpData _singleProfileShare() =>
    EbcpData()
      ..schemaVersion = 1
      ..profilesData.add(_sampleProfilesData());

/// A full backup: multiple ProfilesData blocks plus settings — the shape a
/// "backup everything" export would produce.
EbcpData _fullBackup() =>
    EbcpData()
      ..schemaVersion = 1
      ..profilesData.add(_sampleProfilesData(name: 'First'))
      ..profilesData.add(_sampleProfilesData(name: 'Second'))
      ..settingsData = _sampleSettingsData();

void main() {
  group('EbcpFile', () {
    test('encode/decode round-trips a single-profile share (no settings)', () {
      final data = _singleProfileShare();
      final bytes = EbcpFile.encode(data);
      final decoded = EbcpFile.decode(bytes);

      expect(decoded.hasSettingsData(), isFalse);
      expect(decoded.profilesData, hasLength(1));
      expect(decoded.profilesData.single.profiles.single.name, 'Test Profile');
      expect(decoded.writeToBuffer(), data.writeToBuffer());
    });

    test('encode/decode round-trips a full backup (settings + profiles)', () {
      final data = _fullBackup();
      final bytes = EbcpFile.encode(data);
      final decoded = EbcpFile.decode(bytes);

      expect(decoded.hasSettingsData(), isTrue);
      expect(decoded.settingsData.generalSettings.languageCode, 'en');
      expect(decoded.profilesData, hasLength(2));
      expect(decoded.writeToBuffer(), data.writeToBuffer());
    });

    test('decode rejects a corrupted buffer', () {
      final bytes = EbcpFile.encode(_fullBackup());
      final corrupted = Uint8List.fromList(bytes)..[40] ^= 0xFF;

      expect(
        () => EbcpFile.decode(corrupted),
        throwsA(isA<MsgParseException>()),
      );
    });

    test('decode rejects a too-small buffer', () {
      expect(
        () => EbcpFile.decode(Uint8List(10)),
        throwsA(isA<MsgParseException>()),
      );
    });
  });

  group('EbcpValidator', () {
    test('validates a well-formed single-profile share', () {
      expect(() => EbcpValidator.validate(_singleProfileShare()), returnsNormally);
    });

    test('validates a well-formed full backup', () {
      expect(() => EbcpValidator.validate(_fullBackup()), returnsNormally);
    });

    test('rejects an out-of-range field nested under profiles_data', () {
      final data = _singleProfileShare()
        ..profilesData.single.profiles.single.ammo.weightGrain = 5000.0;
      expect(
        () => EbcpValidator.validate(data),
        throwsA(isA<EbcpValidationException>()),
      );
    });

    test('rejects an out-of-range field nested under settings_data', () {
      final data = _fullBackup()..settingsData.generalSettings.themeMode = 'not-a-theme';
      expect(
        () => EbcpValidator.validate(data),
        throwsA(isA<EbcpValidationException>()),
      );
    });
  });

  group('MsgStore<EbcpData>', () {
    late Directory tmpDir;

    FileMsgStore<EbcpData> storeFor(File file) => FileMsgStore<EbcpData>(
      file,
      encode: EbcpFile.encode,
      decode: EbcpFile.decode,
    );

    setUp(() async {
      tmpDir = await Directory.systemTemp.createTemp('ebc_db_test_');
    });

    tearDown(() {
      tmpDir.deleteSync(recursive: true);
    });

    test('save() then load() round-trips a full backup via disk', () async {
      final store = storeFor(File('${tmpDir.path}/export.ebcp'));
      await store.save(_fullBackup());

      final loaded = await store.load(orElseSeed: EbcpData.new);
      expect(loaded.profilesData, hasLength(2));
      expect(loaded.hasSettingsData(), isTrue);
    });

    test('save() then load() round-trips a single-profile share via disk', () async {
      final store = storeFor(File('${tmpDir.path}/share.ebcp'));
      await store.save(_singleProfileShare());

      final loaded = await store.load(orElseSeed: EbcpData.new);
      expect(loaded.profilesData, hasLength(1));
      expect(loaded.hasSettingsData(), isFalse);
    });
  });
}
