import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/extensions/num_extensions.dart';
import 'package:ebalistyka/core/extensions/unit_label_extensions.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/constants/null_string.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:ebalistyka/core/extensions/settings_extensions.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:ebalistyka/core/formatting/unit_formatter.dart';

class UnitFormatterImpl implements UnitFormatter {
  final UnitSettings _u;
  final AppLocalizations _l10n;

  UnitFormatterImpl(this._u, this._l10n);

  String _fmt(
    Dimension? dim,
    FieldConstraints fc,
    Unit unit, [
    bool Function(Dimension)? condition,
  ]) {
    if (dim == null || condition?.call(dim) == false) return nullStr;
    final accuracy = fc.accuracyFor(unit);
    return '${dim.in_(unit).toFixedSafe(accuracy)} ${unit.localizedSymbol(_l10n)}';
  }

  // --- Formatted strings ---

  @override
  String velocity(Velocity? dim) =>
      _fmt(dim, FC.velocity, _u.velocityUnit, (dim) => dim.raw > 0.0);

  @override
  String distance(Distance? dim) =>
      _fmt(dim, FC.targetDistance, _u.distanceUnit);

  @override
  String temperature(Temperature dim) =>
      _fmt(dim, FC.temperature, _u.temperatureUnit);

  @override
  String pressure(Pressure dim) => _fmt(dim, FC.pressure, _u.pressureUnit);

  @override
  String drop(Distance? dim) => _fmt(dim, FC.drop, _u.dropUnit);

  @override
  String windage(Distance dim) => drop(dim);

  @override
  String adjustment(Angular dim) => _fmt(dim, FC.adjustment, _u.adjustmentUnit);

  @override
  String energy(Energy? dim) => _fmt(dim, FC.energy, _u.energyUnit);

  @override
  String weight(Weight? dim) =>
      _fmt(dim, FC.projectileWeight, _u.weightUnit, (dim) => dim.raw > 0.0);

  @override
  String length(Distance? dim) =>
      _fmt(dim, FC.projectileLength, _u.lengthUnit, (dim) => dim.raw > 0.0);

  @override
  String diameter(Distance? dim) =>
      _fmt(dim, FC.projectileDiameter, _u.diameterUnit, (dim) => dim.raw > 0.0);

  @override
  String sightHeight(Distance? dim) =>
      _fmt(dim, FC.sightHeight, _u.sightHeightUnit);

  @override
  String twist(Distance? dim) => '1:${_fmt(dim, FC.twist, _u.twistUnit)}';

  @override
  String barrelLength(Distance dim) =>
      _fmt(dim, FC.barrelLength, _u.barrelLengthUnit);

  @override
  String humidity(Ratio dim) => _fmt(dim, FC.humidity, Unit.percent);

  @override
  String mach(double m) => '${m.toFixedSafe(2)} ${_l10n.unitMachSym}';

  @override
  String time(double seconds) =>
      '${seconds.toFixedSafe(3)} ${_l10n.unitSecondSym}';

  @override
  String powderSensitivity(Ratio dim) {
    final accuracy = FC.powderSensitivity.accuracyFor(Unit.percent);
    return '${dim.in_(Unit.percent).toFixedSafe(accuracy)} ${_l10n.powderSensUnit}';
  }

  @override
  String torque(Torque dim) => _fmt(dim, FC.torque, _u.torqueUnit);

  @override
  String targetSize(Angular dim) =>
      _fmt(dim, FC.targetSize, _u.targetSizeUnit, (dim) => dim.raw >= 0.0);

  @override
  String windSpeed(Velocity dim) => _fmt(dim, FC.windSpeed, _u.velocityUnit);

  @override
  String windDirection(Angular dim) => _fmt(dim, FC.windDirection, Unit.degree);

  @override
  String magnificationRange(double? min, double? max) =>
      "${min?.toFixedSafe(0) ?? "?"}-${max?.toFixedSafe(0) ?? "?"}x";

  @override
  String click(double? value, Unit? unit) => value == null || unit == null
      ? nullStr
      : adjustment(Angular(value, unit));
  // --- Symbols ---

  @override
  String get velocitySymbol => _u.velocityUnit.localizedSymbol(_l10n);
  @override
  String get distanceSymbol => _u.distanceUnit.localizedSymbol(_l10n);
  @override
  String get temperatureSymbol => _u.temperatureUnit.localizedSymbol(_l10n);
  @override
  String get pressureSymbol => _u.pressureUnit.localizedSymbol(_l10n);
  @override
  String get dropSymbol => _u.dropUnit.localizedSymbol(_l10n);
  @override
  String get adjustmentSymbol => _u.adjustmentUnit.localizedSymbol(_l10n);
  @override
  String get energySymbol => _u.energyUnit.localizedSymbol(_l10n);
  @override
  String get weightSymbol => _u.weightUnit.localizedSymbol(_l10n);
  @override
  String get sightHeightSymbol => _u.sightHeightUnit.localizedSymbol(_l10n);
  @override
  String get barrelLengthSymbol => _u.barrelLengthUnit.localizedSymbol(_l10n);

  // --- Input conversion (for input dialogs) ---

  /// Display unit (from the settings) and raw unit of a field. Humidity,
  /// look angle and BC are not converted by unit — see [inputToRaw].
  (Unit display, Unit raw) _unitsOf(InputField field) => switch (field) {
    InputField.velocity || InputField.windVelocity => (
      _u.velocityUnit,
      Unit.mps,
    ),
    InputField.distance ||
    InputField.targetDistance ||
    InputField.zeroDistance => (_u.distanceUnit, Unit.meter),
    InputField.temperature => (_u.temperatureUnit, Unit.celsius),
    InputField.pressure => (_u.pressureUnit, Unit.hPa),
    InputField.sightHeight => (_u.sightHeightUnit, Unit.millimeter),
    InputField.twist => (_u.twistUnit, Unit.inch),
    InputField.bulletWeight => (_u.weightUnit, Unit.grain),
    InputField.bulletLength => (_u.lengthUnit, Unit.millimeter),
    InputField.bulletDiameter => (_u.diameterUnit, Unit.millimeter),
    InputField.barrelLength => (_u.barrelLengthUnit, Unit.inch),
    InputField.torque => (_u.torqueUnit, Unit.newtonMeter),
    InputField.humidity ||
    InputField.lookAngle ||
    InputField.bc => throw ArgumentError('$field has no unit conversion'),
  };

  @override
  double inputToRaw(double displayValue, InputField field) => switch (field) {
    InputField.humidity => displayValue / 100.0,
    InputField.lookAngle || InputField.bc => displayValue,
    _ => _convertField(displayValue, field, toRaw: true),
  };

  @override
  double rawToInput(double rawValue, InputField field) => switch (field) {
    InputField.humidity => rawValue * 100.0,
    InputField.lookAngle || InputField.bc => rawValue,
    _ => _convertField(rawValue, field, toRaw: false),
  };

  double _convertField(double value, InputField field, {required bool toRaw}) {
    final (display, raw) = _unitsOf(field);
    return toRaw ? value.convert(display, raw) : value.convert(raw, display);
  }
}
