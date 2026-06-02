// flutter test test/core/providers/settings_provider_locale_test.dart

import 'dart:io';

import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:ebalistyka/core/providers/settings_provider.dart';
import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  late Store store;
  late Directory tmpDir;
  late Owner owner;

  setUp(() async {
    tmpDir = await Directory.systemTemp.createTemp('settings_locale_test_');
    store = await initObjectBox(directory: tmpDir.path);
    owner = await ObjectBoxAppRepository(store).ensureOwner('local');
  });

  tearDown(() {
    store.close();
    tmpDir.deleteSync(recursive: true);
  });

  ProviderContainer makeContainer({required Locale locale}) =>
      ProviderContainer(overrides: [
        settingsRepositoryProvider
            .overrideWithValue(ObjectBoxSettingsRepository(store)),
        ownerProvider.overrideWithValue(owner),
        systemLocaleProvider.overrideWithValue(locale),
      ]);

  Future<GeneralSettings> waitForSettings(ProviderContainer c) =>
      c.read(settingsProvider.future);

  group('first launch — locale auto-resolved from system', () {
    test('Ukrainian system locale → languageCode = "uk"', () async {
      final container = makeContainer(locale: const Locale('uk'));
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, 'uk');
    });

    test('English system locale → languageCode = "en"', () async {
      final container = makeContainer(locale: const Locale('en'));
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, 'en');
    });

    test('Unsupported system locale → fallback to "en"', () async {
      final container = makeContainer(locale: const Locale('fr'));
      addTearDown(container.dispose);

      final settings = await waitForSettings(container);
      expect(settings.languageCode, 'en');
    });
  });

  group('subsequent launch — reads saved value, ignores system locale', () {
    test(
      'saved "uk" is returned even if system locale changed to "en"',
      () async {
        // First launch: system = 'uk' → saved to DB
        final c1 = makeContainer(locale: const Locale('uk'));
        await waitForSettings(c1);
        c1.dispose();

        // System locale changes to 'en', but DB already has 'uk'
        final c2 = makeContainer(locale: const Locale('en'));
        addTearDown(c2.dispose);

        final settings = await waitForSettings(c2);
        expect(settings.languageCode, 'uk');
      },
    );
  });
}
