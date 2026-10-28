// Characterization test for UnitFormatterImpl.inputToRaw / rawToInput: every
// InputField, several unit setups and values, compared with
// input_conversion_golden.txt (delete the golden to regenerate it).
import 'dart:io';

import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/formatting/unit_formatter.dart';
import 'package:ebalistyka/core/formatting/unit_formatter_impl.dart';
import 'package:ebalistyka/l10n/app_localizations_en.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_test/flutter_test.dart';

UnitSettings _metric() => UnitSettings()..sightHeight = Unit.millimeter.name;

UnitSettings _imperial() => UnitSettings()
  ..velocity = Unit.fps.name
  ..distance = Unit.yard.name
  ..temperature = Unit.fahrenheit.name
  ..pressure = Unit.inHg.name
  ..weight = Unit.gram.name
  ..length = Unit.inch.name
  ..diameter = Unit.inch.name
  ..sightHeight = Unit.inch.name
  ..twist = Unit.inch.name
  ..barrelLength = Unit.inch.name
  ..torque = Unit.footPoundTorque.name;

UnitSettings _mixed() => UnitSettings()
  ..velocity = Unit.kmh.name
  ..distance = Unit.foot.name
  ..temperature = Unit.kelvin.name
  ..pressure = Unit.mmHg.name
  ..weight = Unit.grain.name
  ..length = Unit.millimeter.name
  ..diameter = Unit.millimeter.name
  ..sightHeight = Unit.centimeter.name
  ..twist = Unit.centimeter.name
  ..barrelLength = Unit.centimeter.name
  ..torque = Unit.inchPound.name;

void main() {
  test('inputToRaw / rawToInput keep their results for every field', () {
    final out = StringBuffer();
    final l10n = AppLocalizationsEn();
    for (final (name, settings) in [
      ('metric', _metric()),
      ('imperial', _imperial()),
      ('mixed', _mixed()),
    ]) {
      final UnitFormatter fmt = UnitFormatterImpl(settings, l10n);
      out.writeln('##### $name');
      for (final field in InputField.values) {
        final parts = <String>[];
        for (final v in [0.0, 1.0, 12.5, -3.0, 1000.0]) {
          parts.add('$v: ${fmt.inputToRaw(v, field)} / ${fmt.rawToInput(v, field)}');
        }
        out.writeln('${field.name}: ${parts.join(' | ')}');
      }
    }

    final golden = File('test/core/formatting/input_conversion_golden.txt');
    if (!golden.existsSync()) {
      golden.writeAsStringSync(out.toString());
      // ignore: avoid_print
      print('Wrote ${golden.path} — review and commit it.');
      return;
    }
    expect(out.toString(), golden.readAsStringSync());
  });
}
