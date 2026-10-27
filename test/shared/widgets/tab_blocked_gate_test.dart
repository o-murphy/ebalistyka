import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/tab_blocked_gate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _app({
  required ValueListenable<bool> blocked,
  required VoidCallback onUseHere,
  required VoidCallback onChildTap,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    // Same as main.dart: material_ui widgets need its own Material delegates.
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: TabBlockedGate(
      blocked: blocked,
      onUseHere: onUseHere,
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: onChildTap,
            child: const Text('child-button'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows only the app while not blocked', (tester) async {
    final blocked = ValueNotifier(false);
    await tester.pumpWidget(
      _app(blocked: blocked, onUseHere: () {}, onChildTap: () {}),
    );

    expect(find.text('child-button'), findsOneWidget);
    expect(find.text('Use here'), findsNothing);
  });

  testWidgets('covers the app and blocks taps once blocked', (tester) async {
    final blocked = ValueNotifier(false);
    var childTaps = 0;
    await tester.pumpWidget(
      _app(blocked: blocked, onUseHere: () {}, onChildTap: () => childTaps++),
    );

    await tester.tap(find.text('child-button'));
    expect(childTaps, 1);

    blocked.value = true;
    await tester.pump();

    expect(find.text('Opened in another window'), findsOneWidget);
    expect(find.text('Use here'), findsOneWidget);

    // The stale app underneath no longer receives input.
    await tester.tap(find.text('child-button'), warnIfMissed: false);
    expect(childTaps, 1);
  });

  testWidgets('"Use here" calls onUseHere', (tester) async {
    final blocked = ValueNotifier(true);
    var used = 0;
    await tester.pumpWidget(
      _app(blocked: blocked, onUseHere: () => used++, onChildTap: () {}),
    );

    await tester.tap(find.text('Use here'));
    expect(used, 1);
  });

  testWidgets('is localized (uk)', (tester) async {
    final blocked = ValueNotifier(true);
    await tester.pumpWidget(
      _app(
        blocked: blocked,
        onUseHere: () {},
        onChildTap: () {},
        locale: const Locale('uk'),
      ),
    );

    expect(find.text('Відкрито в іншому вікні'), findsOneWidget);
    expect(find.text('Використовувати тут'), findsOneWidget);
  });
}
