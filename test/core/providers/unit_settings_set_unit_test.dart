// Every unit key the Settings → Units screen passes to setUnit must change the
// matching unit. 'adjustment' (drop / windage angle) used to be missing from
// the switch, so that picker silently did nothing.
import 'dart:io';

import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/extensions/settings_extensions.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:ebalistyka/core/providers/db_seed.dart';
import 'package:ebalistyka/core/providers/settings_provider.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  late Directory tmpDir;

  setUp(() async {
    tmpDir = await Directory.systemTemp.createTemp('unit_settings_test_');
  });

  tearDown(() => tmpDir.deleteSync(recursive: true));

  Future<ProviderContainer> makeContainer() async {
    final store = FileMsgStore<SettingsData>(
      File('${tmpDir.path}/settings.ebcp'),
      encode: SettingsFile.encode,
      decode: SettingsFile.decode,
    );
    final initial = await store.load(orElseSeed: seedSettings);
    return ProviderContainer(
      overrides: [
        settingsStoreProvider.overrideWithValue(store),
        settingsDataProvider.overrideWith(() => SettingsDataNotifier(initial)),
      ],
    );
  }

  // key -> (unit to set, how to read it back)
  final cases = <String, (Unit, Unit Function(UnitSettings))>{
    'velocity': (Unit.fps, (u) => u.velocityUnit),
    'distance': (Unit.yard, (u) => u.distanceUnit),
    'sightHeight': (Unit.inch, (u) => u.sightHeightUnit),
    'pressure': (Unit.mmHg, (u) => u.pressureUnit),
    'temperature': (Unit.fahrenheit, (u) => u.temperatureUnit),
    'diameter': (Unit.millimeter, (u) => u.diameterUnit),
    'length': (Unit.millimeter, (u) => u.lengthUnit),
    'weight': (Unit.gram, (u) => u.weightUnit),
    'drop': (Unit.millimeter, (u) => u.dropUnit),
    'adjustment': (Unit.moa, (u) => u.adjustmentUnit),
    'energy': (Unit.joule, (u) => u.energyUnit),
    'targetSize': (Unit.inch, (u) => u.targetSizeUnit),
  };

  for (final entry in cases.entries) {
    test('setUnit(${entry.key}) changes the unit', () async {
      final c = await makeContainer();
      addTearDown(c.dispose);
      final (unit, read) = entry.value;

      await c.read(unitSettingsNotifierProvider.future);
      await c.read(unitSettingsNotifierProvider.notifier).setUnit(
        entry.key,
        unit,
      );

      expect(read(c.read(unitSettingsProvider)), unit);
    });
  }
}
