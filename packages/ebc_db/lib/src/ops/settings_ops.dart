import '../generated/field_constraints.g.dart';
import '../proto/settings.pb.dart';

/// Clamps every numeric field this package generates a [FieldLimits] role
/// for into range, on a copy of [data] — the "reject/repair invalid writes"
/// gate from docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7. Same
/// convention as `profiles_ops.dart`'s `sanitizeProfile`: takes the old
/// value, returns a new one, never mutates the argument.
///
/// `ConvertorsState`'s own direct fields (length/weight/pressure/
/// temperature/torque) are left untouched — not generated yet, see that
/// doc for why (nested one level deeper than every other field here, and
/// three of them have an unresolved unit/range discrepancy).
SettingsData sanitizeSettingsData(SettingsData data) {
  final next = data.deepCopy();
  // ensureX() (not the plain getter) so an unset sub-message becomes a
  // writable instance instead of the shared frozen default — mutating that
  // default in place would throw.
  _sanitizeGeneralSettings(next.ensureGeneralSettings());
  _sanitizeTablesSettings(next.ensureTablesSettings());
  _sanitizeShootingConditions(next.ensureShootingConditions());
  _sanitizeConvertorsState(next.ensureConvertorsState());
  return next;
}

void _sanitizeGeneralSettings(GeneralSettings g) {
  g.homeChartDistanceStep = FieldLimits.distanceStepMeter.clamp(g.homeChartDistanceStep);
  g.homeTableDistanceStep = FieldLimits.distanceStepMeter.clamp(g.homeTableDistanceStep);
}

void _sanitizeTablesSettings(TablesSettings t) {
  t.distanceStartMeter = FieldLimits.tableRangeMeter.clamp(t.distanceStartMeter);
  t.distanceEndMeter = FieldLimits.tableRangeMeter.clamp(t.distanceEndMeter);
  t.distanceStepMeter = FieldLimits.distanceStepMeter.clamp(t.distanceStepMeter);
}

void _sanitizeShootingConditions(ShootingConditions s) {
  s.distanceMeter = FieldLimits.targetDistanceMeter.clamp(s.distanceMeter);
  s.lookAngleRad = FieldLimits.lookAngleRad.clamp(s.lookAngleRad);
  s.altitudeMeter = FieldLimits.altitudeMeter.clamp(s.altitudeMeter);
  s.temperatureC = FieldLimits.temperatureC.clamp(s.temperatureC);
  s.pressureHPa = FieldLimits.pressureHPa.clamp(s.pressureHPa);
  s.humidityFrac = FieldLimits.humidityFrac.clamp(s.humidityFrac);
  s.powderTemperatureC = FieldLimits.temperatureC.clamp(s.powderTemperatureC);
  s.latitudeDeg = FieldLimits.latitudeDeg.clamp(s.latitudeDeg);
  s.azimuthDeg = FieldLimits.azimuthDeg.clamp(s.azimuthDeg);
  s.windDirectionDeg = FieldLimits.windDirectionDeg.clamp(s.windDirectionDeg);
  s.windSpeedMps = FieldLimits.windSpeedMps.clamp(s.windSpeedMps);
}

void _sanitizeConvertorsState(ConvertorsState c) {
  final angles = c.ensureAngles();
  angles.distanceValueMeter = FieldLimits.convertorDistanceMeter.clamp(angles.distanceValueMeter);

  final velocity = c.ensureVelocity();
  velocity.valueMps = FieldLimits.convertorVelocityMps.clamp(velocity.valueMps);
  velocity.atmoTemperatureC = FieldLimits.temperatureC.clamp(velocity.atmoTemperatureC);
  velocity.atmoPressureHPa = FieldLimits.pressureHPa.clamp(velocity.atmoPressureHPa);
  velocity.atmoHumidityFrac = FieldLimits.humidityFrac.clamp(velocity.atmoHumidityFrac);
  velocity.atmoAltitudeMeter = FieldLimits.altitudeMeter.clamp(velocity.atmoAltitudeMeter);

  final targetSize = c.ensureDistanceConvTargetSize();
  targetSize.sizeInch = FieldLimits.convertorTargetPhysicalSizeInch.clamp(targetSize.sizeInch);
  targetSize.sizeAngularMil = FieldLimits.targetSizeMil.clamp(targetSize.sizeAngularMil);

  // length/weight/pressure/temperature/torque: intentionally not clamped,
  // see the doc comment above.
}

/// Non-zero starting values for the unit converters — the defaults the old
/// ObjectBox entity had and `settings.schema.json` documents. A bare
/// `ConvertorsState()` decodes as all-zero/empty, so seeding, the legacy
/// migration (no `ConvertorsState` record in `data.mdb`) and the provider
/// fallback all go through here instead.
ConvertorsState defaultConvertorsState() => ConvertorsState(
  length: UnitValue(value: 100.0, lastUnit: 'inch'),
  weight: UnitValue(value: 100.0, lastUnit: 'grain'),
  // Stored in mmHg, shown in hPa — ported app behaviour, see the schema.
  pressure: UnitValue(value: 1013.0, lastUnit: 'hPa'),
  temperature: UnitValue(value: 68.0, lastUnit: 'celsius'),
  torque: UnitValue(value: 100.0, lastUnit: 'newtonMeter'),
  angles: AnglesConv(
    distanceValueMeter: 100.0,
    distanceLastUnit: 'meter',
    angularValueMil: 1.0,
    angularLastUnit: 'mil',
    outputLastUnit: 'centimeter',
  ),
  velocity: VelocityConv(
    valueMps: 300.0,
    lastUnit: 'mps',
    machInputValue: 0.881,
    machUseCustomAtmo: false,
    atmoTemperatureC: 15.0,
    atmoPressureHPa: 1013.25,
    atmoHumidityFrac: 0.0,
    atmoAltitudeMeter: 0.0,
  ),
  distanceConvTargetSize: DistanceConvTargetSize(
    sizeInch: 8.0,
    sizeUnit: 'inch',
    sizeAngularMil: 1.0,
    sizeAngularUnit: 'mil',
  ),
);
