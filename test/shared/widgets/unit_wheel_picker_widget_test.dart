import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:ebalistyka/shared/widgets/unit_wheel_picker_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Pumps a distance wheel at 100 m and returns a function that sends one
/// mouse-wheel event of the given pixel delta, plus the values reported.
Future<(Future<void> Function(double dy), List<double>)> _pump(
  WidgetTester tester,
) async {
  final values = <double>[];
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: UnitWheelPickerWidget(
          constraints: FC.targetDistance,
          initialRawValue: 100,
          displayUnit: Unit.meter,
          onChanged: values.add,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final pointer = TestPointer(1, PointerDeviceKind.mouse);
  await tester.sendEventToBinding(
    pointer.hover(tester.getCenter(find.byType(UnitWheelPickerWidget))),
  );
  Future<void> scroll(double dy) async {
    await tester.sendEventToBinding(pointer.scroll(Offset(0, dy)));
    await tester.pumpAndSettle();
  }

  return (scroll, values);
}

void main() {
  group('UnitWheelPickerWidget mouse wheel', () {
    for (final dy in [53.0, 100.0, 120.0]) {
      testWidgets('one notch of $dy px moves one value', (tester) async {
        final (scroll, values) = await _pump(tester);
        await scroll(dy);
        expect(values, [101.0]);
      });
    }

    testWidgets('scrolling up moves back one value', (tester) async {
      final (scroll, values) = await _pump(tester);
      await scroll(-100);
      expect(values, [99.0]);
    });

    testWidgets('two notches move two values', (tester) async {
      final (scroll, values) = await _pump(tester);
      await scroll(100);
      await scroll(100);
      expect(values, [101.0, 102.0]);
    });

    testWidgets('small deltas add up to one step', (tester) async {
      final (scroll, values) = await _pump(tester);
      await scroll(15);
      await scroll(15);
      expect(values, isEmpty);
      await scroll(15);
      expect(values, [101.0]);
    });
  });
}
