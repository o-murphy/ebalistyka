import 'package:bclibc_ffi/bclibc.dart';
import 'package:bclibc_ffi/unit.dart';
import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:ebalistyka/core/extensions/settings_extensions.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

// ── GeneralSettings notifier ──────────────────────────────────────────────────

class SettingsNotifier extends AsyncNotifier<GeneralSettings> {
  ISettingsRepository get _repo => ref.read(settingsRepositoryProvider);
  int get _ownerId => ref.read(ownerIdProvider);

  @override
  Future<GeneralSettings> build() async {
    final ownerId = _ownerId;

    void reload() {
      _repo.loadOrCreateGeneralSettings(ownerId).then((s) => state = AsyncData(s));
    }

    final subscription =
        _repo.watchGeneralSettings(ownerId).listen((_) => reload());
    ref.onDispose(subscription.cancel);

    final s = await _repo.loadOrCreateGeneralSettings(ownerId);
    if (s.languageCode.isEmpty) {
      final systemLocale =
          WidgetsBinding.instance.platformDispatcher.locale;
      final resolved = AppLocalizations.supportedLocales.firstWhere(
        (l) => l.languageCode == systemLocale.languageCode,
        orElse: () => const Locale('en'),
      );
      s.languageCode = resolved.languageCode;
      s.homeShowMil = true;
      s.homeShowMoa = true;
      s.homeShowCmPer100m = true;
      s.homeShowInClicks = true;
      await _repo.saveGeneralSettings(s, ownerId);
    }
    return s;
  }

  Future<void> restore(GeneralSettingsExport export) async {
    await _repo.restoreGeneralSettings(export, _ownerId);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final s = state.value ?? await _repo.loadOrCreateGeneralSettings(_ownerId);
    s.flutterThemeMode = mode;
    await _repo.saveGeneralSettings(s, _ownerId);
  }

  Future<void> setLanguage(String code) async {
    final s = state.value ?? await _repo.loadOrCreateGeneralSettings(_ownerId);
    s.languageCode = code;
    await _repo.saveGeneralSettings(s, _ownerId);
  }

  Future<void> setAdjustmentFormat(AdjustmentDisplayFormat format) async {
    final s = state.value ?? await _repo.loadOrCreateGeneralSettings(_ownerId);
    s.adjustmentDisplayFormat = format;
    await _repo.saveGeneralSettings(s, _ownerId);
  }

  Future<void> setChartDistanceStep(double step) async {
    final s = state.value ?? await _repo.loadOrCreateGeneralSettings(_ownerId);
    s.homeChartDistanceStep = step;
    await _repo.saveGeneralSettings(s, _ownerId);
  }

  Future<void> setHomeTableStep(double step) async {
    final s = state.value ?? await _repo.loadOrCreateGeneralSettings(_ownerId);
    s.homeTableDistanceStep = step;
    await _repo.saveGeneralSettings(s, _ownerId);
  }

  Future<void> setAdjustmentToggle(String key, bool value) async {
    final s = state.value ?? await _repo.loadOrCreateGeneralSettings(_ownerId);
    switch (key) {
      case 'showMrad':
        s.homeShowMrad = value;
        break;
      case 'showMoa':
        s.homeShowMoa = value;
        break;
      case 'showMil':
        s.homeShowMil = value;
        break;
      case 'showCmPer100m':
        s.homeShowCmPer100m = value;
        break;
      case 'showInPer100yd':
        s.homeShowInPer100yd = value;
        break;
      case 'subsonicTransition':
        s.homeShowSubsonicTransition = value;
        break;
      case 'showInClicks':
        s.homeShowInClicks = value;
        break;
    }
    await _repo.saveGeneralSettings(s, _ownerId);
  }
}

// ── UnitSettings notifier ─────────────────────────────────────────────────────

class UnitSettingsNotifier extends AsyncNotifier<UnitSettings> {
  ISettingsRepository get _repo => ref.read(settingsRepositoryProvider);
  int get _ownerId => ref.read(ownerIdProvider);

  @override
  Future<UnitSettings> build() async {
    final ownerId = _ownerId;

    void reload() {
      _repo.loadOrCreateUnitSettings(ownerId).then((s) => state = AsyncData(s));
    }

    final subscription =
        _repo.watchUnitSettings(ownerId).listen((_) => reload());
    ref.onDispose(subscription.cancel);

    return _repo.loadOrCreateUnitSettings(ownerId);
  }

  Future<void> restore(UnitSettingsExport export) async {
    await _repo.restoreUnitSettings(export, _ownerId);
  }

  Future<void> setUnit(String key, Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateUnitSettings(_ownerId);
    switch (key) {
      case 'velocity':
        s.velocityUnit = unit;
        break;
      case 'distance':
        s.distanceUnit = unit;
        break;
      case 'sightHeight':
        s.sightHeightUnit = unit;
        break;
      case 'pressure':
        s.pressureUnit = unit;
        break;
      case 'temperature':
        s.temperatureUnit = unit;
        break;
      case 'diameter':
        s.diameterUnit = unit;
        break;
      case 'length':
        s.lengthUnit = unit;
        break;
      case 'weight':
        s.weightUnit = unit;
        break;
      case 'drop':
        s.dropUnit = unit;
        break;
      case 'energy':
        s.energyUnit = unit;
        break;
      case 'torque':
        s.torqueUnit = unit;
        break;
      case 'targetSize':
        s.targetSizeUnit = unit;
        break;
      case 'angular':
        s.angularUnit = unit;
        break;
    }
    await _repo.saveUnitSettings(s, _ownerId);
  }
}

// ── TablesSettings notifier ───────────────────────────────────────────────────

class TablesSettingsNotifier extends AsyncNotifier<TablesSettings> {
  ISettingsRepository get _repo => ref.read(settingsRepositoryProvider);
  int get _ownerId => ref.read(ownerIdProvider);

  @override
  Future<TablesSettings> build() async {
    final ownerId = _ownerId;

    void reload() {
      _repo
          .loadOrCreateTablesSettings(ownerId)
          .then((s) => state = AsyncData(s));
    }

    final subscription =
        _repo.watchTablesSettings(ownerId).listen((_) => reload());
    ref.onDispose(subscription.cancel);

    final s = await _repo.loadOrCreateTablesSettings(ownerId);
    if (s.distanceEndMeter == 2000.0 && !s.showMil && !s.showMoa) {
      s.distanceEndMeter = 1000.0;
      s.showMil = true;
      s.showMoa = true;
      s.showCmPer100m = true;
      s.showInClicks = true;
      await _repo.saveTablesSettings(s, ownerId);
    }
    return s;
  }

  Future<void> restore(TablesSettingsExport export) async {
    await _repo.restoreTablesSettings(export, _ownerId);
  }

  Future<void> saveSettings(TablesSettings settings) async {
    final s = state.value ?? await _repo.loadOrCreateTablesSettings(_ownerId);
    s.distanceStartMeter = settings.distanceStartMeter;
    s.distanceEndMeter = settings.distanceEndMeter;
    s.distanceStepMeter = settings.distanceStepMeter;
    s.showZeros = settings.showZeros;
    s.showSubsonicTransition = settings.showSubsonicTransition;
    s.hiddenCols = List<String>.from(settings.hiddenCols);
    s.showMrad = settings.showMrad;
    s.showMoa = settings.showMoa;
    s.showMil = settings.showMil;
    s.showCmPer100m = settings.showCmPer100m;
    s.showInPer100yd = settings.showInPer100yd;
    s.showInClicks = settings.showInClicks;
    await _repo.saveTablesSettings(s, _ownerId);
  }
}

// ── ReticleSettings notifier ──────────────────────────────────────────────────

class ReticleSettingsNotifier extends AsyncNotifier<ReticleSettings> {
  ISettingsRepository get _repo => ref.read(settingsRepositoryProvider);
  int get _ownerId => ref.read(ownerIdProvider);

  @override
  Future<ReticleSettings> build() async {
    final ownerId = _ownerId;

    void reload() {
      _repo
          .loadOrCreateReticleSettings(ownerId)
          .then((s) => state = AsyncData(s));
    }

    final subscription =
        _repo.watchReticleSettings(ownerId).listen((_) => reload());
    ref.onDispose(subscription.cancel);

    return _repo.loadOrCreateReticleSettings(ownerId);
  }

  Future<void> restore(ReticleSettingsExport export) async {
    final current = state.value ?? await _repo.loadOrCreateReticleSettings(_ownerId);
    final updated = export.toEntity()..id = current.id;
    await _repo.saveReticleSettings(updated, _ownerId);
  }

  Future<void> setTargetImage(String? imageId) async {
    final s = state.value ?? await _repo.loadOrCreateReticleSettings(_ownerId);
    s.targetImage = imageId;
    await _repo.saveReticleSettings(s, _ownerId);
  }

  Future<void> setVerticalAdjustment(double value) async {
    final s = state.value ?? await _repo.loadOrCreateReticleSettings(_ownerId);
    s.verticalAdjustment = value;
    await _repo.saveReticleSettings(s, _ownerId);
  }

  Future<void> setHorizontalAdjustment(double value) async {
    final s = state.value ?? await _repo.loadOrCreateReticleSettings(_ownerId);
    s.horizontalAdjustment = value;
    await _repo.saveReticleSettings(s, _ownerId);
  }

  Future<void> setVerticalAdjustmentUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateReticleSettings(_ownerId);
    s.verticalAdjustmentUnit = unit.name;
    await _repo.saveReticleSettings(s, _ownerId);
  }

  Future<void> setHorizontalAdjustmentUnit(Unit unit) async {
    final s = state.value ?? await _repo.loadOrCreateReticleSettings(_ownerId);
    s.horizontalAdjustmentUnit = unit.name;
    await _repo.saveReticleSettings(s, _ownerId);
  }

  Future<void> setVerticalAdjustmentUnitRaw(String name) async {
    final s = state.value ?? await _repo.loadOrCreateReticleSettings(_ownerId);
    s.verticalAdjustmentUnit = name;
    await _repo.saveReticleSettings(s, _ownerId);
  }

  Future<void> setHorizontalAdjustmentUnitRaw(String name) async {
    final s = state.value ?? await _repo.loadOrCreateReticleSettings(_ownerId);
    s.horizontalAdjustmentUnit = name;
    await _repo.saveReticleSettings(s, _ownerId);
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
