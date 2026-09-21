import 'package:ebc_db/ebc_db.dart';
import 'package:ebalistyka/core/services/ballistics_service.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebalistyka/core/extensions/profile_extensions.dart';
import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/core/extensions/weapon_extensions.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart' show compute, listEquals;
import 'package:ebalistyka/core/extensions/ammo_extensions.dart'
    show DragType, AmmoExtension;
import 'package:bclibc_flutter/unit.dart';
import 'package:bclibc_flutter/bclibc.dart' as bclibc;

// ── Isolate top-level functions ──────────────────────────────────────────────

// (zeroShot, currentShot, zeroDistance, stepM, cachedZeroElevationRad?)
typedef _TableCalcArgs = (bclibc.Shot, bclibc.Shot, Distance, double, double?);
// (hitResult, freshZeroElevationRad?)
typedef _TableCalcResult = (bclibc.HitResult?, double?);

_TableCalcResult _runTableCalculation(_TableCalcArgs args) {
  final (zeroShot, currentShot, zeroDistance, stepM, cachedZeroElevRad) = args;
  try {
    final calc = bclibc.Calculator();
    double? freshZeroElevRad;

    if (cachedZeroElevRad != null) {
      currentShot.weapon.zeroElevation = Angular.radian(cachedZeroElevRad);
      zeroShot.weapon.zeroElevation = Angular.radian(cachedZeroElevRad);
    } else {
      try {
        calc.setWeaponZero(zeroShot, zeroDistance);
      } catch (_) {
        final flatShot = bclibc.Shot(
          weapon: zeroShot.weapon,
          ammo: zeroShot.ammo,
          lookAngle: Angular.radian(0.0),
          atmo: zeroShot.atmo,
          winds: zeroShot.winds,
        );
        calc.setWeaponZero(flatShot, zeroDistance);
        zeroShot.weapon.zeroElevation = flatShot.weapon.zeroElevation;
      }
      freshZeroElevRad = zeroShot.weapon.zeroElevation.in_(Unit.radian);
      currentShot.weapon.zeroElevation = zeroShot.weapon.zeroElevation;
    }

    final result = calc.fire(
      shot: currentShot,
      trajectoryRange: Distance(FC.targetDistance.maxRaw, Unit.meter),
      trajectoryStep: Distance.meter(stepM),
      filterFlags:
          bclibc.BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_RANGE.value |
          bclibc.BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_ZERO.value,
    );
    return (result, freshZeroElevRad);
  } catch (e, st) {
    throw CalculationException('Table calculation failed', e, st);
  }
}

// (zeroShot, currentShot, zeroDistance, targetDistM, trajectoryEndM, chartStepM, tableStepM, cachedZeroElevationRad?)
typedef _HomeCalcArgs = (
  bclibc.Shot,
  bclibc.Shot,
  Distance,
  double,
  double,
  double,
  double,
  double?,
);
// (hitResult, freshZeroElevationRad?, holdRad, windageRad, tableHolds, tableWindages)
typedef _HomeCalcResult = (
  bclibc.HitResult?,
  double?,
  double,
  double,
  List<double>,
  List<double>,
);

_HomeCalcResult _runHomeCalculation(_HomeCalcArgs args) {
  final (
    zeroShot,
    currentShot,
    zeroDistance,
    targetDistM,
    trajectoryEndM,
    stepM,
    tableStepM,
    cachedZeroElevRad,
  ) = args;
  final internalStepM = stepM < 0.1524
      ? stepM
      : 0.1524; // max 1/2 ft for dense interpolation
  try {
    final calc = bclibc.Calculator();
    double? freshZeroElevRad;

    if (cachedZeroElevRad != null) {
      currentShot.weapon.zeroElevation = Angular.radian(cachedZeroElevRad);
      zeroShot.weapon.zeroElevation = Angular.radian(cachedZeroElevRad);
    } else {
      try {
        calc.setWeaponZero(zeroShot, zeroDistance);
      } catch (_) {
        final flatShot = bclibc.Shot(
          weapon: zeroShot.weapon,
          ammo: zeroShot.ammo,
          lookAngle: Angular.radian(0.0),
          atmo: zeroShot.atmo,
          winds: zeroShot.winds,
        );
        calc.setWeaponZero(flatShot, zeroDistance);
        zeroShot.weapon.zeroElevation = flatShot.weapon.zeroElevation;
      }
      freshZeroElevRad = zeroShot.weapon.zeroElevation.in_(Unit.radian);
      currentShot.weapon.zeroElevation = zeroShot.weapon.zeroElevation;
    }

    // Aiming solution (vertical hold + windage) for each table column, taken
    // from the native zero-point solve rather than the fired trajectory.
    final tableDists = [
      targetDistM - 2 * tableStepM,
      targetDistM - tableStepM,
      targetDistM,
      targetDistM + tableStepM,
      targetDistM + 2 * tableStepM,
    ];
    final tableHolds = <double>[];
    final tableWindages = <double>[];
    for (final d in tableDists) {
      if (d <= 0) {
        tableHolds.add(double.nan);
        tableWindages.add(double.nan);
        continue;
      }
      // The native solver can fail to converge for some distances without
      // that being predictable from `d` alone — catch it per-column into NaN
      // instead of aborting the whole calculation (and, via that, the whole
      // home screen).
      try {
        final (hold, windage, _) = calc.aimingSolutionForTarget(
          currentShot,
          Distance.meter(d),
        );
        tableHolds.add(hold.in_(Unit.radian));
        tableWindages.add(windage.in_(Unit.radian));
      } catch (e) {
        debugPrint('aimingSolutionForTarget($d m) failed: $e');
        tableHolds.add(double.nan);
        tableWindages.add(double.nan);
      }
    }

    // Hold/windage for the target — same as the center column.
    final holdRad = tableHolds[2].isNaN ? 0.0 : tableHolds[2];
    final windageRad = tableWindages[2].isNaN ? 0.0 : tableWindages[2];
    currentShot.relativeAngle = Angular.radian(holdRad);

    final result = calc.fire(
      shot: currentShot,
      trajectoryRange: Distance.meter(trajectoryEndM),
      trajectoryStep: Distance.meter(internalStepM),
      filterFlags:
          bclibc.BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_RANGE.value |
          bclibc.BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_ZERO.value,
    );
    return (
      result,
      freshZeroElevRad,
      holdRad,
      windageRad,
      tableHolds,
      tableWindages,
    );
  } catch (e, st) {
    debugPrint(e.toString());
    debugPrintStack(stackTrace: st);
    throw CalculationException('Home calculation failed', e, st);
  }
}

// ── Exception ────────────────────────────────────────────────────────────────

class CalculationException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  CalculationException(this.message, [this.originalError, this.stackTrace]);

  @override
  String toString() =>
      'CalculationException: $message${originalError != null ? ' (${originalError.runtimeType}: $originalError)' : ''}';
}

// ── Implementation ───────────────────────────────────────────────────────────

class BallisticsServiceImpl implements BallisticsService {
  List<double>? _lastZeroKey;
  double? _cachedZeroElevRad;

  List<double> _buildZeroKey(Profile profile, ShootingConditions conditions) {
    final ammo = profile.ammo;
    final weapon = profile.weapon;
    final sight = profile.sight;

    final bcCount = switch (ammo.dragType) {
      DragType.g7 => ammo.isMultiBC ? ammo.multiBcTableG7.length : 1,
      DragType.g1 => ammo.isMultiBC ? ammo.multiBcTableG1.length : 1,
      DragType.custom => ammo.customDragTable.length,
    };
    final firstBc = switch (ammo.dragType) {
      DragType.g7 => ammo.bcG7,
      DragType.g1 => ammo.bcG1,
      DragType.custom => 0.0,
    };

    return [
      sight.sightHeightInch,
      weapon.twistInch,
      ammo.muzzleVelocityMps,
      ammo.powderSensitivityFrac,
      firstBc,
      ammo.weightGrain,
      ammo.caliberInch,
      ammo.lengthInch,
      bcCount.toDouble(),
      ammo.zero.altitudeMeter,
      ammo.zero.pressureHPa,
      ammo.zero.temperatureC,
      ammo.zero.humidityFrac,
      ammo.zero.powderTemperatureC,
      ammo.zero.distanceMeter,
      conditions.lookAngleRad,
      ammo.usePowderSensitivity ? 1.0 : 0.0,
      ammo.zeroUseDiffPowderTemperature ? 1.0 : 0.0,
    ];
  }

  double? _resolveZeroCache(Profile profile, ShootingConditions conditions) {
    final key = _buildZeroKey(profile, conditions);
    if (_cachedZeroElevRad != null && listEquals(key, _lastZeroKey)) {
      return _cachedZeroElevRad;
    }
    return null;
  }

  void _updateZeroCache(
    Profile profile,
    ShootingConditions conditions,
    double zeroElevRad,
  ) {
    _lastZeroKey = _buildZeroKey(profile, conditions);
    _cachedZeroElevRad = zeroElevRad;
  }

  /// Builds bclibc.Weapon from the profile's embedded weapon/sight.
  bclibc.Weapon _buildWeapon(Profile profile) {
    final weapon = profile.weapon;
    final sight = profile.sight;
    return weapon.toWeapon(sight.sightHeight);
  }

  @override
  Future<BallisticsResult> calculateTable(
    Profile profile,
    ShootingConditions conditions,
    TableCalcOptions opts,
  ) async {
    final cached = _resolveZeroCache(profile, conditions);
    final bcWeapon = _buildWeapon(profile);
    final zeroShot = profile.toZeroShot(bcWeapon, conditions.lookAngle);
    final currentShot = profile.toCurrentShot(conditions, bcWeapon);
    final zeroDistance = Distance.meter(profile.ammo.zero.distanceMeter);

    final (hit, freshZero) = await compute(_runTableCalculation, (
      zeroShot,
      currentShot,
      zeroDistance,
      opts.stepM,
      cached,
    ));
    if (hit == null) throw StateError('Table calculation returned null');
    final zeroElevRad = freshZero ?? cached ?? 0.0;
    if (freshZero != null) _updateZeroCache(profile, conditions, freshZero);
    return BallisticsResult(hitResult: hit, zeroElevationRad: zeroElevRad);
  }

  @override
  Future<BallisticsResult> calculateForTarget(
    Profile profile,
    ShootingConditions conditions,
    TargetCalcOptions opts,
  ) async {
    final cached = _resolveZeroCache(profile, conditions);
    final bcWeapon = _buildWeapon(profile);
    final zeroShot = profile.toZeroShot(bcWeapon, conditions.lookAngle);
    final currentShot = profile.toCurrentShot(conditions, bcWeapon);
    final zeroDistance = Distance.meter(profile.ammo.zero.distanceMeter);

    final (
      hit,
      freshZero,
      holdRad,
      windageRad,
      tableHolds,
      tableWindages,
    ) = await compute<_HomeCalcArgs, _HomeCalcResult>(_runHomeCalculation, (
      zeroShot,
      currentShot,
      zeroDistance,
      opts.targetDistM,
      opts.trajectoryEndM ?? opts.targetDistM,
      opts.stepM,
      opts.tableStepM ?? 0.0,
      cached,
    ));
    if (hit == null) throw StateError('Target calculation returned null');
    final zeroElevRad = freshZero ?? cached ?? 0.0;
    if (freshZero != null) _updateZeroCache(profile, conditions, freshZero);
    return BallisticsResult(
      hitResult: hit,
      zeroElevationRad: zeroElevRad,
      holdRad: holdRad,
      windageRad: windageRad,
      tableHolds: tableHolds,
      tableWindages: tableWindages,
    );
  }
}
