// Legacy ObjectBox -> ebc_db migration, run against a real `data.mdb` written
// by the old app (v0.1.18): one profile "Cadex Defence Kraken CDX-MC" with
// Hornady 285GR ELD-M and a Nightforce ATACR. That store has no
// `ConvertorsState` (entity 2) and no `TablesSettings` (entity 7) record —
// the old app only created them lazily — which is exactly the case that used
// to migrate as all-zero data.
//
// Needs liblmdb: `dart run ob_dump_reader:build` (`make build-lmdb`).
//   flutter test test/ob_migrate/legacy_migrator_test.dart

import 'package:ebalistyka/ob_migrate/legacy_migrator.dart';
import 'package:flutter_test/flutter_test.dart';

const _fixtureDir = 'test/ob_migrate/fixtures';

void main() {
  late LegacyMigrationResult result;
  setUpAll(() async => result = await migrateLegacyData(_fixtureDir));

  test('profile, weapon, ammo and sight come across', () {
    expect(result.profiles, hasLength(1));
    expect(result.skippedProfileCount, 0);
    expect(result.orphanedWeapons, isEmpty);
    expect(result.orphanedAmmo, isEmpty);
    expect(result.orphanedSights, isEmpty);

    final p = result.profiles.single;
    expect(p.name, 'Cadex Defence Kraken CDX-MC');
    expect(p.weapon.name, 'Cadex Defence Kraken CDX-MC');
    expect(p.ammo.name, 'Hornady 285GR ELD-M');
    expect(p.ammo.bcG7, closeTo(0.397, 1e-9));
    expect(p.ammo.bcG1, closeTo(0.791, 1e-9));
    expect(
      p.sight.name,
      'Nightforce ATACR 7-35x56 F1 ZeroS 0.1 MIL DigIllum PTL',
    );
  });

  test('shooting conditions are migrated', () {
    final c = result.settings.shootingConditions;
    expect(c.temperatureC, closeTo(15.0, 1e-9));
    expect(c.distanceMeter, closeTo(450.0, 1e-9));
  });

  test('missing TablesSettings falls back to fresh-install values', () {
    final t = result.settings.tablesSettings;
    expect(t.distanceEndMeter, 1000.0);
    expect(t.distanceStepMeter, 100.0);
    expect(t.showMil, isTrue);
    expect(t.showMoa, isTrue);
    expect(t.showInClicks, isTrue);
  });

  test('missing ConvertorsState falls back to the old non-zero defaults', () {
    final c = result.settings.convertorsState;
    expect(c.length.value, 100.0);
    expect(c.length.lastUnit, 'inch');
    expect(c.velocity.valueMps, 300.0);
    expect(c.angles.angularValueMil, 1.0);
    expect(c.distanceConvTargetSize.sizeInch, 8.0);
  });
}
