import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/extensions/convertors_extensions.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:ebalistyka/features/convertors/simple_convertor_vm.dart';
import 'package:riverpod/riverpod.dart';

// The five "simple" convertors, one spec each: what is stored, which units
// are offered and shown, and the allowed range. The VM and the screen are
// shared (simple_convertor_vm.dart, sub_screens/simple_convertor_screen.dart).

typedef _VmProvider =
    NotifierProvider<SimpleConvertorVm, SimpleConvertorUiState>;

// ── Length ──────────────────────────────────────────────────────────────────

final _lengthSpec = SimpleConvertorSpec(
  title: (l) => l.lengthConvertorTitle,
  hint: (l) => l.enterLength,
  baseUnit: Unit.inch,
  unitOptions: const [
    Unit.centimeter,
    Unit.meter,
    Unit.inch,
    Unit.foot,
    Unit.yard,
  ],
  sections: [
    ConvertorSectionSpec((l) => l.sectionMetric, [
      ConvertorUnit(Unit.centimeter, (l) => l.unitCentimeters),
      ConvertorUnit(Unit.meter, (l) => l.unitMeters),
    ]),
    ConvertorSectionSpec((l) => l.sectionImperial, [
      ConvertorUnit(Unit.inch, (l) => l.unitInches),
      ConvertorUnit(Unit.foot, (l) => l.unitFeet),
      ConvertorUnit(Unit.yard, (l) => l.unitYards),
    ]),
  ],
  rawBase: (s) => s.length.value,
  inputUnit: (s) => s.lengthUnit,
  saveRawBase: (n, v) => n.updateLengthValue(v),
  saveInputUnit: (n, u) => n.updateLengthUnit(u),
  constraintsFor: FC.convertorLength.inUnit,
);

final lengthConvertorVmProvider = _VmProvider(
  () => SimpleConvertorVm(_lengthSpec),
);

// ── Weight ──────────────────────────────────────────────────────────────────

final _weightSpec = SimpleConvertorSpec(
  title: (l) => l.weightConvertorTitle,
  hint: (l) => l.enterWeight,
  baseUnit: Unit.grain,
  unitOptions: const [
    Unit.gram,
    Unit.kilogram,
    Unit.grain,
    Unit.pound,
    Unit.ounce,
  ],
  sections: [
    ConvertorSectionSpec((l) => l.sectionMetric, [
      ConvertorUnit(Unit.gram, (l) => l.unitGrams),
      ConvertorUnit(Unit.kilogram, (l) => l.unitKilograms),
    ]),
    ConvertorSectionSpec((l) => l.sectionImperial, [
      ConvertorUnit(Unit.grain, (l) => l.unitGrains),
      ConvertorUnit(Unit.pound, (l) => l.unitPounds),
      ConvertorUnit(Unit.ounce, (l) => l.unitOunces),
    ]),
  ],
  rawBase: (s) => s.weight.value,
  inputUnit: (s) => s.weightUnit,
  saveRawBase: (n, v) => n.updateWeightValue(v),
  saveInputUnit: (n, u) => n.updateWeightUnit(u),
  constraintsFor: FC.convertorWeight.inUnit,
);

final weightConvertorVmProvider = _VmProvider(
  () => SimpleConvertorVm(_weightSpec),
);

// ── Pressure ────────────────────────────────────────────────────────────────

final _pressureSpec = SimpleConvertorSpec(
  title: (l) => l.pressureConvertorTitle,
  hint: (l) => l.enterPressure,
  baseUnit: Unit.mmHg,
  unitOptions: const [
    Unit.mmHg,
    Unit.inHg,
    Unit.bar,
    Unit.hPa,
    Unit.psi,
    Unit.atm,
  ],
  sections: [
    ConvertorSectionSpec((l) => l.sectionCommon, [
      ConvertorUnit(Unit.atm, (l) => l.unitAtmosphere),
      ConvertorUnit(Unit.hPa, (l) => l.unitHPa),
      ConvertorUnit(Unit.bar, (l) => l.unitBar),
    ]),
    ConvertorSectionSpec((l) => l.sectionImperial, [
      ConvertorUnit(Unit.psi, (l) => l.unitPsi),
      ConvertorUnit(Unit.inHg, (l) => l.unitInHg),
      ConvertorUnit(Unit.mmHg, (l) => l.unitMmHg),
    ]),
  ],
  rawBase: (s) => s.pressure.value,
  inputUnit: (s) => s.pressureUnit,
  saveRawBase: (n, v) => n.updatePressureValue(v),
  saveInputUnit: (n, u) => n.updatePressureUnit(u),
  // Allowed range is 0–2000 mmHg, wider than FC.convertorPressure.
  constraintsFor: (unit) => FieldConstraints(
    minRaw: 0.0.convert(Unit.mmHg, unit),
    maxRaw: 2000.0.convert(Unit.mmHg, unit),
    stepRaw: FC.convertorPressure.stepRaw.convert(Unit.mmHg, unit),
    rawUnit: unit,
    accuracy: FC.convertorPressure.accuracyFor(unit),
  ),
);

final pressureConvertorVmProvider = _VmProvider(
  () => SimpleConvertorVm(_pressureSpec),
);

// ── Temperature ─────────────────────────────────────────────────────────────

final _temperatureSpec = SimpleConvertorSpec(
  title: (l) => l.temperatureConvertorTitle,
  hint: (l) => l.enterTemperature,
  baseUnit: Unit.fahrenheit,
  unitOptions: const [Unit.celsius, Unit.fahrenheit],
  sections: [
    ConvertorSectionSpec((l) => l.sectionMetric, [
      ConvertorUnit(Unit.celsius, (l) => l.unitCelsius),
    ]),
    ConvertorSectionSpec((l) => l.sectionImperial, [
      ConvertorUnit(Unit.fahrenheit, (l) => l.unitFahrenheit),
    ]),
  ],
  rawBase: (s) => s.temperature.value,
  inputUnit: (s) => s.temperatureUnit,
  saveRawBase: (n, v) => n.updateTemperatureValue(v),
  saveInputUnit: (n, u) => n.updateTemperatureUnit(u),
  // From absolute zero up, one decimal.
  constraintsFor: (unit) => FieldConstraints(
    minRaw: (-459.67).convert(Unit.fahrenheit, unit),
    maxRaw: 10000.0.convert(Unit.fahrenheit, unit),
    stepRaw: 0.1.convert(Unit.fahrenheit, unit),
    rawUnit: unit,
    accuracy: 1,
  ),
);

final temperatureConvertorVmProvider = _VmProvider(
  () => SimpleConvertorVm(_temperatureSpec),
);

// ── Torque ──────────────────────────────────────────────────────────────────

final _torqueSpec = SimpleConvertorSpec(
  title: (l) => l.torqueConvertorTitle,
  hint: (l) => l.enterTorque,
  baseUnit: Unit.newtonMeter,
  unitOptions: const [Unit.newtonMeter, Unit.footPoundTorque, Unit.inchPound],
  sections: [
    ConvertorSectionSpec((l) => l.sectionMetric, [
      ConvertorUnit(Unit.newtonMeter, (l) => l.unitNewtonMeter),
    ]),
    ConvertorSectionSpec((l) => l.sectionImperial, [
      ConvertorUnit(Unit.footPoundTorque, (l) => l.unitFootPound),
      ConvertorUnit(Unit.inchPound, (l) => l.unitInchPound),
    ]),
  ],
  rawBase: (s) => s.torque.value,
  inputUnit: (s) => s.torqueUnit,
  saveRawBase: (n, v) => n.updateTorqueValue(v),
  saveInputUnit: (n, u) => n.updateTorqueUnit(u),
  constraintsFor: FC.convertorTorque.inUnit,
);

final torqueConvertorVmProvider = _VmProvider(
  () => SimpleConvertorVm(_torqueSpec),
);
