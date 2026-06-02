import 'dart:async';

import 'package:bclibc_ffi/unit.dart';
import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:riverpod/riverpod.dart';

class ShotConditionsNotifier extends AsyncNotifier<ShootingConditions> {
  ISettingsRepository get _repo => ref.read(settingsRepositoryProvider);
  int get _ownerId => ref.read(ownerIdProvider);

  @override
  Future<ShootingConditions> build() async {
    final ownerId = _ownerId;

    final subscription = _repo.watchShootingConditions(ownerId).listen((_) {
      unawaited(_repo.loadOrCreateShootingConditions(ownerId).then((s) => state = AsyncData(s)));
    });
    ref.onDispose(subscription.cancel);

    return _repo.loadOrCreateShootingConditions(ownerId);
  }

  Future<void> _save(ShootingConditions cond) async {
    await _repo.saveShootingConditions(cond, _ownerId);
  }

  Future<void> restore(ConditionsExport export) async {
    await _repo.restoreShootingConditions(export, _ownerId);
  }

  // ── Distance / geometry ───────────────────────────────────────────────────────

  Future<void> updateDistance(double meters) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.distanceMeter = meters;
    await _save(s);
  }

  Future<void> updateLookAngle(double degrees) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.lookAngle = Angular.degree(degrees);
    await _save(s);
  }

  Future<void> updateAltitude(double meters) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.altitudeMeter = meters;
    await _save(s);
  }

  // ── Atmosphere ────────────────────────────────────────────────────────────────

  Future<void> updateTemperature(double celsius) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.temperature = Temperature.celsius(celsius);
    await _save(s);
  }

  Future<void> updatePressure(double hpa) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.pressure = Pressure.hPa(hpa);
    await _save(s);
  }

  Future<void> updateHumidity(double fraction) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.humidity = Ratio.fraction(fraction);
    await _save(s);
  }

  Future<void> updatePowderTemperature(double celsius) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.powderTemperature = Temperature.celsius(celsius);
    await _save(s);
  }

  // ── Wind ──────────────────────────────────────────────────────────────────────

  Future<void> updateWindSpeed(double mps) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.windSpeed = Velocity.mps(mps);
    await _save(s);
  }

  Future<void> updateWindDirection(double degrees) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.windDirection = Angular.degree(degrees);
    await _save(s);
  }

  // ── Flags ─────────────────────────────────────────────────────────────────────

  Future<void> updateUsePowderSensitivity(bool value) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.usePowderSensitivity = value;
    await _save(s);
  }

  Future<void> updateUseDiffPowderTemp(bool value) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.useDiffPowderTemp = value;
    await _save(s);
  }

  Future<void> updateUseCoriolis(bool value) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.useCoriolis = value;
    await _save(s);
  }

  Future<void> updateLatitude(double? degrees) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.latitude = Angular.degree(degrees ?? 0.0);
    await _save(s);
  }

  Future<void> updateAzimuth(double? degrees) async {
    final s = state.value ?? await _repo.loadOrCreateShootingConditions(_ownerId);
    s.azimuth = Angular.degree(degrees ?? 0.0);
    await _save(s);
  }
}

final shotConditionsProvider =
    AsyncNotifierProvider<ShotConditionsNotifier, ShootingConditions>(
      ShotConditionsNotifier.new,
    );
