import 'package:dart_bclibc/unit.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:riverpod/riverpod.dart';

class ShotConditionsNotifier extends AsyncNotifier<ShootingConditions> {
  @override
  ShootingConditions build() =>
      ref.watch(settingsDataProvider.select((s) => s.shootingConditions));

  void _update(void Function(ShootingConditions) mutate) {
    ref.read(settingsDataProvider.notifier).update((s) {
      final copy = s.deepCopy();
      mutate(copy.shootingConditions);
      return copy;
    });
  }

  // ── Distance / geometry ───────────────────────────────────────────────────────

  Future<void> updateDistance(double meters) async {
    final clamped = FC.targetDistance.clamp(meters);
    _update((s) => s.distanceMeter = clamped); // raw — no unit conversion needed
  }

  Future<void> updateLookAngle(double degrees) async {
    final clamped = FC.lookAngle.clamp(degrees);
    _update((s) => s.lookAngle = Angular.degree(clamped));
  }

  Future<void> updateAltitude(double meters) async {
    final clamped = FC.altitude.clamp(meters);
    _update((s) => s.altitudeMeter = clamped); // raw — no unit conversion needed
  }

  // ── Atmosphere ────────────────────────────────────────────────────────────────

  Future<void> updateTemperature(double celsius) async {
    final clamped = FC.temperature.clamp(celsius);
    _update((s) => s.temperature = Temperature.celsius(clamped));
  }

  Future<void> updatePressure(double hpa) async {
    final clamped = FC.pressure.clamp(hpa);
    _update((s) => s.pressure = Pressure.hPa(clamped));
  }

  Future<void> updateHumidity(double fraction) async {
    final clamped = FC.humidity.clamp(fraction);
    _update((s) => s.humidity = Ratio.fraction(clamped));
  }

  Future<void> updatePowderTemperature(double celsius) async {
    final clamped = FC.temperature.clamp(celsius);
    _update((s) => s.powderTemperature = Temperature.celsius(clamped));
  }

  // ── Wind ──────────────────────────────────────────────────────────────────────

  Future<void> updateWindSpeed(double mps) async {
    final clamped = FC.windSpeed.clamp(mps);
    _update((s) => s.windSpeed = Velocity.mps(clamped));
  }

  Future<void> updateWindDirection(double degrees) async {
    final clamped = FC.windDirection.clamp(degrees);
    _update((s) => s.windDirection = Angular.degree(clamped));
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
    final clamped = FC.latitude.clamp(degrees ?? 0.0);
    _update((s) => s.latitude = Angular.degree(clamped));
  }

  Future<void> updateAzimuth(double? degrees) async {
    final clamped = FC.azimuth.clamp(degrees ?? 0.0);
    _update((s) => s.azimuth = Angular.degree(clamped));
  }
}

final shotConditionsProvider =
    AsyncNotifierProvider<ShotConditionsNotifier, ShootingConditions>(
      ShotConditionsNotifier.new,
    );
