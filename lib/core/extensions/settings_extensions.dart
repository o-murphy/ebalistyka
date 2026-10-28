import 'package:ebalistyka/core/extensions/name_lookup.dart';
import 'package:bclibc/unit.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:material_ui/material_ui.dart';

enum AdjustmentDisplayFormat {
  arrows,
  signs,
  letters;

  String elevDir(bool isPos) {
    return switch (this) {
      AdjustmentDisplayFormat.arrows => isPos ? '↑' : '↓',
      AdjustmentDisplayFormat.signs => isPos ? '+' : '−',
      AdjustmentDisplayFormat.letters => isPos ? 'U' : 'D',
    };
  }

  String windDir(bool isPos) {
    return switch (this) {
      AdjustmentDisplayFormat.arrows => isPos ? '→' : '←',
      AdjustmentDisplayFormat.signs => isPos ? '+' : '−',
      AdjustmentDisplayFormat.letters => isPos ? 'R' : 'L',
    };
  }
}

extension GeneralSettingsExtension on GeneralSettings {
  // ── Enum ─────────────────────────────────────────────────────────────────────

  AdjustmentDisplayFormat get adjustmentDisplayFormat =>
      enumByName(AdjustmentDisplayFormat.values, adjustmentDisplayFormatValue, AdjustmentDisplayFormat.arrows);
  set adjustmentDisplayFormat(AdjustmentDisplayFormat v) =>
      adjustmentDisplayFormatValue = v.name;

  ThemeMode get flutterThemeMode => switch (themeMode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system, // '_' replaces 'default'
  };

  set flutterThemeMode(ThemeMode v) => themeMode = switch (v) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}

extension UnitSettingsExtension on UnitSettings {
  Unit get angularUnit => unitNamed(angular, Unit.mil);
  set angularUnit(Unit v) => angular = v.name;

  Unit get distanceUnit => unitNamed(distance, Unit.meter);
  set distanceUnit(Unit v) => distance = v.name;

  Unit get velocityUnit => unitNamed(velocity, Unit.mps);
  set velocityUnit(Unit v) => velocity = v.name;

  Unit get pressureUnit => unitNamed(pressure, Unit.hPa);
  set pressureUnit(Unit v) => pressure = v.name;

  Unit get temperatureUnit => unitNamed(temperature, Unit.celsius);
  set temperatureUnit(Unit v) => temperature = v.name;

  Unit get diameterUnit => unitNamed(diameter, Unit.inch);
  set diameterUnit(Unit v) => diameter = v.name;

  Unit get lengthUnit => unitNamed(length, Unit.inch);
  set lengthUnit(Unit v) => length = v.name;

  Unit get weightUnit => unitNamed(weight, Unit.grain);
  set weightUnit(Unit v) => weight = v.name;

  Unit get dropUnit => unitNamed(drop, Unit.centimeter);
  set dropUnit(Unit v) => drop = v.name;

  Unit get energyUnit => unitNamed(energy, Unit.joule);
  set energyUnit(Unit v) => energy = v.name;

  Unit get targetSizeUnit => unitNamed(targetSize, Unit.mil);
  set targetSizeUnit(Unit v) => targetSize = v.name;
}

extension TablesSettingsExtension on TablesSettings {
  List<Unit> get enabledAdjUnits => [
    if (showMil) Unit.mil,
    if (showMrad) Unit.mRad,
    if (showMoa) Unit.moa,
    if (showCmPer100m) Unit.cmPer100m,
    if (showInPer100yd) Unit.inPer100Yd,
  ];
}

extension UnitSettingsFullExtension on UnitSettings {
  Unit get adjustmentUnit => unitNamed(adjustment, Unit.mil);
  set adjustmentUnit(Unit v) => adjustment = v.name;

  Unit get sightHeightUnit => unitNamed(sightHeight, Unit.millimeter);
  set sightHeightUnit(Unit v) => sightHeight = v.name;

  Unit get twistUnit => unitNamed(twist, Unit.inch);
  set twistUnit(Unit v) => twist = v.name;

  Unit get barrelLengthUnit => unitNamed(barrelLength, Unit.inch);
  set barrelLengthUnit(Unit v) => barrelLength = v.name;

  Unit get torqueUnit => unitNamed(torque, Unit.newtonMeter);
  set torqueUnit(Unit v) => torque = v.name;
}

extension ReticleSettingsExtension on ReticleSettings {
  Unit get verticalAdjustmentUnitValue =>
      unitNamed(verticalAdjustmentUnit, Unit.mil);
  set verticalAdjustmentUnitValue(Unit v) => verticalAdjustmentUnit = v.name;

  Unit get horizontalAdjustmentUnitValue =>
      unitNamed(horizontalAdjustmentUnit, Unit.mil);
  set horizontalAdjustmentUnitValue(Unit v) =>
      horizontalAdjustmentUnit = v.name;

  bool get verticalAdjInClicks => verticalAdjustmentUnit == 'clicks';
  bool get horizontalAdjInClicks => horizontalAdjustmentUnit == 'clicks';
}
