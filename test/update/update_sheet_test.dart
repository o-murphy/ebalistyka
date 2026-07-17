// Widget tests for showUpdateBottomSheet and showPrereleaseWarningSheet.
// Private widgets (_UpdateSheet, _SideloadButton, etc.) are tested indirectly
// via the public show* functions. Platform-specific branches (sideload/winget)
// are never active on the Linux test runner, so they are excluded.
//   flutter test test/update/update_sheet_test.dart

import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/update/update_checker.dart';
import 'package:ebalistyka/update/update_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _app(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

class _SheetLauncher extends StatelessWidget {
  const _SheetLauncher({required this.release});
  final GithubRelease release;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () => showUpdateBottomSheet(context, release),
    child: const Text('open'),
  );
}

class _PrereleaseSheetLauncher extends StatelessWidget {
  const _PrereleaseSheetLauncher({required this.onConfirm});
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () => showPrereleaseWarningSheet(context, onConfirm: onConfirm),
    child: const Text('open'),
  );
}

GithubRelease _release({
  String tagName = 'v2.1.0',
  bool isPlayStore = false,
  String? apkUrl,
  LinuxInstallerType? linuxInstallerType,
}) => GithubRelease(
  tagName: tagName,
  htmlUrl: 'https://github.com/o-murphy/ebalistyka/releases/tag/$tagName',
  prerelease: false,
  isPlayStore: isPlayStore,
  packageName: 'com.o_murphy.ebalistyka',
  apkUrl: apkUrl,
  linuxInstallerType: linuxInstallerType,
);

Future<void> _openUpdateSheet(
  WidgetTester tester,
  GithubRelease release,
) async {
  await tester.pumpWidget(_app(_SheetLauncher(release: release)));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Future<void> _openPrereleaseSheet(
  WidgetTester tester, {
  VoidCallback? onConfirm,
}) async {
  // The prerelease sheet body text wraps and needs more vertical space than
  // the default 600px test window provides.
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    _app(_PrereleaseSheetLauncher(onConfirm: onConfirm ?? () {})),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  // ── Title ─────────────────────────────────────────────────────────────────

  group('_UpdateSheet — title', () {
    testWidgets('shows version number without leading v', (tester) async {
      await _openUpdateSheet(tester, _release(tagName: 'v2.1.0'));
      expect(find.textContaining('2.1.0'), findsOneWidget);
      expect(find.textContaining('v2.1.0'), findsNothing);
    });

    testWidgets('shows version when tag has no v prefix', (tester) async {
      await _openUpdateSheet(tester, _release(tagName: '3.0.1'));
      expect(find.textContaining('3.0.1'), findsOneWidget);
    });
  });

  // ── Button labels per installer type ──────────────────────────────────────

  group('_UpdateSheet — button label per release type', () {
    testWidgets('snap → "Open in Snap Store"', (tester) async {
      await _openUpdateSheet(
        tester,
        _release(linuxInstallerType: LinuxInstallerType.snap),
      );
      expect(find.text('Open in Snap Store'), findsOneWidget);
    });

    testWidgets('flatpak → "View"', (tester) async {
      await _openUpdateSheet(
        tester,
        _release(linuxInstallerType: LinuxInstallerType.flatpak),
      );
      expect(find.text('View'), findsOneWidget);
    });

    testWidgets('generic (no installer type) → "View"', (tester) async {
      await _openUpdateSheet(tester, _release());
      expect(find.text('View'), findsOneWidget);
    });

    testWidgets('Play Store → "Open in Google Play"', (tester) async {
      await _openUpdateSheet(tester, _release(isPlayStore: true));
      expect(find.text('Open in Google Play'), findsOneWidget);
    });

    testWidgets('snap release does not show "Upgrade via snap"', (
      tester,
    ) async {
      await _openUpdateSheet(
        tester,
        _release(linuxInstallerType: LinuxInstallerType.snap),
      );
      expect(find.text('Upgrade via snap'), findsNothing);
    });
  });

  // ── Winget copy action ────────────────────────────────────────────────────
  // (winget is Windows-only; on Linux the button is never shown, so we only
  // verify it is absent — the copy logic mirrors the snap pattern exactly)

  group('_UpdateSheet — winget branch absent on Linux', () {
    testWidgets('winget button not shown on Linux test runner', (tester) async {
      await _openUpdateSheet(tester, _release());
      expect(find.text('Upgrade via winget'), findsNothing);
    });
  });

  // ── Cancel button ─────────────────────────────────────────────────────────

  group('_UpdateSheet — cancel button', () {
    testWidgets('closes the sheet', (tester) async {
      await _openUpdateSheet(
        tester,
        _release(linuxInstallerType: LinuxInstallerType.snap),
      );
      expect(find.text('Open in Snap Store'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Open in Snap Store'), findsNothing);
    });
  });

  // ── showPrereleaseWarningSheet ────────────────────────────────────────────

  group('showPrereleaseWarningSheet', () {
    testWidgets('shows "Prerelease Version" title', (tester) async {
      await _openPrereleaseSheet(tester);
      expect(find.text('Prerelease Version'), findsOneWidget);
    });

    testWidgets('shows warning body text', (tester) async {
      await _openPrereleaseSheet(tester);
      expect(find.textContaining('Prerelease builds'), findsOneWidget);
    });

    testWidgets('Continue button triggers onConfirm callback', (tester) async {
      var confirmed = false;
      await _openPrereleaseSheet(tester, onConfirm: () => confirmed = true);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
    });

    testWidgets('Continue button closes the sheet', (tester) async {
      await _openPrereleaseSheet(tester);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Prerelease Version'), findsNothing);
    });

    testWidgets('Cancel button closes the sheet without calling onConfirm', (
      tester,
    ) async {
      var confirmed = false;
      await _openPrereleaseSheet(tester, onConfirm: () => confirmed = true);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(confirmed, isFalse);
      expect(find.text('Prerelease Version'), findsNothing);
    });
  });
}
