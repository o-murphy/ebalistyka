import 'dart:math';
import 'package:dart_bclibc/unit.dart';
import 'package:ebc_db/ebc_db.dart' show FieldLimits;

abstract interface class Constraints {
  Unit get rawUnit;
  double get minRaw;
  double get maxRaw;
  double get stepRaw;
  int get accuracy;
  int accuracyFor(Unit displayUnit);

  /// Clamps [raw] (in [rawUnit]) into [minRaw, maxRaw].
  double clamp(double raw);
}

/// Constraints for a physical quantity role — used by [UnitValueField]
/// and for display formatting in tables, charts, and widgets.
///
/// All values are in [rawUnit] (the storage/base unit).
/// The UI converts to the selected display unit before showing.
class FieldConstraints implements Constraints {
  const FieldConstraints({
    required this.rawUnit,
    required this.minRaw,
    required this.maxRaw,
    required this.stepRaw,
    required this.accuracy,
  });

  @override
  final Unit rawUnit;
  @override
  final double minRaw;
  @override
  final double maxRaw;
  @override
  final double stepRaw;

  /// Decimal places when displayed in [rawUnit]. Used as fallback.
  @override
  final int accuracy;

  /// Returns the number of decimal places appropriate for [displayUnit].
  ///
  /// Mirrors the logic used internally by [UnitValueField]: converts
  /// [stepRaw] to [displayUnit] and infers the required precision from it.
  @override
  int accuracyFor(Unit displayUnit) {
    if (rawUnit == displayUnit) return accuracy;
    final lo = minRaw.convert(rawUnit, displayUnit);
    final hi = (minRaw + stepRaw).convert(rawUnit, displayUnit);
    final step = (hi - lo).abs();
    if (step <= 0) return accuracy;
    final d = (-log(step) / ln10).ceil();
    return d < 0 ? 0 : d;
  }

  @override
  double clamp(double raw) => raw.clamp(minRaw, maxRaw);
}

/// Extension of [FieldConstraints] with ruler/graph tick configuration.
class RulerConstraints implements Constraints {
  RulerConstraints({required this.fc, double? tick, double? smallTick})
    : tick = tick ?? fc.stepRaw,
      smallTick =
          smallTick ?? _defaultSmallTick(tick ?? fc.stepRaw, fc.accuracy);

  final Constraints fc;
  final double tick;
  final double smallTick;

  static double _defaultSmallTick(double tick, int accuracy) {
    final minStep = pow(10, -accuracy).toDouble();
    final calculated = tick / 5;
    return calculated > minStep ? calculated : minStep;
  }

  @override
  Unit get rawUnit => fc.rawUnit;
  @override
  double get minRaw => fc.minRaw;
  @override
  double get maxRaw => fc.maxRaw;
  @override
  double get stepRaw => fc.stepRaw;
  @override
  int get accuracy => fc.accuracy;

  @override
  int accuracyFor(Unit displayUnit) => fc.accuracyFor(displayUnit);

  @override
  double clamp(double raw) => fc.clamp(raw);
}

// ─── Role definitions ─────────────────────────────────────────────────────────

abstract final class FC {
  // Environmental
  // minRaw/maxRaw below are resolved from ebc_db's generated FieldLimits
  // (single source of truth: schema/profiles.schema.json) wherever the wire
  // unit matches this role's rawUnit directly — see
  // docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7. These read an
  // instance field of a const FieldLimits object, which Dart doesn't allow
  // inside another `const` expression — hence `static final`, not `static
  // const` (nothing in this app requires FC.x to be compile-time const).
  static final temperature = FieldConstraints(
    rawUnit: Unit.celsius,
    minRaw: FieldLimits.temperatureC.minRaw,
    maxRaw: FieldLimits.temperatureC.maxRaw,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static final altitude = FieldConstraints(
    rawUnit: Unit.meter,
    minRaw: FieldLimits.altitudeMeter.minRaw,
    maxRaw: FieldLimits.altitudeMeter.maxRaw,
    stepRaw: 10.0,
    accuracy: 0,
  );

  static final pressure = FieldConstraints(
    rawUnit: Unit.hPa,
    minRaw: FieldLimits.pressureHPa.minRaw,
    maxRaw: FieldLimits.pressureHPa.maxRaw,
    stepRaw: 1.0,
    accuracy: 0,
  );

  /// Humidity in percent (0–100). rawUnit == displayUnit so toDisplay is identity.
  static final humidity = FieldConstraints(
    rawUnit: Unit.fraction,
    minRaw: FieldLimits.humidityFrac.minRaw,
    maxRaw: FieldLimits.humidityFrac.maxRaw,
    stepRaw: 0.01,
    accuracy: 0,
  );

  // Ballistic inputs
  static final windSpeed = FieldConstraints(
    rawUnit: Unit.mps,
    minRaw: FieldLimits.windSpeedMps.minRaw,
    maxRaw: FieldLimits.windSpeedMps.maxRaw,
    stepRaw: 0.5,
    accuracy: 1,
  );

  /// FieldLimits.lookAngleRad is stored in radians (look_angle_rad); this
  /// picker works in degrees, so minRaw/maxRaw convert here rather than
  /// being copied by hand — see Phase 7 in the storage doc.
  static final lookAngle = FieldConstraints(
    rawUnit: Unit.degree,
    minRaw: FieldLimits.lookAngleRad.minRaw.convert(Unit.radian, Unit.degree),
    maxRaw: FieldLimits.lookAngleRad.maxRaw.convert(Unit.radian, Unit.degree),
    stepRaw: 0.1,
    accuracy: 1,
  );

  static final latitude = FieldConstraints(
    rawUnit: Unit.degree,
    minRaw: FieldLimits.latitudeDeg.minRaw,
    maxRaw: FieldLimits.latitudeDeg.maxRaw,
    stepRaw: 1.0,
    accuracy: 1,
  );

  static final azimuth = FieldConstraints(
    rawUnit: Unit.degree,
    minRaw: FieldLimits.azimuthDeg.minRaw,
    maxRaw: FieldLimits.azimuthDeg.maxRaw,
    stepRaw: 1.0,
    accuracy: 1,
  );

  static final windDirection = FieldConstraints(
    rawUnit: Unit.degree,
    minRaw: FieldLimits.windDirectionDeg.minRaw,
    maxRaw: FieldLimits.windDirectionDeg.maxRaw,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static final targetDistance = FieldConstraints(
    rawUnit: Unit.meter,
    minRaw: FieldLimits.targetDistanceMeter.minRaw,
    maxRaw: FieldLimits.targetDistanceMeter.maxRaw,
    stepRaw: 10.0,
    accuracy: 0,
  );

  // Weapon / optics
  /// FieldLimits.sightHeightInch is stored in inch; this picker works in mm.
  static final sightHeight = FieldConstraints(
    rawUnit: Unit.millimeter,
    minRaw: FieldLimits.sightHeightInch.minRaw.convert(Unit.inch, Unit.millimeter),
    maxRaw: FieldLimits.sightHeightInch.maxRaw.convert(Unit.inch, Unit.millimeter),
    stepRaw: 1.0,
    accuracy: 0,
  );

  /// FieldLimits.twistInch is signed (-30..30, direction encoded by sign in
  /// storage) but this picker is a magnitude control paired with a separate
  /// direction toggle (see weapon_wizard_notifier.dart) — minRaw stays a
  /// hardcoded 0.0 floor, only maxRaw is resolved from the generated bound.
  static final twist = FieldConstraints(
    rawUnit: Unit.inch,
    minRaw: 0.0,
    maxRaw: FieldLimits.twistInch.maxRaw,
    stepRaw: 0.25,
    accuracy: 2,
  );

  static final zeroDistance = FieldConstraints(
    rawUnit: Unit.meter,
    minRaw: FieldLimits.zeroDistanceMeter.minRaw,
    maxRaw: FieldLimits.zeroDistanceMeter.maxRaw,
    stepRaw: 10.0,
    accuracy: 0,
  );

  // Projectile
  static final muzzleVelocity = FieldConstraints(
    rawUnit: Unit.mps,
    minRaw: FieldLimits.muzzleVelocityMps.minRaw,
    maxRaw: FieldLimits.muzzleVelocityMps.maxRaw,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static final projectileWeight = FieldConstraints(
    rawUnit: Unit.grain,
    minRaw: FieldLimits.projectileWeightGrain.minRaw,
    maxRaw: FieldLimits.projectileWeightGrain.maxRaw,
    stepRaw: 0.1,
    accuracy: 1,
  );

  /// FieldLimits.projectileLengthInch is stored in inch; this picker works in mm.
  static final projectileLength = FieldConstraints(
    rawUnit: Unit.millimeter,
    minRaw: FieldLimits.projectileLengthInch.minRaw.convert(Unit.inch, Unit.millimeter),
    maxRaw: FieldLimits.projectileLengthInch.maxRaw.convert(Unit.inch, Unit.millimeter),
    stepRaw: 0.1,
    accuracy: 1,
  );

  /// FieldLimits.projectileDiameterInch is stored in inch; this picker works in mm.
  static final projectileDiameter = FieldConstraints(
    rawUnit: Unit.millimeter,
    minRaw: FieldLimits.projectileDiameterInch.minRaw.convert(Unit.inch, Unit.millimeter),
    maxRaw: FieldLimits.projectileDiameterInch.maxRaw.convert(Unit.inch, Unit.millimeter),
    stepRaw: 0.1,
    accuracy: 2,
  );

  /// Optical magnification (dimensionless scalar, displayed as "x").
  static final magnification = FieldConstraints(
    rawUnit: Unit.scalar,
    minRaw: FieldLimits.magnification.minRaw,
    maxRaw: FieldLimits.magnification.maxRaw,
    stepRaw: 0.5,
    accuracy: 1,
  );

  static final ballisticCoefficient = FieldConstraints(
    rawUnit: Unit.scalar, // sentinel — dimensionless, no conversion
    minRaw: FieldLimits.ballisticCoefficient.minRaw,
    maxRaw: FieldLimits.ballisticCoefficient.maxRaw,
    stepRaw: 0.001,
    accuracy: 3,
  );

  static final powderSensitivity = FieldConstraints(
    rawUnit: Unit.fraction, // sentinel — no conversion used for sensitivity
    minRaw: FieldLimits.powderSensitivityFrac.minRaw,
    maxRaw: FieldLimits.powderSensitivityFrac.maxRaw, // c_t_coeff max = 5000 ÷ 1000
    stepRaw: 0.001,
    accuracy: 3,
  );

  static final barrelLength = FieldConstraints(
    rawUnit: Unit.inch,
    minRaw: FieldLimits.barrelLengthInch.minRaw,
    maxRaw: FieldLimits.barrelLengthInch.maxRaw,
    stepRaw: 0.5,
    accuracy: 1,
  );

  // Display-only — trajectory output

  /// Bullet height / windage offset (linear). Raw stored in feet.
  static const drop = FieldConstraints(
    rawUnit: Unit.inch,
    minRaw: -1500.0,
    maxRaw: 1500.0,
    stepRaw: 0.1,
    accuracy: 1, // suitable for cm (default unit)
  );

  static const windage = drop;

  /// Scope adjustment angle. Raw stored in radians.
  static const adjustment = FieldConstraints(
    rawUnit: Unit.mil,
    minRaw: -30,
    maxRaw: 30,
    stepRaw: 0.001,
    accuracy: 2, // suitable for MIL / MOA / MRAD (default unit)
  );

  static const velocity = FieldConstraints(
    rawUnit: Unit.mps,
    minRaw: 0.0,
    maxRaw: 3000.0,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static const energy = FieldConstraints(
    rawUnit: Unit.footPound,
    minRaw: 0.0,
    maxRaw: 20000.0,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static final tableRange = FieldConstraints(
    rawUnit: Unit.meter,
    minRaw: FieldLimits.tableRangeMeter.minRaw,
    maxRaw: FieldLimits.tableRangeMeter.maxRaw,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static final distanceStep = FieldConstraints(
    rawUnit: Unit.meter,
    minRaw: FieldLimits.distanceStepMeter.minRaw,
    maxRaw: FieldLimits.distanceStepMeter.maxRaw,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static const convertorLength = FieldConstraints(
    rawUnit: Unit.inch,
    minRaw: 0.0,
    maxRaw: 9999.0,
    stepRaw: 0.1,
    accuracy: 3,
  );

  static const convertorWeight = FieldConstraints(
    rawUnit: Unit.grain,
    minRaw: 0.0,
    maxRaw: 9999.0,
    stepRaw: 0.1,
    accuracy: 1,
  );

  static const convertorPressure = FieldConstraints(
    rawUnit: Unit.hPa,
    minRaw: 300.0,
    maxRaw: 1500.0,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static const torque = FieldConstraints(
    rawUnit: Unit.newtonMeter,
    minRaw: 300.0,
    maxRaw: 1500.0,
    stepRaw: 1.0,
    accuracy: 0,
  );

  static final convertorDistance = FieldConstraints(
    rawUnit: Unit.meter,
    minRaw: FieldLimits.convertorDistanceMeter.minRaw,
    maxRaw: FieldLimits.convertorDistanceMeter.maxRaw,
    stepRaw: 1.0,
    accuracy: 0,
  );
  static final convertorVelocity = FieldConstraints(
    rawUnit: Unit.mps,
    minRaw: FieldLimits.convertorVelocityMps.minRaw,
    maxRaw: FieldLimits.convertorVelocityMps.maxRaw,
    stepRaw: 1.0,
    accuracy: 1,
  );

  static const convertorTorque = torque;
  static const convertorAngular = FieldConstraints(
    rawUnit: Unit.degree,
    minRaw: 0,
    maxRaw: 360,
    stepRaw: 1.0,
    accuracy: 1,
  );

  static final targetSize = FieldConstraints(
    rawUnit: Unit.mil,
    minRaw: FieldLimits.targetSizeMil.minRaw,
    maxRaw: FieldLimits.targetSizeMil.maxRaw,
    stepRaw: 0.1,
    accuracy: 3,
  );

  static final convertorTargetPhysicalSize = FieldConstraints(
    rawUnit: Unit.inch,
    minRaw: FieldLimits.convertorTargetPhysicalSizeInch.minRaw,
    maxRaw: FieldLimits.convertorTargetPhysicalSizeInch.maxRaw,
    stepRaw: 0.1,
    accuracy: 2,
  );
}

abstract final class RC {
  static final targetDistance = RulerConstraints(
    fc: FC.targetDistance,
    tick: 50,
    smallTick: 10,
  );

  static final windSpeed = RulerConstraints(
    fc: FC.windSpeed,
    tick: 0.5,
    smallTick: 0.1,
  );

  static final lookAngle = RulerConstraints(
    fc: FC.lookAngle,
    tick: 5,
    smallTick: 1,
  );

  static final temperature = RulerConstraints(
    fc: FC.temperature,
    tick: 1,
    smallTick: 1,
  );

  static final altitude = RulerConstraints(
    fc: FC.altitude,
    tick: 100,
    smallTick: 20,
  );

  static final pressure = RulerConstraints(
    fc: FC.pressure,
    tick: 1,
    smallTick: 1,
  );

  static final humidity = RulerConstraints(
    fc: FC.humidity,
    tick: 0.01,
    smallTick: 0.01,
  );
}
