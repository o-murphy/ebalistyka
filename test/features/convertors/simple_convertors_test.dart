// Characterization test for the five "simple" convertors (length, weight,
// pressure, temperature, torque): the sections / values / constraints each VM
// produces and what its input handlers save, plus the text each screen shows.
// The dump is compared with simple_convertors_golden.txt; delete the golden to
// regenerate it (and review the diff).
import 'dart:io';

import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/extensions/convertors_extensions.dart';
import 'package:ebalistyka/core/providers/convertors_notifier.dart';
import 'package:ebalistyka/core/providers/settings_provider.dart';
import 'package:ebalistyka/features/convertors/simple_convertor_specs.dart';
import 'package:ebalistyka/features/convertors/simple_convertor_vm.dart';
import 'package:ebalistyka/features/convertors/sub_screens/simple_convertor_screen.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Records what the VMs save instead of writing settings.
class _RecordingNotifier extends ConvertorsNotifier {
  _RecordingNotifier(this.log);
  final List<String> log;

  @override
  ConvertorsState build() => defaultConvertorsState();

  @override
  Future<void> updateLengthValue(double? v) async => log.add('length=$v');
  @override
  Future<void> updateLengthUnit(Unit u) async => log.add('lengthUnit=${u.name}');
  @override
  Future<void> updateWeightValue(double? v) async => log.add('weight=$v');
  @override
  Future<void> updateWeightUnit(Unit u) async => log.add('weightUnit=${u.name}');
  @override
  Future<void> updatePressureValue(double? v) async => log.add('pressure=$v');
  @override
  Future<void> updatePressureUnit(Unit u) async =>
      log.add('pressureUnit=${u.name}');
  @override
  Future<void> updateTemperatureValue(double? v) async =>
      log.add('temperature=$v');
  @override
  Future<void> updateTemperatureUnit(Unit u) async =>
      log.add('temperatureUnit=${u.name}');
  @override
  Future<void> updateTorqueValue(double? v) async => log.add('torque=$v');
  @override
  Future<void> updateTorqueUnit(Unit u) async => log.add('torqueUnit=${u.name}');
}

class _Case {
  _Case(this.name, this.provider, this.screen, this.units, this.apply);
  final String name;
  final NotifierProvider<SimpleConvertorVm, SimpleConvertorUiState> provider;
  final Widget screen;
  final List<Unit> units;

  /// Puts (raw base value, input unit) into the convertors state.
  final void Function(ConvertorsState s, double base, Unit unit) apply;
}

final _cases = [
  _Case(
    'length',
    lengthConvertorVmProvider,
    SimpleConvertorScreen(provider: lengthConvertorVmProvider),
    [Unit.centimeter, Unit.meter, Unit.inch, Unit.foot, Unit.yard],
    (s, v, u) => s
      ..lengthValue = Distance.inch(v)
      ..lengthUnit = u,
  ),
  _Case(
    'weight',
    weightConvertorVmProvider,
    SimpleConvertorScreen(provider: weightConvertorVmProvider),
    [Unit.gram, Unit.kilogram, Unit.grain, Unit.pound, Unit.ounce],
    (s, v, u) => s
      ..weightValue = Weight.grain(v)
      ..weightUnit = u,
  ),
  _Case(
    'pressure',
    pressureConvertorVmProvider,
    SimpleConvertorScreen(provider: pressureConvertorVmProvider),
    [Unit.mmHg, Unit.inHg, Unit.bar, Unit.hPa, Unit.psi, Unit.atm],
    (s, v, u) => s
      ..pressureValue = Pressure.mmHg(v)
      ..pressureUnit = u,
  ),
  _Case(
    'temperature',
    temperatureConvertorVmProvider,
    SimpleConvertorScreen(provider: temperatureConvertorVmProvider),
    [Unit.celsius, Unit.fahrenheit],
    (s, v, u) => s
      ..temperatureValue = Temperature.fahrenheit(v)
      ..temperatureUnit = u,
  ),
  _Case(
    'torque',
    torqueConvertorVmProvider,
    SimpleConvertorScreen(provider: torqueConvertorVmProvider),
    [Unit.newtonMeter, Unit.footPoundTorque, Unit.inchPound],
    (s, v, u) => s
      ..torqueValue = Torque.newtonMeter(v)
      ..torqueUnit = u,
  ),
];

ProviderContainer _container(
  ConvertorsState state,
  AppLocalizations l10n,
  List<String> log,
) => ProviderContainer(
  overrides: [
    convertorStateProvider.overrideWithValue(state),
    appLocalizationsProvider.overrideWithValue(l10n),
    convertorsProvider.overrideWith(() => _RecordingNotifier(log)),
  ],
);

void main() {
  late AppLocalizations l10n;
  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  testWidgets('simple convertors keep their sections, values and handlers',
      (tester) async {
    final out = StringBuffer();
    await tester.binding.setSurfaceSize(const Size(500, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final c in _cases) {
      out.writeln('##### ${c.name}');
      for (final (value, unit) in [
        (1.0, c.units.first),
        (123.456, c.units[1]),
        (0.0, c.units.last),
      ]) {
        final log = <String>[];
        final state = defaultConvertorsState();
        c.apply(state, value, unit);
        final container = _container(state, l10n, log);
        addTearDown(container.dispose);

        final ui = container.read(c.provider);
        out.writeln('--- base=$value input=${unit.name}');
        out.writeln('rawValue=${ui.rawValue} inputUnit=${ui.inputUnit.name}');
        for (final s in ui.sections) {
          out.writeln('[${s.titleBuilder(l10n)}]');
          for (final f in s.fields) {
            out.writeln(
              '  ${f.labelBuilder(l10n)} | ${f.formattedValue} | '
              '${f.value} | ${f.symbol} | ${f.decimals}',
            );
          }
        }

        final vm = container.read(c.provider.notifier);
        for (final u in c.units) {
          final k = vm.getConstraintsForUnit(u);
          out.writeln(
            'constraints ${u.name}: ${k.minRaw} .. ${k.maxRaw} step '
            '${k.stepRaw} unit ${k.rawUnit.name} acc ${k.accuracy}',
          );
        }
        vm.updateRawValue(7.5);
        vm.updateRawValue(null);
        vm.changeInputUnit(c.units.last);
        await tester.pump();
        out.writeln('saved: ${log.join(', ')}');
      }

      // The screen: every text it shows for the first case.
      final state = defaultConvertorsState();
      c.apply(state, 12.5, c.units.first);
      final container = _container(state, l10n, <String>[]);
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: c.screen,
          ),
        ),
      );
      await tester.pumpAndSettle();
      out.writeln('--- screen');
      for (final w in tester.widgetList<Text>(find.byType(Text))) {
        out.writeln('  ${w.data}');
      }
      for (final f in tester.widgetList<TextField>(find.byType(TextField))) {
        out.writeln('  field: ${f.controller?.text} hint: '
            '${f.decoration?.hintText}');
      }
    }

    final golden = File('test/features/convertors/simple_convertors_golden.txt');
    if (!golden.existsSync()) {
      golden.writeAsStringSync(out.toString());
      // ignore: avoid_print
      print('Wrote ${golden.path} — review and commit it.');
      return;
    }
    expect(out.toString(), golden.readAsStringSync());
  });
}
