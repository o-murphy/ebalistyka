import 'package:ebc_db/ebc_db.dart';
import 'package:ebalistyka/core/services/ballistics_service.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebalistyka/core/extensions/profile_extensions.dart';
import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/core/extensions/weapon_extensions.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:ebalistyka/core/extensions/ammo_extensions.dart'
    show DragType, AmmoExtension;
import 'package:dart_bclibc_flutter/bclibc.dart';
import 'package:dart_bclibc_flutter/bclibc.dart' as bclibc;

// Web counterpart to ballistics_service_impl.dart — conditionally exported
// in its place (see ballistics_service_impl.dart's own header comment) since
// the native file's `bclibc.Calculator()`/`BCLIBCFFI_TrajFlag` don't exist on
// web at all (see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 9 —
// dart_bclibc's facade stubs them out there). Uses `AsyncCalculator`
// instead, awaited sequentially on the calling isolate — cheap on web
// specifically, since the web engine (a cached, already-loaded wasm module)
// never spawns an isolate per call the way the native engine's
// `Isolate.run`-per-call does; this shape would be a real regression if
// reused on native, which is why the native file stays untouched rather
// than being merged with this one.

class CalculationException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  CalculationException(this.message, [this.originalError, this.stackTrace]);

  @override
  String toString() =>
      'CalculationException: $message${originalError != null ? ' (${originalError.runtimeType}: $originalError)' : ''}';
}

const _rangeAndZeroFlags = 1 | 2; // BCLIBCFFI_TRAJ_FLAG_RANGE | _ZERO

class BallisticsServiceImpl implements BallisticsService {
  List<double>? _lastZeroKey;
  double? _cachedZeroElevRad;

  final _calc = bclibc.AsyncCalculator();

  // Serializes every call into `_calc` — the wasm engine is documented as
  // "stateless/reentrant" for sequential reuse, but that's not the same
  // guarantee as safe *concurrent* invocation, and this service is a single
  // Riverpod-provided instance shared by every screen (Home, Tables, ...).
  // Two screens each triggering their own calculation around app boot could
  // otherwise race two overlapping calls into the same engine — observed
  // as the Tables screen hanging in its loading spinner forever on first
  // launch (but working fine navigated to on its own, e.g. after a hot
  // restart, once nothing else is mid-calculation). Native's `compute()`
  // never had this problem — each call got its own isolate — so this is a
  // web-engine-specific concern the native file doesn't need.
  Future<void> _queue = Future.value();

  Future<T> _serialized<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

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

  bclibc.Weapon _buildWeapon(Profile profile) {
    final weapon = profile.weapon;
    final sight = profile.sight;
    return weapon.toWeapon(sight.sightHeight);
  }

  Future<double> _resolveZeroElevation(
    bclibc.Shot zeroShot,
    Distance zeroDistance,
  ) async {
    try {
      final elev = await _calc.setWeaponZero(zeroShot, zeroDistance);
      return elev.in_(Unit.radian);
    } catch (_) {
      final flatShot = bclibc.Shot(
        weapon: zeroShot.weapon,
        ammo: zeroShot.ammo,
        lookAngle: Angular.radian(0.0),
        atmo: zeroShot.atmo,
        winds: zeroShot.winds,
      );
      final elev = await _calc.setWeaponZero(flatShot, zeroDistance);
      zeroShot.weapon.zeroElevation = flatShot.weapon.zeroElevation;
      return elev.in_(Unit.radian);
    }
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

    return _serialized(() async {
      try {
        double? freshZeroElevRad;
        if (cached != null) {
          currentShot.weapon.zeroElevation = Angular.radian(cached);
          zeroShot.weapon.zeroElevation = Angular.radian(cached);
        } else {
          freshZeroElevRad = await _resolveZeroElevation(
            zeroShot,
            zeroDistance,
          );
          currentShot.weapon.zeroElevation = zeroShot.weapon.zeroElevation;
        }

        final hit = await _calc.fire(
          shot: currentShot,
          trajectoryRange: Distance(FC.targetDistance.maxRaw, Unit.meter),
          trajectoryStep: Distance.meter(opts.stepM),
          filterFlags: _rangeAndZeroFlags,
        );
        final zeroElevRad = freshZeroElevRad ?? cached ?? 0.0;
        if (freshZeroElevRad != null) {
          _updateZeroCache(profile, conditions, freshZeroElevRad);
        }
        return BallisticsResult(hitResult: hit, zeroElevationRad: zeroElevRad);
      } catch (e, st) {
        throw CalculationException('Table calculation failed', e, st);
      }
    });
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
    final tableStepM = opts.tableStepM ?? 0.0;
    final internalStepM = opts.stepM < 0.1524 ? opts.stepM : 0.1524;

    return _serialized(() async {
      try {
        double? freshZeroElevRad;
        if (cached != null) {
          currentShot.weapon.zeroElevation = Angular.radian(cached);
          zeroShot.weapon.zeroElevation = Angular.radian(cached);
        } else {
          freshZeroElevRad = await _resolveZeroElevation(
            zeroShot,
            zeroDistance,
          );
          currentShot.weapon.zeroElevation = zeroShot.weapon.zeroElevation;
        }

        final zeroElevRad = currentShot.weapon.zeroElevation.in_(Unit.radian);

        final tableDists = [
          opts.targetDistM - 2 * tableStepM,
          opts.targetDistM - tableStepM,
          opts.targetDistM,
          opts.targetDistM + tableStepM,
          opts.targetDistM + 2 * tableStepM,
        ];
        final tableHolds = <double>[];
        for (final d in tableDists) {
          if (d <= 0) {
            tableHolds.add(double.nan);
            continue;
          }
          try {
            final elev = await _calc.barrelElevationForTarget(
              currentShot,
              Distance.meter(d),
            );
            tableHolds.add(elev.in_(Unit.radian) - zeroElevRad);
          } catch (_) {
            tableHolds.add(double.nan);
          }
        }

        final holdRad = tableHolds[2].isNaN ? 0.0 : tableHolds[2];
        currentShot.relativeAngle = Angular.radian(holdRad);

        final hit = await _calc.fire(
          shot: currentShot,
          trajectoryRange: Distance.meter(
            opts.trajectoryEndM ?? opts.targetDistM,
          ),
          trajectoryStep: Distance.meter(internalStepM),
          filterFlags: _rangeAndZeroFlags,
        );
        final zeroElevRadOut = freshZeroElevRad ?? cached ?? 0.0;
        if (freshZeroElevRad != null) {
          _updateZeroCache(profile, conditions, freshZeroElevRad);
        }
        return BallisticsResult(
          hitResult: hit,
          zeroElevationRad: zeroElevRadOut,
          holdRad: holdRad,
          tableHolds: tableHolds,
        );
      } catch (e, st) {
        throw CalculationException('Home calculation failed', e, st);
      }
    });
  }
}
