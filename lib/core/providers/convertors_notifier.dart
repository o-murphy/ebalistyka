import 'package:dart_bclibc/bclibc.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:ebalistyka/core/extensions/convertors_extensions.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:riverpod/riverpod.dart';

class ConvertorsNotifier extends AsyncNotifier<ConvertorsState> {
  @override
  ConvertorsState build() =>
      ref.watch(settingsDataProvider.select((s) => s.convertorsState));

  void _update(void Function(ConvertorsState) mutate) {
    ref.read(settingsDataProvider.notifier).update((s) {
      final copy = s.deepCopy();
      mutate(copy.convertorsState);
      return copy;
    });
  }

  // ── Length ────────────────────────────────────────────────────────────────────

  Future<void> updateLengthValue(double? valueInInches) async {
    if (valueInInches == null || valueInInches < 0) return;
    _update((c) => c.lengthValue = Distance.inch(valueInInches));
  }

  Future<void> updateLengthUnit(Unit unit) async {
    _update((c) => c.lengthUnit = unit);
  }

  // ── Weight ────────────────────────────────────────────────────────────────────

  Future<void> updateWeightValue(double? valueInGrains) async {
    if (valueInGrains == null || valueInGrains < 0) return;
    _update((c) => c.weightValue = Weight.grain(valueInGrains));
  }

  Future<void> updateWeightUnit(Unit unit) async {
    _update((c) => c.weightUnit = unit);
  }

  // ── Pressure ──────────────────────────────────────────────────────────────────

  Future<void> updatePressureValue(double? valueInMmHg) async {
    if (valueInMmHg == null || valueInMmHg < 0) return;
    _update((c) => c.pressureValue = Pressure.mmHg(valueInMmHg));
  }

  Future<void> updatePressureUnit(Unit unit) async {
    _update((c) => c.pressureUnit = unit);
  }

  // ── Temperature ───────────────────────────────────────────────────────────────

  Future<void> updateTemperatureValue(double? valueInFahrenheit) async {
    if (valueInFahrenheit == null) return;
    _update((c) => c.temperatureValue = Temperature.fahrenheit(valueInFahrenheit));
  }

  Future<void> updateTemperatureUnit(Unit unit) async {
    _update((c) => c.temperatureUnit = unit);
  }

  // ── Torque ────────────────────────────────────────────────────────────────────

  Future<void> updateTorqueValue(double? valueInNewtonMeter) async {
    if (valueInNewtonMeter == null || valueInNewtonMeter < 0) return;
    _update((c) => c.torqueValue = Torque.newtonMeter(valueInNewtonMeter));
  }

  Future<void> updateTorqueUnit(Unit unit) async {
    _update((c) => c.torqueUnit = unit);
  }

  // ── Velocity ──────────────────────────────────────────────────────────────────

  Future<void> updateVelocityValue(double? valueInMps) async {
    if (valueInMps == null || valueInMps < 0) return;
    _update((c) => c.velocityValue = Velocity.mps(valueInMps));
  }

  Future<void> updateVelocityUnit(Unit unit) async {
    _update((c) => c.velocityUnit = unit);
  }

  Future<void> updateVelocityMachInputValue(double mach) async {
    _update((c) => c.ensureVelocity().machInputValue = mach);
  }

  Future<void> updateVelocityMachUseCustomAtmo(bool value) async {
    _update((c) => c.ensureVelocity().machUseCustomAtmo = value);
  }

  Future<void> updateVelocityAtmoTemperature(Temperature value) async {
    _update((c) => c.velocityAtmoTemperature = value);
  }

  Future<void> updateVelocityAtmoPressure(Pressure value) async {
    _update((c) => c.velocityAtmoPressure = value);
  }

  Future<void> updateVelocityAtmoHumidityFrac(double valueFrac) async {
    _update((c) => c.ensureVelocity().atmoHumidityFrac = valueFrac);
  }

  Future<void> updateVelocityAtmoAltitude(Distance value) async {
    _update((c) => c.velocityAtmoAltitude = value);
  }

  // ── Target distance convertor ─────────────────────────────────────────────────

  Future<void> updateDistanceConvTargetSize(double? valueInInches) async {
    if (valueInInches == null || valueInInches < 0) return;
    _update(
      (c) => c.distanceConvTargetSizeValue = Distance.inch(valueInInches),
    );
  }

  Future<void> updateDistanceConvTargetSizeUnit(Unit unit) async {
    _update((c) => c.distanceConvTargetSizeUnitValue = unit);
  }

  Future<void> updateDistanceConvTargetSizeAngular(double? valueInMil) async {
    if (valueInMil == null || valueInMil <= 0) return;
    _update(
      (c) => c.distanceConvTargetSizeAngular = Angular.mil(valueInMil),
    );
  }

  Future<void> updateDistanceConvTargetSizeAngularUnit(Unit unit) async {
    _update((c) => c.distanceConvTargetSizeAngularUnitValue = unit);
  }

  // ── Angles convertor ──────────────────────────────────────────────────────────

  Future<void> updateAnglesConvDistanceValue(double? valueInMeters) async {
    if (valueInMeters == null || valueInMeters < 0) return;
    _update((c) => c.anglesConvDistanceValue = Distance.meter(valueInMeters));
  }

  Future<void> updateAnglesConvDistanceUnit(Unit unit) async {
    _update((c) => c.anglesConvDistanceUnit = unit);
  }

  Future<void> updateAnglesConvAngularValue(double? valueInMil) async {
    if (valueInMil == null || valueInMil < 0) return;
    _update((c) => c.anglesConvAngularValue = Angular.mil(valueInMil));
  }

  Future<void> updateAnglesConvAngularUnit(Unit unit) async {
    _update((c) => c.anglesConvAngularUnit = unit);
  }

  Future<void> updateAnglesConvOutputUnit(Unit unit) async {
    _update((c) => c.anglesConvOutputUnit = unit);
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
