import 'dart:io';
import 'dart:ui';

import 'package:dart_bclibc/ffi/bclibc_ffi.dart';
import 'package:ebalistyka/shared/constants/app_info.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebalistyka/shared/helpers/is_desktop.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'core/providers/db_provider.dart';
import 'core/providers/db_seed.dart';
import 'core/providers/settings_provider.dart';
import 'l10n/app_localizations.dart';
import 'ob_migrate/ob_migrate.dart';
import 'router.dart';

// Constants for window sizes
const _windowMinWidth = 320.0;
const _windowMinHeight = 600.0;
// const _windowMaxWidth = 1000.0;
// const _windowMaxHeight = 1080.0;
const _windowInitialWidth = 375.0;
const _windowInitialHeight = 812.0;

// Constants for content restrictions
// const _contentMaxWidth = _windowMaxWidth;
// const _contentMaxHeight = _windowMaxHeight;

/// Opens both `.ebcp` stores, seeding whichever one is missing/corrupt.
/// Each file's "existed but got reseeded" state is tracked independently —
/// a crash/corruption in one file must never get blamed on the other.
Future<(MsgStore<SettingsData>, SettingsData, MsgStore<ProfilesData>, List<Profile>, bool)>
_openStores(String directory) async {
  final settingsFile = File('$directory/settings.ebcp');
  final profilesFile = File('$directory/profiles.ebcp');
  final settingsStore = MsgStore<SettingsData>(
    settingsFile,
    encode: SettingsFile.encode,
    decode: SettingsFile.decode,
  );
  final profilesStore = MsgStore<ProfilesData>(
    profilesFile,
    encode: ProfilesFile.encode,
    decode: ProfilesFile.decode,
  );

  final hadSettingsFile = await settingsFile.exists();
  final hadProfilesFile = await profilesFile.exists();
  var settingsWasSeeded = false;
  var profilesWasSeeded = false;

  final settings = await settingsStore.load(
    orElseSeed: () {
      settingsWasSeeded = true;
      return seedSettings();
    },
  );
  final profilesData = await profilesStore.load(
    orElseSeed: () {
      profilesWasSeeded = true;
      return ProfilesData(profiles: seedProfiles());
    },
  );

  // Persist freshly-seeded data immediately — otherwise a user who closes
  // the app before touching anything would re-seed (a new random profile
  // uuid) on every subsequent launch, since load() never writes on its own.
  if (settingsWasSeeded) await settingsStore.save(settings);
  if (profilesWasSeeded) await profilesStore.save(profilesData);

  final dataWasReset =
      (hadSettingsFile && settingsWasSeeded) ||
      (hadProfilesFile && profilesWasSeeded);

  return (
    settingsStore,
    settings,
    profilesStore,
    profilesData.profiles,
    dataWasReset,
  );
}

void main() async {
  try {
    BcLibC.open();
  } catch (e) {
    stderr.writeln('Fatal: native library unavailable: $e');
    exit(1);
  }

  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop) {
    await windowManager.ensureInitialized();

    const size = Size(_windowInitialWidth, _windowInitialHeight);
    const minSize = Size(_windowMinWidth, _windowMinHeight);

    WindowOptions windowOptions = WindowOptions(
      size: size,
      minimumSize: minSize,
      center: true,
      title: 'eBalistyka',
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.setIcon('assets/icon.png');
      await windowManager.focus();

      await windowManager.setMinimumSize(minSize);
      await windowManager.setMaximizable(false);
    });
  }

  final appSupport = await getApplicationSupportDirectory();
  final (
    settingsStore,
    initialSettings,
    profilesStore,
    initialProfiles,
    dataWasReset,
  ) = await _openStores(appSupport.path);
  debugPrint('DB path: ${appSupport.path}');

  debugAppInfoConstants();

  final showMigrationGate = await hasUnmigratedLegacyData(appSupport.path);

  runApp(
    ProviderScope(
      overrides: [
        settingsStoreProvider.overrideWithValue(settingsStore),
        profilesStoreProvider.overrideWithValue(profilesStore),
        settingsDataProvider.overrideWith(
          () => SettingsDataNotifier(initialSettings),
        ),
        profilesProvider.overrideWith(() => ProfilesNotifier(initialProfiles)),
        dataWasResetProvider.overrideWithValue(dataWasReset),
      ],
      child: showMigrationGate
          ? MigrationGate(objectboxDir: appSupport.path, child: const MyApp())
          : const MyApp(),
    ),
  );
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class _DbResetBanner extends ConsumerStatefulWidget {
  const _DbResetBanner({required this.child});
  final Widget child;

  @override
  ConsumerState<_DbResetBanner> createState() => _DbResetBannerState();
}

class _DbResetBannerState extends ConsumerState<_DbResetBanner> {
  @override
  void initState() {
    super.initState();
    if (ref.read(dataWasResetProvider)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Database was corrupted and has been reset. All data has been cleared.',
            ),
            duration: Duration(seconds: 6),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static final _lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
  );

  static final _darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'eBalistyka',
      debugShowCheckedModeBanner: false,
      // locale: null (no explicit user choice yet) lets Flutter's own
      // live, device-locale-list-aware resolver (basicLocaleListResolution
      // + didChangeLocales) handle it — a hand-rolled
      // localeResolutionCallback here would short-circuit that: whenever
      // MaterialApp.locale is non-null, Flutter substitutes it for the
      // real device locale list before invoking the callback, so any
      // "fall back to device locale" branch becomes dead code and the UI
      // stops reacting to OS locale changes after the first pin.
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: themeMode,
      scrollBehavior: _AppScrollBehavior(),
      builder: (context, child) {
        final inner = _DbResetBanner(child: child!);
        if (isDesktop) {
          return Center(child: Container(child: inner));
        }
        return inner;
      },
    );
  }
}
