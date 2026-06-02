import 'dart:async';

import 'package:bclibc_ffi/bclibc.dart';
import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:ebalistyka/core/extensions/convertors_extensions.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:riverpod/riverpod.dart';

class ConvertorsNotifier extends AsyncNotifier<ConvertorsState> {
  ISettingsRepository get _repo => ref.read(settingsRepositoryProvider);
  int get _ownerId => ref.read(ownerIdProvider);

  @override
  Future<ConvertorsState> build() async {
    final ownerId = _ownerId;

    final subscription = _repo.watchConvertorsState(ownerId).listen((_) {
      unawaited(_repo.loadOrCreateConvertorsState(ownerId).then((s) => state = AsyncData(s)));
    });
    ref.onDispose(subscription.cancel);

    return _repo.loadOrCreateConvertorsState(ownerId);
  }

  Future<void> _save(ConvertorsState s) async {
    await _repo.saveConvertorsState(s, _ownerId);
    state = AsyncData(s);
  }

  // ── Length ────────────────────────────────────────────────────────────────────

  Future<void> updateLengthValue(double? valueInInches) async {
    if (valueInInches == null || valueInInches < 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.lengthValueInch = valueInInches;
    await _save(s);
  }

  Future<void> updateLengthUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.lengthUnit = unit;
    await _save(s);
  }

  // ── Weight ────────────────────────────────────────────────────────────────────

  Future<void> updateWeightValue(double? valueInGrains) async {
    if (valueInGrains == null || valueInGrains < 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.weightValueGrain = valueInGrains;
    await _save(s);
  }

  Future<void> updateWeightUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.weightUnit = unit;
    await _save(s);
  }

  // ── Pressure ──────────────────────────────────────────────────────────────────

  Future<void> updatePressureValue(double? valueInMmHg) async {
    if (valueInMmHg == null || valueInMmHg < 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.pressureValueMmHg = valueInMmHg;
    await _save(s);
  }

  Future<void> updatePressureUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.pressureUnit = unit;
    await _save(s);
  }

  // ── Temperature ───────────────────────────────────────────────────────────────

  Future<void> updateTemperatureValue(double? valueInFahrenheit) async {
    if (valueInFahrenheit == null) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.temperatureValueF = valueInFahrenheit;
    await _save(s);
  }

  Future<void> updateTemperatureUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.temperatureUnit = unit;
    await _save(s);
  }

  // ── Torque ────────────────────────────────────────────────────────────────────

  Future<void> updateTorqueValue(double? valueInNewtonMeter) async {
    if (valueInNewtonMeter == null || valueInNewtonMeter < 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.torqueValueNewtonMeter = valueInNewtonMeter;
    await _save(s);
  }

  Future<void> updateTorqueUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.torqueUnit = unit;
    await _save(s);
  }

  // ── Velocity ──────────────────────────────────────────────────────────────────

  Future<void> updateVelocityValue(double? valueInMps) async {
    if (valueInMps == null || valueInMps < 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.velocityValue = Velocity.mps(valueInMps);
    await _save(s);
  }

  Future<void> updateVelocityUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.velocityUnit = unit;
    await _save(s);
  }

  Future<void> updateVelocityMachInputValue(double mach) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.velocityMachInputValue = mach;
    await _save(s);
  }

  Future<void> updateVelocityMachUseCustomAtmo(bool value) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.velocityMachUseCustomAtmo = value;
    await _save(s);
  }

  Future<void> updateVelocityAtmoTemperature(Temperature value) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.velocityAtmoTemperature = value;
    await _save(s);
  }

  Future<void> updateVelocityAtmoPressure(Pressure value) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.velocityAtmoPressure = value;
    await _save(s);
  }

  Future<void> updateVelocityAtmoHumidityFrac(double valueFrac) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.velocityAtmoHumidityFrac = valueFrac;
    await _save(s);
  }

  Future<void> updateVelocityAtmoAltitude(Distance value) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.velocityAtmoAltitude = value;
    await _save(s);
  }

  // ── Target distance convertor ─────────────────────────────────────────────────

  Future<void> updateDistanceConvTargetSize(double? valueInInches) async {
    if (valueInInches == null || valueInInches < 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.distanceConvTargetSizeInch = valueInInches;
    await _save(s);
  }

  Future<void> updateDistanceConvTargetSizeUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.distanceConvTargetSizeUnitValue = unit;
    await _save(s);
  }

  Future<void> updateDistanceConvTargetSizeAngular(double? valueInMil) async {
    if (valueInMil == null || valueInMil <= 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.distanceConvTargetSizeAngularMil = valueInMil;
    await _save(s);
  }

  Future<void> updateDistanceConvTargetSizeAngularUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.distanceConvTargetSizeAngularUnitValue = unit;
    await _save(s);
  }

  // ── Angles convertor ──────────────────────────────────────────────────────────

  Future<void> updateAnglesConvDistanceValue(double? valueInMeters) async {
    if (valueInMeters == null || valueInMeters < 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.anglesConvDistanceValueMeter = valueInMeters;
    await _save(s);
  }

  Future<void> updateAnglesConvDistanceUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.anglesConvDistanceUnit = unit;
    await _save(s);
  }

  Future<void> updateAnglesConvAngularValue(double? valueInMil) async {
    if (valueInMil == null || valueInMil < 0) return;
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.anglesConvAngularValueMil = valueInMil;
    await _save(s);
  }

  Future<void> updateAnglesConvAngularUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.anglesConvAngularUnit = unit;
    await _save(s);
  }

  Future<void> updateAnglesConvOutputUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateConvertorsState(_ownerId);
    s.anglesConvOutputUnit = unit;
    await _save(s);
  }
}

final convertorsProvider =
    AsyncNotifierProvider<ConvertorsNotifier, ConvertorsState>(
      ConvertorsNotifier.new,
    );

/// Synchronous access — returns defaults while loading.
final convertorStateProvider = Provider<ConvertorsState>((ref) {
  return ref.watch(convertorsProvider).value ?? ConvertorsState();
});
