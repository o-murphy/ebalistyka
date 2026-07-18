import 'package:dart_bclibc/bclibc.dart';
import 'package:dart_bclibc/unit.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:ebalistyka/core/extensions/settings_extensions.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

// Every notifier below is a thin adapter over `settingsDataProvider`
// (the single source of truth, persisted to settings.ebcp) — build()
// derives its slice via select() (re-runs only when that slice actually
// changes, thanks to protobuf's deep `==`), and every mutation method
// writes through `settingsDataProvider.notifier.update()` rather than
// holding its own state. No manual `state = ...` assignment is needed in
// any mutation method; `ref.watch` in build() propagates the change back
// automatically.

// ── GeneralSettings notifier ──────────────────────────────────────────────────

class SettingsNotifier extends AsyncNotifier<GeneralSettings> {
  @override
  GeneralSettings build() =>
      ref.watch(settingsDataProvider.select((s) => s.generalSettings));

  void _update(void Function(GeneralSettings) mutate) {
    ref.read(settingsDataProvider.notifier).update((s) {
      final copy = s.deepCopy();
      mutate(copy.generalSettings);
      return copy;
    });
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _update((g) => g.flutterThemeMode = mode);
  }

  Future<void> setLanguage(String code) async {
    _update((g) => g.languageCode = code);
  }

  Future<void> setAdjustmentFormat(AdjustmentDisplayFormat format) async {
    _update((g) => g.adjustmentDisplayFormat = format);
  }

  Future<void> setChartDistanceStep(double step) async {
    _update((g) => g.homeChartDistanceStep = step);
  }

  Future<void> setHomeTableStep(double step) async {
    _update((g) => g.homeTableDistanceStep = step);
  }

  Future<void> setAdjustmentToggle(String key, bool value) async {
    _update((g) {
      switch (key) {
        case 'showMrad':
          g.homeShowMrad = value;
        case 'showMoa':
          g.homeShowMoa = value;
        case 'showMil':
          g.homeShowMil = value;
        case 'showCmPer100m':
          g.homeShowCmPer100m = value;
        case 'showInPer100yd':
          g.homeShowInPer100yd = value;
        case 'subsonicTransition':
          g.homeShowSubsonicTransition = value;
        case 'showInClicks':
          g.homeShowInClicks = value;
      }
    });
  }
}

// ── UnitSettings notifier ─────────────────────────────────────────────────────

class UnitSettingsNotifier extends AsyncNotifier<UnitSettings> {
  @override
  UnitSettings build() =>
      ref.watch(settingsDataProvider.select((s) => s.unitSettings));

  void _update(void Function(UnitSettings) mutate) {
    ref.read(settingsDataProvider.notifier).update((s) {
      final copy = s.deepCopy();
      mutate(copy.unitSettings);
      return copy;
    });
  }

  Future<void> setUnit(String key, Unit unit) async {
    _update((u) {
      switch (key) {
        case 'velocity':
          u.velocityUnit = unit;
        case 'distance':
          u.distanceUnit = unit;
        case 'sightHeight':
          u.sightHeightUnit = unit;
        case 'pressure':
          u.pressureUnit = unit;
        case 'temperature':
          u.temperatureUnit = unit;
        case 'diameter':
          u.diameterUnit = unit;
        case 'length':
          u.lengthUnit = unit;
        case 'weight':
          u.weightUnit = unit;
        case 'drop':
          u.dropUnit = unit;
        case 'energy':
          u.energyUnit = unit;
        case 'torque':
          u.torqueUnit = unit;
        case 'targetSize':
          u.targetSizeUnit = unit;
        case 'angular':
          u.angularUnit = unit;
      }
    });
  }
}

// ── TablesSettings notifier ───────────────────────────────────────────────────

class TablesSettingsNotifier extends AsyncNotifier<TablesSettings> {
  @override
  TablesSettings build() =>
      ref.watch(settingsDataProvider.select((s) => s.tablesSettings));

  void _update(void Function(TablesSettings) mutate) {
    ref.read(settingsDataProvider.notifier).update((s) {
      final copy = s.deepCopy();
      mutate(copy.tablesSettings);
      return copy;
    });
  }

  Future<void> saveSettings(TablesSettings settings) async {
    _update((t) {
      t
        ..distanceStartMeter = settings.distanceStartMeter
        ..distanceEndMeter = settings.distanceEndMeter
        ..distanceStepMeter = settings.distanceStepMeter
        ..showZeros = settings.showZeros
        ..showSubsonicTransition = settings.showSubsonicTransition
        ..hiddenCols.clear()
        ..hiddenCols.addAll(settings.hiddenCols)
        ..showMrad = settings.showMrad
        ..showMoa = settings.showMoa
        ..showMil = settings.showMil
        ..showCmPer100m = settings.showCmPer100m
        ..showInPer100yd = settings.showInPer100yd
        ..showInClicks = settings.showInClicks;
    });
  }
}

// ── ReticleSettings notifier ──────────────────────────────────────────────────

class ReticleSettingsNotifier extends AsyncNotifier<ReticleSettings> {
  @override
  ReticleSettings build() =>
      ref.watch(settingsDataProvider.select((s) => s.reticleSettings));

  void _update(void Function(ReticleSettings) mutate) {
    ref.read(settingsDataProvider.notifier).update((s) {
      final copy = s.deepCopy();
      mutate(copy.reticleSettings);
      return copy;
    });
  }

  Future<void> setTargetImage(String? imageId) async {
    _update((r) => r.targetImage = imageId ?? '');
  }

  Future<void> setVerticalAdjustment(double value) async {
    _update((r) => r.verticalAdjustment = value);
  }

  Future<void> setHorizontalAdjustment(double value) async {
    _update((r) => r.horizontalAdjustment = value);
  }

  Future<void> setVerticalAdjustmentUnit(Unit unit) async {
    _update((r) => r.verticalAdjustmentUnitValue = unit);
  }

  Future<void> setHorizontalAdjustmentUnit(Unit unit) async {
    _update((r) => r.horizontalAdjustmentUnitValue = unit);
  }

  Future<void> setVerticalAdjustmentUnitRaw(String name) async {
    _update((r) => r.verticalAdjustmentUnit = name);
  }

  Future<void> setHorizontalAdjustmentUnitRaw(String name) async {
    _update((r) => r.horizontalAdjustmentUnit = name);
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, GeneralSettings>(
      SettingsNotifier.new,
    );

final unitSettingsNotifierProvider =
    AsyncNotifierProvider<UnitSettingsNotifier, UnitSettings>(
      UnitSettingsNotifier.new,
    );

/// Synchronous access — returns defaults while loading.
final unitSettingsProvider = Provider<UnitSettings>((ref) {
  return ref.watch(unitSettingsNotifierProvider).value ?? UnitSettings();
});

final tablesSettingsNotifierProvider =
    AsyncNotifierProvider<TablesSettingsNotifier, TablesSettings>(
      TablesSettingsNotifier.new,
    );

/// Synchronous access to TablesSettings — returns defaults while loading.
final tablesSettingsProvider = Provider<TablesSettings>((ref) {
  return ref.watch(tablesSettingsNotifierProvider).value ?? TablesSettings();
});

final reticleSettingsNotifierProvider =
    AsyncNotifierProvider<ReticleSettingsNotifier, ReticleSettings>(
      ReticleSettingsNotifier.new,
    );

/// Synchronous access to ReticleSettings — returns defaults while loading.
final reticleSettingsProvider = Provider<ReticleSettings>((ref) {
  return ref.watch(reticleSettingsNotifierProvider).value ?? ReticleSettings();
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).value?.flutterThemeMode ??
      ThemeMode.system;
});

/// Returns the user-selected [Locale] from settings, or null to fall back
/// to the system locale (handled by [MaterialApp.localeResolutionCallback]).
final localeProvider = Provider<Locale?>((ref) {
  final code = ref.watch(settingsProvider).value?.languageCode ?? '';
  return code.isNotEmpty ? Locale(code) : null;
});

/// Returns [AppLocalizations] for use in Notifiers (no BuildContext available).
/// Resolves: user setting → system locale → 'en' fallback.
final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  final userLocale = ref.watch(localeProvider);
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final locale = userLocale ?? systemLocale;
  try {
    return lookupAppLocalizations(locale);
  } catch (_) {
    return lookupAppLocalizations(const Locale('en'));
  }
});
