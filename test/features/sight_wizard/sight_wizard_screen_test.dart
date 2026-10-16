// Reticle tile in the sight wizard shows the current reticle id, or "Default"
// for an empty/absent one.
//   flutter test test/features/sight_wizard/sight_wizard_screen_test.dart

import 'package:bclibc_flutter/unit.dart';
import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/core/providers/settings_provider.dart';
import 'package:ebalistyka/features/home/sub_screens/sight_wizard_screen.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Sight _sight(String reticle) => Sight()
  ..name = 'Test Scope'
  ..sightHeight = Distance.millimeter(50.0)
  ..focalPlane = FocalPlane.ffp
  ..verticalClickUnitValue = Unit.mil
  ..verticalClick = 0.1
  ..horizontalClickUnitValue = Unit.mil
  ..horizontalClick = 0.1
  ..minMagnification = 4.0
  ..maxMagnification = 16.0
  ..reticleImage = reticle;

Future<void> _pump(WidgetTester tester, Sight? initial) async {
  tester.view.physicalSize = const Size(800, 4000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [unitSettingsProvider.overrideWithValue(UnitSettings())],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SightWizardScreen(initial: initial),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows the stored reticle id', (tester) async {
    await _pump(tester, _sight('MIL-XT'));
    expect(find.text('MIL-XT'), findsOneWidget);
  });

  testWidgets('empty reticle id shows "default"', (tester) async {
    await _pump(tester, _sight(''));
    expect(find.text('default'), findsOneWidget);
  });

  testWidgets('new sight shows "default"', (tester) async {
    await _pump(tester, null);
    expect(find.text('default'), findsOneWidget);
  });
}
