import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FieldConstraints.inUnit', () {
    test('same unit keeps the values and accuracy', () {
      final c = FC.convertorLength.inUnit(Unit.inch);
      expect(c.rawUnit, Unit.inch);
      expect(c.minRaw, FC.convertorLength.minRaw);
      expect(c.maxRaw, FC.convertorLength.maxRaw);
      expect(c.stepRaw, FC.convertorLength.stepRaw);
      expect(c.accuracy, FC.convertorLength.accuracy);
    });

    test('converts range and step, accuracy follows the target unit', () {
      final c = FC.convertorLength.inUnit(Unit.millimeter);
      expect(c.rawUnit, Unit.millimeter);
      expect(
        c.minRaw,
        FC.convertorLength.minRaw.convert(Unit.inch, Unit.millimeter),
      );
      expect(
        c.maxRaw,
        FC.convertorLength.maxRaw.convert(Unit.inch, Unit.millimeter),
      );
      expect(
        c.stepRaw,
        FC.convertorLength.stepRaw.convert(Unit.inch, Unit.millimeter),
      );
      expect(c.accuracy, FC.convertorLength.accuracyFor(Unit.millimeter));
    });
  });
}
