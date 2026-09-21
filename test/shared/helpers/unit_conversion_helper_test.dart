import 'package:bclibc_flutter/unit.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:ebalistyka/shared/helpers/unit_constrained_convertion_helper.dart';
import 'package:test/test.dart';

void main() {
  group('UnitConversionHelper.formatDisplayValue', () {
    final helper = UnitConversionHelper(
      constraints: RC.lookAngle,
      displayUnit: Unit.degree,
    );

    test('exact negative zero has no sign', () {
      expect(helper.formatDisplayValue(-0.0), isNot(startsWith('-')));
    });

    test('tiny negative value rounding to zero has no sign', () {
      expect(helper.formatDisplayValue(-1e-16), isNot(startsWith('-')));
    });

    test('genuine negative value keeps its sign', () {
      expect(helper.formatDisplayValue(-1.0), startsWith('-1'));
    });
  });
}
