import 'package:dart_bclibc_flutter/unit.dart';
import 'package:ebc_db/ebc_db.dart';

extension ConvertorsStateExtension on ConvertorsState {
  Distance get lengthValue => Distance.inch(length.value);
  set lengthValue(Distance v) => ensureLength().value = v.in_(Unit.inch);

  Unit get lengthUnit => Unit.values.firstWhere(
    (u) => u.name == length.lastUnit,
    orElse: () => Unit.inch,
  );
  set lengthUnit(Unit v) => ensureLength().lastUnit = v.name;

  Weight get weightValue => Weight.grain(weight.value);
  set weightValue(Weight v) => ensureWeight().value = v.in_(Unit.grain);

  Unit get weightUnit => Unit.values.firstWhere(
    (u) => u.name == weight.lastUnit,
    orElse: () => Unit.grain,
  );
  set weightUnit(Unit v) => ensureWeight().lastUnit = v.name;

  Pressure get pressureValue => Pressure.mmHg(pressure.value);
  set pressureValue(Pressure v) => ensurePressure().value = v.in_(Unit.mmHg);

  Unit get pressureUnit => Unit.values.firstWhere(
    (u) => u.name == pressure.lastUnit,
    orElse: () => Unit.hPa,
  );
  set pressureUnit(Unit v) => ensurePressure().lastUnit = v.name;

  Temperature get temperatureValue => Temperature.fahrenheit(temperature.value);
  set temperatureValue(Temperature v) =>
      ensureTemperature().value = v.in_(Unit.fahrenheit);

  Unit get temperatureUnit => Unit.values.firstWhere(
    (u) => u.name == temperature.lastUnit,
    orElse: () => Unit.celsius,
  );
  set temperatureUnit(Unit v) => ensureTemperature().lastUnit = v.name;

  Torque get torqueValue => Torque.newtonMeter(torque.value);
  set torqueValue(Torque v) => ensureTorque().value = v.in_(Unit.newtonMeter);

  Unit get torqueUnit => Unit.values.firstWhere(
    (u) => u.name == torque.lastUnit,
    orElse: () => Unit.newtonMeter,
  );
  set torqueUnit(Unit v) => ensureTorque().lastUnit = v.name;

  Distance get anglesConvDistanceValue =>
      Distance.meter(angles.distanceValueMeter);
  set anglesConvDistanceValue(Distance v) =>
      ensureAngles().distanceValueMeter = v.in_(Unit.meter);

  Unit get anglesConvDistanceUnit => Unit.values.firstWhere(
    (u) => u.name == angles.distanceLastUnit,
    orElse: () => Unit.meter,
  );
  set anglesConvDistanceUnit(Unit v) =>
      ensureAngles().distanceLastUnit = v.name;

  Angular get anglesConvAngularValue => Angular.mil(angles.angularValueMil);
  set anglesConvAngularValue(Angular v) =>
      ensureAngles().angularValueMil = v.in_(Unit.mil);

  Unit get anglesConvAngularUnit => Unit.values.firstWhere(
    (u) => u.name == angles.angularLastUnit,
    orElse: () => Unit.mil,
  );
  set anglesConvAngularUnit(Unit v) => ensureAngles().angularLastUnit = v.name;

  Unit get anglesConvOutputUnit => Unit.values.firstWhere(
    (u) => u.name == angles.outputLastUnit,
    orElse: () => Unit.centimeter,
  );
  set anglesConvOutputUnit(Unit v) => ensureAngles().outputLastUnit = v.name;

  Distance get distanceConvTargetSizeValue =>
      Distance.inch(distanceConvTargetSize.sizeInch);
  set distanceConvTargetSizeValue(Distance v) =>
      ensureDistanceConvTargetSize().sizeInch = v.in_(Unit.inch);

  Unit get distanceConvTargetSizeUnitValue => Unit.values.firstWhere(
    (u) => u.name == distanceConvTargetSize.sizeUnit,
    orElse: () => Unit.inch,
  );
  set distanceConvTargetSizeUnitValue(Unit v) =>
      ensureDistanceConvTargetSize().sizeUnit = v.name;

  Angular get distanceConvTargetSizeAngular =>
      Angular.mil(distanceConvTargetSize.sizeAngularMil);
  set distanceConvTargetSizeAngular(Angular v) =>
      ensureDistanceConvTargetSize().sizeAngularMil = v.in_(Unit.mil);

  Unit get distanceConvTargetSizeAngularUnitValue => Unit.values.firstWhere(
    (u) => u.name == distanceConvTargetSize.sizeAngularUnit,
    orElse: () => Unit.mil,
  );
  set distanceConvTargetSizeAngularUnitValue(Unit v) =>
      ensureDistanceConvTargetSize().sizeAngularUnit = v.name;

  Velocity get velocityValue => Velocity.mps(velocity.valueMps);
  set velocityValue(Velocity v) => ensureVelocity().valueMps = v.in_(Unit.mps);

  Unit get velocityUnit => Unit.values.firstWhere(
    (u) => u.name == velocity.lastUnit,
    orElse: () => Unit.mps,
  );
  set velocityUnit(Unit v) => ensureVelocity().lastUnit = v.name;

  Temperature get velocityAtmoTemperature =>
      Temperature.celsius(velocity.atmoTemperatureC);
  set velocityAtmoTemperature(Temperature v) =>
      ensureVelocity().atmoTemperatureC = v.in_(Unit.celsius);

  Pressure get velocityAtmoPressure => Pressure.hPa(velocity.atmoPressureHPa);
  set velocityAtmoPressure(Pressure v) =>
      ensureVelocity().atmoPressureHPa = v.in_(Unit.hPa);

  Distance get velocityAtmoAltitude =>
      Distance.meter(velocity.atmoAltitudeMeter);
  set velocityAtmoAltitude(Distance v) =>
      ensureVelocity().atmoAltitudeMeter = v.in_(Unit.meter);
}
