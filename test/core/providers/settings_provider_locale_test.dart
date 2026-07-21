// flutter test test/core/providers/settings_provider_locale_test.dart

import 'dart:io';

import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:ebalistyka/core/providers/db_seed.dart';
import 'package:ebalistyka/core/providers/settings_provider.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  late TestWidgetsFlutterBinding binding;
  late Directory tmpDir;
  late File settingsFile;

  setUpAll(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    tmpDir = await Directory.systemTemp.createTemp('settings_locale_test_');
    settingsFile = File('${tmpDir.path}/settings.ebcp');
  });

  tearDown(() {
    binding.platformDispatcher.clearLocaleTestValue();
    tmpDir.deleteSync(recursive: true);
  });

  Future<ProviderContainer> makeContainer() async {
    final store = MsgStore<SettingsData>(
      settingsFile,
      encode: SettingsFile.encode,
      decode: SettingsFile.decode,
    );
    final initial = await store.load(orElseSeed: seedSettings);
    return ProviderContainer(
      overrides: [
        settingsStoreProvider.overrideWithValue(store),
        settingsDataProvider.overrideWith(
          () => SettingsDataNotifier(initial),
        ),
      ],
    );
  }

  Future<GeneralSettings> waitForSettings(ProviderContainer c) =>
      c.read(settingsProvider.future);

  // seedSettings() deliberately never bakes a resolved system locale into
  // languageCode — an empty languageCode means "no explicit user choice",
  // which lets MaterialApp.locale stay null and defer to Flutter's own
  // live, device-locale-list-aware resolver (see main.dart/
  // settings_provider.dart's localeProvider). Baking a locale in here would
  // permanently pin the UI locale from first launch onward and stop it
  // reacting to OS locale changes — see docs/backlogs/
  // 8.PROTOBUF_STORAGE_MIGRATION.md's locale-handling fix.
  group('first launch — languageCode stays unset regardless of system locale', () {
    test('Ukrainian system locale → still unset', () async {
      binding.platformDispatcher.localeTestValue = const Locale('uk');

      final container = await makeContainer();
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, isEmpty);
    });

    test('English system locale → still unset', () async {
      binding.platformDispatcher.localeTestValue = const Locale('en');

      final container = await makeContainer();
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, isEmpty);
    });

    test('Unsupported system locale → still unset', () async {
      binding.platformDispatcher.localeTestValue = const Locale('fr');

      final container = await makeContainer();
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, isEmpty);
    });
  });

  group('subsequent launch — an explicit saved choice is preserved, ignoring system locale', () {
    test(
      'saved "uk" is returned even if system locale changed to "en"',
      () async {
        // First launch: seeded unset, then simulate the user explicitly
        // picking "uk" (e.g. via the settings screen's language picker).
        final c1 = await makeContainer();
        final settings1 = await waitForSettings(c1);
        await c1.read(settingsStoreProvider).save(
          SettingsData()..generalSettings = (settings1..languageCode = 'uk'),
        );
        c1.dispose();

        // System locale changes to 'en', but disk already has an explicit 'uk'.
        binding.platformDispatcher.localeTestValue = const Locale('en');
        final c2 = await makeContainer();
        addTearDown(c2.dispose);

        final settings = await waitForSettings(c2);
        expect(settings.languageCode, 'uk');
      },
    );
  });
}
