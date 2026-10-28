import 'dart:async';

import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:ebalistyka/core/extensions/unit_label_extensions.dart';
import 'package:ebalistyka/core/providers/convertors_notifier.dart';
import 'package:ebalistyka/core/providers/settings_provider.dart';
import 'package:ebalistyka/features/convertors/generic_convertor_vm_field.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ebalistyka/core/extensions/num_extensions.dart';

class ConvertorSection {
  final String Function(AppLocalizations) titleBuilder;
  final List<GenericConvertorField> fields;

  const ConvertorSection(this.titleBuilder, this.fields);
}

class SimpleConvertorUiState {
  final List<ConvertorSection> sections;
  final double rawValue;
  final Unit inputUnit;

  const SimpleConvertorUiState({
    required this.sections,
    required this.rawValue,
    required this.inputUnit,
  });
}

/// One unit row of a convertor section.
class ConvertorUnit {
  const ConvertorUnit(this.unit, this.label);

  final Unit unit;
  final String Function(AppLocalizations) label;
}

class ConvertorSectionSpec {
  const ConvertorSectionSpec(this.title, this.units);

  final String Function(AppLocalizations) title;
  final List<ConvertorUnit> units;
}

/// Everything that makes one simple convertor (length, weight, pressure,
/// temperature, torque) different from another; [SimpleConvertorVm] and
/// [SimpleConvertorScreen] do the rest.
class SimpleConvertorSpec {
  const SimpleConvertorSpec({
    required this.title,
    required this.hint,
    required this.baseUnit,
    required this.unitOptions,
    required this.sections,
    required this.rawBase,
    required this.inputUnit,
    required this.saveRawBase,
    required this.saveInputUnit,
    required this.constraintsFor,
  });

  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) hint;

  /// The unit the value is stored in.
  final Unit baseUnit;

  /// Units offered by the input's unit picker.
  final List<Unit> unitOptions;

  /// The read-only conversions shown under the input.
  final List<ConvertorSectionSpec> sections;

  final double Function(ConvertorsState s) rawBase;
  final Unit Function(ConvertorsState s) inputUnit;
  final Future<void> Function(ConvertorsNotifier n, double? base) saveRawBase;
  final Future<void> Function(ConvertorsNotifier n, Unit unit) saveInputUnit;

  /// Input range in the chosen unit; its accuracy is also the number of
  /// decimals shown for that unit in [sections].
  final FieldConstraints Function(Unit unit) constraintsFor;
}

class SimpleConvertorVm extends Notifier<SimpleConvertorUiState> {
  SimpleConvertorVm(this.spec);

  final SimpleConvertorSpec spec;

  FieldConstraints getConstraintsForUnit(Unit unit) =>
      spec.constraintsFor(unit);

  @override
  SimpleConvertorUiState build() {
    final s = ref.watch(convertorStateProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final rawBase = spec.rawBase(s);
    final inputUnit = spec.inputUnit(s);
    return SimpleConvertorUiState(
      rawValue: rawBase.convert(spec.baseUnit, inputUnit),
      inputUnit: inputUnit,
      sections: [
        for (final section in spec.sections)
          ConvertorSection(section.title, [
            for (final u in section.units)
              fieldFor(
                rawBase,
                u.unit,
                u.label,
                spec.constraintsFor(u.unit).accuracy,
                l10n,
              ),
          ]),
      ],
    );
  }

  void updateRawValue(double? rawValueInInputUnit) {
    final notifier = ref.read(convertorsProvider.notifier);
    if (rawValueInInputUnit == null) {
      unawaited(spec.saveRawBase(notifier, null));
      return;
    }
    final inputUnit = spec.inputUnit(ref.read(convertorStateProvider));
    final baseValue = rawValueInInputUnit.convert(inputUnit, spec.baseUnit);
    unawaited(spec.saveRawBase(notifier, baseValue));
  }

  void changeInputUnit(Unit newUnit) {
    final notifier = ref.read(convertorsProvider.notifier);
    unawaited(spec.saveInputUnit(notifier, newUnit));
  }

  GenericConvertorField fieldFor(
    double rawBase,
    Unit toUnit,
    String Function(AppLocalizations) labelBuilder,
    int decimals,
    AppLocalizations l10n,
  ) {
    final value = rawBase.convert(spec.baseUnit, toUnit);
    final sym = toUnit.localizedSymbol(l10n);
    return GenericConvertorField(
      labelBuilder: labelBuilder,
      formattedValue: _fmt(value, decimals, sym),
      value: value,
      symbol: sym,
      decimals: decimals,
    );
  }

  static String _fmt(double value, int decimals, String symbol) {
    if (value.isNaN || value.isInfinite) return '— $symbol';
    return '${value.toFixedSafe(decimals)} $symbol';
  }
}
