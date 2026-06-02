import 'dart:io';
import 'dart:ui';

import 'package:ebalistyka/core/storage_backend.dart';
import 'package:ebalistyka/shared/constants/app_info.dart';
import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebalistyka/shared/helpers/is_desktop.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:window_manager/window_manager.dart';

import 'core/providers/db_provider.dart';
import 'core/providers/settings_provider.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';

const _windowMinWidth = 320.0;
const _windowMinHeight = 600.0;
const _windowInitialWidth = 375.0;
const _windowInitialHeight = 812.0;

Future<(Store, bool)> _openObjectBoxStore(String directory) async {
  final hadData = await File('$directory/data.mdb').exists();
  try {
    return (await initObjectBox(directory: directory), false);
  } catch (e) {
    debugPrint('ObjectBox open failed — resetting DB: $e');
    for (final name in const ['data.mdb', 'lock.mdb']) {
      final f = File('$directory/$name');
      if (await f.exists()) await f.delete();
    }
    return (await initObjectBox(directory: directory), hadData);
  }
}

Future<List<Override>> _initObjectBox(String supportDir) async {
  final (store, dbWasReset) = await _openObjectBoxStore(supportDir);
  final appRepo = ObjectBoxAppRepository(store);
  final settingsRepo = ObjectBoxSettingsRepository(store);
  final owner = await appRepo.ensureOwner('local');
  return [
    dbProvider.overrideWithValue(store),
    dbWasResetProvider.overrideWithValue(dbWasReset),
    appRepositoryProvider.overrideWithValue(appRepo),
    settingsRepositoryProvider.overrideWithValue(settingsRepo),
    ownerProvider.overrideWithValue(owner),
  ];
}

Future<List<Override>> _initSembast(String supportDir) async {
  final dbPath = '$supportDir/ebalistyka.db';
  final db = await databaseFactoryIo.openDatabase(dbPath);
  final appRepo = SembastAppRepository(db);
  final settingsRepo = SembastSettingsRepository(db);
  final owner = await appRepo.ensureOwner('local');
  return [
    appRepositoryProvider.overrideWithValue(appRepo),
    settingsRepositoryProvider.overrideWithValue(settingsRepo),
    ownerProvider.overrideWithValue(owner),
  ];
}

void main() async {
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
  debugPrint('Support dir: ${appSupport.path}');

  debugAppInfoConstants();

  final overrides = kStorageBackend == StorageBackend.sembast
      ? await _initSembast(appSupport.path)
      : await _initObjectBox(appSupport.path);

  runApp(
    ProviderScope(
      overrides: overrides,
      child: const MyApp(),
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
    if (ref.read(dbWasResetProvider)) {
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
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (locale != null) {
          for (final supported in supportedLocales) {
            if (supported.languageCode == locale.languageCode) {
              return supported;
            }
          }
        }
        if (deviceLocale != null) {
          for (final supported in supportedLocales) {
            if (supported.languageCode == deviceLocale.languageCode) {
              return supported;
            }
          }
        }
        return const Locale('en');
      },
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
