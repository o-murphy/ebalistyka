// Calculator — Dart port of the TypeScript Calculator class.
//
// Wraps BcLibC (FFI layer) with the same API surface as the WASM Calculator:
//   barrelElevationForTarget, setWeaponZero, fire
//
// Usage:
//   final calc = Calculator();
//   final elev = calc.barrelElevationForTarget(shot, Distance.meter(1000));
//   calc.setWeaponZero(shot, Distance.meter(100));
//   final result = calc.fire(shot: shot, trajectoryRange: Distance.meter(1000));

import 'package:bclibc_ffi/ffi/bclibc_bindings.g.dart';
import 'package:bclibc_ffi/ffi/bclibc_ffi.dart';
import 'package:bclibc_ffi/src/conditions.dart';
import 'package:bclibc_ffi/src/constants.dart';
import 'package:bclibc_ffi/src/shot.dart';
import 'package:bclibc_ffi/src/trajectory_data.dart';
import 'package:bclibc_ffi/src/unit.dart';

// ---------------------------------------------------------------------------
// Default config constants (mirror TS DEFAULT_CONFIG)
// ---------------------------------------------------------------------------

const double cZeroFindingAccuracy = 0.000005;
const int cMaxIterations = 40;
const double cMinimumAltitude = -1500.0;
const double cMaximumDrop = -10000.0;
const double cMinimumVelocity = 50.0;
const double cGravityConstant = -BallisticConstants.cGravityImperial;
const double cStepMultiplier = 1.0;

const BcConfig defaultConfig = BcConfig(
  zeroFindingAccuracy: cZeroFindingAccuracy,
  maxIterations: cMaxIterations,
  minimumAltitude: cMinimumAltitude,
  maximumDrop: cMaximumDrop,
  minimumVelocity: cMinimumVelocity,
  gravityConstant: cGravityConstant,
  stepMultiplier: cStepMultiplier,
);

// ---------------------------------------------------------------------------
// Calculator
// ---------------------------------------------------------------------------

class Calculator {
  final BCLIBCFFI_IntegrationMethod method;
  final BcConfig config;

  late final BcLibC _engine;

  Calculator({
    this.method = BCLIBCFFI_IntegrationMethod.BCLIBCFFI_INTEGRATION_RK4,
    BcConfig? config,
  }) : config = config ?? defaultConfig {
    _engine = BcLibC.open();
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Returns the barrel elevation (relative to look-angle) needed to hit
  /// a target at [targetDistance].
  Angular barrelElevationForTarget(Shot shot, Distance targetDistance) {
    final distFt = _toFeet(targetDistance);
    final bcShot = _toBcShot(shot);
    final totalRad = _engine.findZeroAngleShot(bcShot, distFt);
    return Angular(totalRad - shot.lookAngle.in_(Unit.radian), Unit.radian);
  }

  /// Zeros the weapon by storing the required barrel elevation in
  /// [Weapon.zeroElevation] and resetting [shot.relativeAngle] to zero.
  ///
  /// Any subsequent [Shot] that uses the same [Weapon] instance will
  /// automatically inherit the zero elevation, matching the JS-library
  /// behaviour where `weapon.zeroElevation` is mutable.
  Angular setWeaponZero(Shot shot, Distance zeroDistance) {
    final elev = barrelElevationForTarget(shot, zeroDistance);
    shot.weapon.zeroElevation = elev;
    shot.relativeAngle = Angular.radian(0);
    return elev;
  }

  /// Fires a shot and returns the full trajectory as a [HitResult].
  ///
  /// [trajectoryRange] and [trajectoryStep] accept a [Distance] object or
  /// a raw number in the preferred distance unit.
  HitResult fire({
    required Shot shot,
    required Distance trajectoryRange,
    Distance? trajectoryStep,
    double timeStep = 0.0,
    int filterFlags = 8, // BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_RANGE
    bool raiseRangeError = true,
  }) {
    final rangeFt = _toFeet(trajectoryRange);
    final stepFt = trajectoryStep != null ? _toFeet(trajectoryStep) : rangeFt;

    final request = BcTrajectoryRequest(
      rangeLimitFt: rangeFt,
      rangeStepFt: stepFt,
      timeStep: timeStep,
      filterFlags: filterFlags,
    );

    late BcHitResult bcResult;
    try {
      bcResult = _engine.integrateShot(_toBcShot(shot), request);
    } on BcException catch (e) {
      if (raiseRangeError) rethrow;
      return HitResult(shot, [], filterFlags: filterFlags, error: e);
    }

    final traj = bcResult.trajectory.map(_toTrajectoryData).toList();
    return HitResult(shot, traj, filterFlags: filterFlags);
  }

  // ── Conversion helpers ─────────────────────────────────────────────────────

  static double _toFeet(Distance d) => d.in_(Unit.foot);

  /// Thin field mapper: copies [Shot] fields into [BcShot].
  /// All physics/unit conversions (atmosphere density, Coriolis trig,
  /// PCHIP drag curve, cant sin/cos) are performed inside C++ via
  /// BCLIBC_Shot::to_shot_props().
  BcShot _toBcShot(Shot shot) {
    final mvFps = shot.ammo
        .getVelocityForTemp(shot.atmo.powderTemp)
        .in_(Unit.fps);

    return BcShot(
      bc: shot.ammo.dm.bc,
      weightGrain: shot.ammo.dm.weight.in_(Unit.grain),
      diameterInch: shot.ammo.dm.diameter.in_(Unit.inch),
      lengthInch: shot.ammo.dm.length.in_(Unit.inch),
      muzzleVelocityFps: mvFps,
      sightHeightFt: shot.weapon.sightHeight.in_(Unit.foot),
      twistInch: shot.weapon.twist.in_(Unit.inch),
      tempC: shot.atmo.temperature.in_(Unit.celsius),
      pressureHpa: shot.atmo.pressure.in_(Unit.hPa),
      altitudeFt: shot.atmo.altitude.in_(Unit.foot),
      humidity: shot.atmo.humidity,
      dragTable: shot.ammo.dm.dragTable
          .map((p) => BcDragPoint(p.mach, p.cd))
          .toList(),
      winds: shot.winds.map(_toWind).toList(),
      lookAngleRad: shot.lookAngle.in_(Unit.radian),
      barrelElevationRad: shot.barrelElevation.in_(Unit.radian),
      barrelAzimuthRad: shot.barrelAzimuth.in_(Unit.radian),
      cantAngleRad: shot.cantAngle.in_(Unit.radian),
      latitudeDeg: shot.latitudeDeg ?? double.nan,
      azimuthDeg: shot.azimuthDeg ?? double.nan,
      config: config,
      method: method,
    );
  }

  static BcWind _toWind(Wind w) => BcWind(
    velocityFps: w.velocity.in_(Unit.fps),
    directionFromRad: w.directionFrom.in_(Unit.radian),
    untilDistanceFt: w.untilDistance.in_(Unit.foot),
    maxDistanceFt: Wind.maxDistanceFeet,
  );

  // ── Result conversion ──────────────────────────────────────────────────────

  static TrajectoryData _toTrajectoryData(BcTrajectoryData d) => TrajectoryData(
    time: d.time,
    distance: Distance(d.distanceFt, Unit.foot),
    velocity: Velocity(d.velocityFps, Unit.fps),
    mach: d.mach,
    height: Distance(d.heightFt, Unit.foot),
    slantHeight: Distance(d.slantHeightFt, Unit.foot),
    dropAngle: Angular(d.dropAngleRad, Unit.radian),
    windage: Distance(d.windageFt, Unit.foot),
    windageAngle: Angular(d.windageAngleRad, Unit.radian),
    slantDistance: Distance(d.slantDistanceFt, Unit.foot),
    angle: Angular(d.angleRad, Unit.radian),
    densityRatio: d.densityRatio,
    drag: d.drag,
    energy: Energy(d.energyFtLb, Unit.footPound),
    ogw: Weight(d.ogwLb, Unit.pound),
    flag: d.flag,
  );
}
