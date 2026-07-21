import 'package:dart_bclibc/bclibc.dart' as bclibc;
import 'package:dart_bclibc/unit.dart';
import 'package:ebc_db/ebc_db.dart';

enum DragType { g1, g7, custom }

extension AmmoExtension on Ammo {
  // ── Enum ─────────────────────────────────────────────────────────────────────

  DragType get dragType => DragType.values.firstWhere(
    (e) => e.name == dragTypeValue,
    orElse: () => DragType.g1,
  );
  set dragType(DragType v) => dragTypeValue = v.name;

  // ── Physical unit getters/setters ────────────────────────────────────────────

  Distance? get caliber => hasCaliberInch() ? Distance.inch(caliberInch) : null;
  set caliber(Distance? value) {
    if (value == null) {
      clearCaliberInch();
    } else {
      caliberInch = value.in_(Unit.inch);
    }
  }

  Distance? get length => hasLengthInch() ? Distance.inch(lengthInch) : null;
  set length(Distance? value) {
    if (value == null) {
      clearLengthInch();
    } else {
      lengthInch = value.in_(Unit.inch);
    }
  }

  Weight? get weight => hasWeightGrain() ? Weight.grain(weightGrain) : null;
  set weight(Weight? value) {
    if (value == null) {
      clearWeightGrain();
    } else {
      weightGrain = value.in_(Unit.grain);
    }
  }

  Velocity? get mv =>
      hasMuzzleVelocityMps() ? Velocity.mps(muzzleVelocityMps) : null;
  set mv(Velocity? value) {
    if (value == null) {
      clearMuzzleVelocityMps();
    } else {
      muzzleVelocityMps = value.in_(Unit.mps);
    }
  }

  Temperature get mvTemperature =>
      Temperature.celsius(muzzleVelocityTemperatureC);
  set mvTemperature(Temperature t) =>
      muzzleVelocityTemperatureC = t.in_(Unit.celsius);

  double? get bc1 => hasBcG1() ? bcG1 : null;
  set bc1(double? value) {
    if (value == null) {
      clearBcG1();
    } else {
      bcG1 = value;
    }
  }

  double? get bc7 => hasBcG7() ? bcG7 : null;
  set bc7(double? value) {
    if (value == null) {
      clearBcG7();
    } else {
      bcG7 = value;
    }
  }

  Ratio get powderSensitivity => Ratio.fraction(powderSensitivityFrac);
  set powderSensitivity(Ratio v) =>
      powderSensitivityFrac = v.in_(Unit.fraction);

  // ── Zero conditions ──────────────────────────────────────────────────────────

  Distance get zeroDistance => Distance.meter(zero.distanceMeter);
  set zeroDistance(Distance v) => ensureZero().distanceMeter = v.in_(Unit.meter);

  Angular get zeroLookAngle => Angular.radian(zero.lookAngleRad);
  set zeroLookAngle(Angular v) =>
      ensureZero().lookAngleRad = v.in_(Unit.radian);

  Distance get zeroAltitude => Distance.meter(zero.altitudeMeter);
  set zeroAltitude(Distance v) =>
      ensureZero().altitudeMeter = v.in_(Unit.meter);

  Temperature get zeroTemperature => Temperature.celsius(
    zero.hasTemperatureC() && zero.temperatureC != 0 ? zero.temperatureC : 15.0,
  );
  set zeroTemperature(Temperature v) =>
      ensureZero().temperatureC = v.in_(Unit.celsius);

  Pressure get zeroPressure => Pressure.hPa(
    zero.hasPressureHPa() && zero.pressureHPa != 0 ? zero.pressureHPa : 1013.25,
  );
  set zeroPressure(Pressure v) => ensureZero().pressureHPa = v.in_(Unit.hPa);

  Ratio get zeroHumidity => Ratio.fraction(zero.humidityFrac);
  set zeroHumidity(Ratio v) =>
      ensureZero().humidityFrac = v.in_(Unit.fraction);

  bool get zeroUseDiffPowderTemperature => zero.useDiffPowderTemperature;
  set zeroUseDiffPowderTemperature(bool v) =>
      ensureZero().useDiffPowderTemperature = v;

  bool get zeroUseCoriolis => zero.useCoriolis;
  set zeroUseCoriolis(bool v) => ensureZero().useCoriolis = v;

  Temperature get zeroPowderTemp => Temperature.celsius(zero.powderTemperatureC);
  set zeroPowderTemp(Temperature v) =>
      ensureZero().powderTemperatureC = v.in_(Unit.celsius);

  Angular get zeroLatitude => Angular.degree(zero.latitudeDeg);
  set zeroLatitude(Angular v) => ensureZero().latitudeDeg = v.in_(Unit.degree);

  // See conditions_extensions.dart's windDirection/azimuth setters for why
  // this re-normalizes into [0,360) instead of using v.in_(Unit.degree)
  // directly — Angular's raw form is always (-180,180], so a bearing past
  // 180° would otherwise come back negative and get clamped to 0 by
  // FieldLimits.azimuthDeg's [0,360] clamp instead of wrapping correctly.
  Angular get zeroAzimuth => Angular.degree(zero.azimuthDeg);
  set zeroAzimuth(Angular v) =>
      ensureZero().azimuthDeg = ((v.in_(Unit.degree) % 360) + 360) % 360;

  Unit get zeroOffsetXUnitValue => Unit.values.firstWhere(
    (u) => u.name == zero.offsetXUnit,
    orElse: () => Unit.mil,
  );
  set zeroOffsetXUnitValue(Unit v) => ensureZero().offsetXUnit = v.name;

  Unit get zeroOffsetYUnitValue => Unit.values.firstWhere(
    (u) => u.name == zero.offsetYUnit,
    orElse: () => Unit.mil,
  );
  set zeroOffsetYUnitValue(Unit v) => ensureZero().offsetYUnit = v.name;

  // ── Drag model helpers ────────────────────────────────────────────────────────

  /// True when G1/G7 with multiple BC breakpoints (velocity-dependent BC).
  bool get isMultiBC => switch (dragType) {
    DragType.g1 => useMultiBcG1 && multiBcTableG1.isNotEmpty,
    DragType.g7 => useMultiBcG7 && multiBcTableG7.isNotEmpty,
    DragType.custom => false,
  };

  bool get isReadyForCalculation {
    if (!hasMuzzleVelocityMps() || muzzleVelocityMps <= 0) return false;
    if (!hasCaliberInch() || caliberInch <= 0) return false;
    if (!hasWeightGrain() || weightGrain <= 0) return false;
    if (!hasLengthInch() || lengthInch <= 0) return false;
    switch (dragType) {
      case DragType.g1:
        if (!useMultiBcG1 && (bc1 == null || bc1! <= 0)) return false;
      case DragType.g7:
        if (!useMultiBcG7 && (bc7 == null || bc7! <= 0)) return false;
      case DragType.custom:
        break;
    }
    return true;
  }

  bclibc.DragModel toDragModel() {
    switch (dragType) {
      case DragType.g1:
      case DragType.g7:
        final baseTable = dragType == DragType.g7
            ? bclibc.tableG7
            : bclibc.tableG1;
        final bc = (dragType == DragType.g7 ? bc7 : bc1) ?? 0.0;

        if (isMultiBC) {
          final points = dragType == DragType.g7
              ? multiBcTableG7
              : multiBcTableG1;
          final bcPoints = points
              .map((p) => bclibc.BCPoint(bc: p.bc, v: Velocity(p.vMps, Unit.mps)))
              .toList();
          return bclibc.createDragModelMultiBC(
            bcPoints: bcPoints,
            dragTable: baseTable,
            weight: weight ?? Weight.grain(0),
            diameter: caliber ?? Distance.inch(0),
            length: length ?? Distance.inch(0),
          );
        }

        return bclibc.DragModel(
          bc: bc > 0 ? bc : 1.0,
          dragTable: baseTable,
          weight: weight ?? Weight.grain(0),
          diameter: caliber ?? Distance.inch(0),
          length: length ?? Distance.inch(0),
        );

      case DragType.custom:
        final mach = customDragTableMach;
        final cd = customDragTableCd;
        final table = List.generate(
          mach.length,
          (i) => (mach: mach[i], cd: cd[i]),
        );
        final sd = (hasWeightGrain() && weightGrain > 0 && hasCaliberInch() && caliberInch > 0)
            ? bclibc.calculateSectionalDensity(weightGrain, caliberInch)
            : 0.0;
        return bclibc.DragModel(
          bc: sd > 0 ? sd : 1.0,
          dragTable: table.isNotEmpty ? table : bclibc.tableG1,
          weight: weight ?? Weight.grain(0),
          diameter: caliber ?? Distance.inch(0),
          length: length ?? Distance.inch(0),
        );
    }
  }

  bclibc.Ammo toZeroAmmo() => bclibc.Ammo(
    dm: toDragModel(),
    mv: mv,
    powderTemp: mvTemperature,
    tempModifier: powderSensitivityFrac,
    usePowderSensitivity: usePowderSensitivity,
  );

  bclibc.Ammo toCurrentAmmo(ShootingConditions cond) => bclibc.Ammo(
    dm: toDragModel(),
    mv: mv,
    powderTemp: mvTemperature,
    tempModifier: powderSensitivityFrac,
    usePowderSensitivity: cond.usePowderSensitivity,
  );

  bclibc.Atmo toZeroAtmo() => bclibc.Atmo(
    altitude: zeroAltitude,
    pressure: zeroPressure,
    temperature: zeroTemperature,
    humidity: zero.humidityFrac,
    powderTemperature: zeroUseDiffPowderTemperature
        ? zeroPowderTemp
        : zeroTemperature,
  );
}
