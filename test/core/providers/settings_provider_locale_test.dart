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

  group('first launch — locale auto-resolved from system', () {
    test('Ukrainian system locale → languageCode = "uk"', () async {
      binding.platformDispatcher.localeTestValue = const Locale('uk');

      final container = await makeContainer();
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, 'uk');
    });

    test('English system locale → languageCode = "en"', () async {
      binding.platformDispatcher.localeTestValue = const Locale('en');

      final container = await makeContainer();
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, 'en');
    });

    test('Unsupported system locale → fallback to "en"', () async {
      binding.platformDispatcher.localeTestValue = const Locale('fr');

      final container = await makeContainer();
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, 'en');
    });
  });

  group('subsequent launch — reads saved value, ignores system locale', () {
    test(
      'saved "uk" is returned even if system locale changed to "en"',
      () async {
        // First launch: system = 'uk' → seeded and saved to disk
        binding.platformDispatcher.localeTestValue = const Locale('uk');
        final c1 = await makeContainer();
        final settings1 = await waitForSettings(c1);
        await c1.read(settingsStoreProvider).save(
          SettingsData()..generalSettings = settings1,
        );
        c1.dispose();

        // System locale changes to 'en', but disk already has 'uk'
        binding.platformDispatcher.localeTestValue = const Locale('en');
        final c2 = await makeContainer();
        addTearDown(c2.dispose);

        final settings = await waitForSettings(c2);
        expect(settings.languageCode, 'uk');
      },
    );
  });
}
