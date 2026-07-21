import 'package:dart_bclibc/unit.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:riverpod/riverpod.dart';

class ShotConditionsNotifier extends AsyncNotifier<ShootingConditions> {
  @override
  ShootingConditions build() =>
      ref.watch(settingsDataProvider.select((s) => s.shootingConditions));

  // No per-field clamp needed here — settingsDataProvider.notifier.update()
  // runs sanitizeSettingsData() on every write (see db_provider.dart), which
  // clamps ShootingConditions against the same FieldLimits these setters
  // used to clamp against by hand. See
  // docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7.
  void _update(void Function(ShootingConditions) mutate) {
    ref.read(settingsDataProvider.notifier).update((s) {
      final copy = s.deepCopy();
      mutate(copy.shootingConditions);
      return copy;
    });
  }

  // ── Distance / geometry ───────────────────────────────────────────────────────

  Future<void> updateDistance(double meters) async {
    _update((s) => s.distanceMeter = meters); // raw — no unit conversion needed
  }

  Future<void> updateLookAngle(double degrees) async {
    _update((s) => s.lookAngle = Angular.degree(degrees));
  }

  Future<void> updateAltitude(double meters) async {
    _update((s) => s.altitudeMeter = meters); // raw — no unit conversion needed
  }

  // ── Atmosphere ────────────────────────────────────────────────────────────────

  Future<void> updateTemperature(double celsius) async {
    _update((s) => s.temperature = Temperature.celsius(celsius));
  }

  Future<void> updatePressure(double hpa) async {
    _update((s) => s.pressure = Pressure.hPa(hpa));
  }

  Future<void> updateHumidity(double fraction) async {
    _update((s) => s.humidity = Ratio.fraction(fraction));
  }

  Future<void> updatePowderTemperature(double celsius) async {
    _update((s) => s.powderTemperature = Temperature.celsius(celsius));
  }

  // ── Wind ──────────────────────────────────────────────────────────────────────

  Future<void> updateWindSpeed(double mps) async {
    _update((s) => s.windSpeed = Velocity.mps(mps));
  }

  Future<void> updateWindDirection(double degrees) async {
    _update((s) => s.windDirection = Angular.degree(degrees));
  }

  // ── Flags ─────────────────────────────────────────────────────────────────────

  Future<void> updateUsePowderSensitivity(bool value) async {
    _update((s) => s.usePowderSensitivity = value);
  }

  Future<void> updateUseDiffPowderTemp(bool value) async {
    _update((s) => s.useDiffPowderTemp = value);
  }

  Future<void> updateUseCoriolis(bool value) async {
    _update((s) => s.useCoriolis = value);
  }

  Future<void> updateLatitude(double? degrees) async {
    _update((s) => s.latitude = Angular.degree(degrees ?? 0.0));
  }

  Future<void> updateAzimuth(double? degrees) async {
    _update((s) => s.azimuth = Angular.degree(degrees ?? 0.0));
  }
}

final shotConditionsProvider =
    AsyncNotifierProvider<ShotConditionsNotifier, ShootingConditions>(
      ShotConditionsNotifier.new,
    );
