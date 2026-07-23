import 'dart:async';
import 'dart:math' as math;

import 'package:dart_bclibc/bclibc.dart' as bclibc;
import 'package:dart_bclibc/unit.dart';
import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebalistyka/core/extensions/profile_extensions.dart';
import 'package:ebalistyka/core/extensions/settings_extensions.dart';
import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/core/formatting/unit_formatter.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';
import 'package:ebalistyka/core/providers/app_state_provider.dart';
import 'package:ebalistyka/core/providers/formatter_provider.dart';
import 'package:ebalistyka/core/providers/reticle_provider.dart';
import 'package:ebalistyka/core/providers/service_providers.dart';
import 'package:ebalistyka/core/providers/settings_provider.dart';
import 'package:ebalistyka/core/providers/shot_conditions_provider.dart';
import 'package:ebalistyka/core/providers/shot_context_provider.dart';
import 'package:ebalistyka/core/services/ballistics_service.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/empty_state.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import 'home_builders.dart';
import 'home_ui_state.dart';

export 'home_ui_state.dart';

// ── ViewModel ─────────────────────────────────────────────────────────────────

class HomeViewModel extends AsyncNotifier<HomeUiState> {
  @override
  Future<HomeUiState> build() async {
    // Every dependency below is `ref.watch`ed (not a manual `ref.listen` +
    // `state =`/`_recalculate()`), so Riverpod's own dependency tracking
    // re-runs this whole `build()` — once, in an orderly single-flight
    // way — whenever any of them change. That's what fixes two real bugs
    // the old shape had: (1) a `state =` write made synchronously inside
    // `build()` (possible with `ref.listen(..., fireImmediately: true)`
    // if the watched provider already had a value) got silently clobbered
    // back to whatever `build()` itself returned, the moment build()'s
    // own Future resolved; (2) `build()` computing its own initial result
    // *and* a `fireImmediately` listener independently reacting to the
    // exact same first-resolution of `shotContextProvider` meant the
    // (expensive) ballistics calculation ran twice on startup.
    //
    // `GeneralSettings` is the one exception, kept as a manual `ref.listen`
    // — most of its fields (theme, language, ...) don't affect this
    // calculation at all, so a plain `ref.watch` would rebuild on every
    // unrelated settings change. `ref.invalidateSelf()` schedules a fresh
    // `build()` only when `generalNeedsRecalc` says something that
    // actually matters changed, and — unlike calling `_recalculate()`
    // directly — doesn't create a second computation racing against this
    // one; it just marks the provider dirty for Riverpod's own scheduler.
    ref.listen<AsyncValue<GeneralSettings>>(settingsProvider, (prev, next) {
      if (!next.hasValue) return;
      if (generalNeedsRecalc(prev?.value, next.value!)) {
        ref.invalidateSelf();
      }
    });

    final ctx = await ref.watch(shotContextProvider.future);
    if (ctx == null) {
      return const HomeUiNoData(type: EmptyStateType.noProfile);
    }
    final profile = ctx.profile;
    final conditions = ctx.conditions;

    if (!profile.isReadyForCalculation) {
      return HomeUiNoData(
        type: missingProfileDataType(profile),
        profileName: profile.name,
      );
    }

    final settings = await ref.watch(settingsProvider.future);
    final units = ref.watch(unitSettingsProvider);
    final reticle = ref.watch(reticleSettingsProvider);
    final formatter = ref.watch(unitFormatterProvider);
    final l10n = ref.watch(appLocalizationsProvider);

    try {
      final chartStep = settings.homeChartDistanceStep > 0
          ? settings.homeChartDistanceStep
          : FC.distanceStep.minRaw;
      final tableStep = settings.homeTableDistanceStep > 0
          ? settings.homeTableDistanceStep
          : FC.distanceStep.minRaw;
      final opts = TargetCalcOptions(
        targetDistM: conditions.distanceMeter,
        trajectoryEndM: conditions.distanceMeter + 2 * tableStep,
        stepM: math.min(chartStep, tableStep),
        tableStepM: tableStep,
      );

      final result = await ref
          .read(ballisticsServiceProvider)
          .calculateForTarget(profile, conditions, opts);

      return await _buildReadyState(
        profile: profile,
        conditions: conditions,
        settings: settings,
        reticle: reticle,
        units: units,
        formatter: formatter,
        result: result,
        l10n: l10n,
      );
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return HomeUiError(e.toString());
    }
  }

  void selectChartPoint(int index) {
    final current = state.value;
    if (current is! HomeUiReady) return;
    final point = current.chartState.chartData.pointAt(index);
    if (point == null) return;

    final info = buildPointInfo(point, ref.read(unitFormatterProvider));

    state = AsyncData(
      HomeUiReady(
        profileName: current.profileName,
        weaponName: current.weaponName,
        ammoName: current.ammoName,
        conditionsState: current.conditionsState,
        reticleState: current.reticleState,
        tableData: current.tableData,
        chartState: current.chartState.withSelection(info, index),
      ),
    );
  }

  Future<void> updateWindDirection(double degrees) async {
    await ref
        .read(shotConditionsProvider.notifier)
        .updateWindDirection(degrees);
  }

  Future<void> updateWindSpeed(double rawMps) async {
    await ref.read(shotConditionsProvider.notifier).updateWindSpeed(rawMps);
  }

  Future<void> updateLookAngle(double degrees) async {
    await ref.read(shotConditionsProvider.notifier).updateLookAngle(degrees);
  }

  Future<void> updateTargetDistance(double meters) async {
    await ref.read(shotConditionsProvider.notifier).updateDistance(meters);
  }

  Future<void> updateReticleAdjustments({
    required double vRaw,
    required Unit? vUnit,
    required double hRaw,
    required Unit? hUnit,
  }) async {
    final notifier = ref.read(reticleSettingsNotifierProvider.notifier);
    if (vUnit == null) {
      notifier.setVerticalAdjustmentUnitRaw('clicks');
      notifier.setVerticalAdjustment(vRaw);
    } else {
      notifier.setVerticalAdjustmentUnit(vUnit);
      notifier.setVerticalAdjustment(
        Angular(vRaw, FC.adjustment.rawUnit).in_(vUnit),
      );
    }
    if (hUnit == null) {
      notifier.setHorizontalAdjustmentUnitRaw('clicks');
      notifier.setHorizontalAdjustment(hRaw);
    } else {
      notifier.setHorizontalAdjustmentUnit(hUnit);
      notifier.setHorizontalAdjustment(
        Angular(hRaw, FC.adjustment.rawUnit).in_(hUnit),
      );
    }
  }

  Future<void> updateTargetImage(String? imageId) async {
    await ref
        .read(reticleSettingsNotifierProvider.notifier)
        .setTargetImage(imageId);
  }

  Future<void> updateSightReticleImage(String? imageId) async {
    final ctx = ref.read(shotContextProvider).value;
    if (ctx == null) return;
    final sight = ctx.profile.sight.deepCopy()..reticleImage = imageId ?? '';
    await ref
        .read(appStateProvider.notifier)
        .setProfileSight(ctx.profile.uuid, sight);
  }

  Future<void> updateSightClicks({
    required double vRaw,
    required Unit vUnit,
    required double hRaw,
    required Unit hUnit,
  }) async {
    final ctx = ref.read(shotContextProvider).value;
    if (ctx == null) return;
    final sight = ctx.profile.sight.deepCopy()
      ..verticalClickUnitValue = vUnit
      ..verticalClick = Angular(vRaw, FC.adjustment.rawUnit).in_(vUnit)
      ..horizontalClickUnitValue = hUnit
      ..horizontalClick = Angular(hRaw, FC.adjustment.rawUnit).in_(hUnit);
    await ref
        .read(appStateProvider.notifier)
        .setProfileSight(ctx.profile.uuid, sight);
  }

  // ── Ready state builder ────────────────────────────────────────────────────

  Future<HomeUiReady> _buildReadyState({
    required Profile profile,
    required ShootingConditions conditions,
    required GeneralSettings settings,
    required ReticleSettings reticle,
    required UnitSettings units,
    required UnitFormatter formatter,
    required BallisticsResult result,
    required AppLocalizations l10n,
  }) async {
    final hit = result.hitResult;
    final targetM = conditions.distanceMeter;

    final conditionsState = HomeConditionsUiState(
      windAngleDeg: conditions.windDirectionDeg,
      tempDisplay: formatter.temperature(conditions.temperature),
      altDisplay: formatter.distance(conditions.altitude),
      pressDisplay: formatter.pressure(conditions.pressure),
      humidDisplay: formatter.humidity(
        Ratio(conditions.humidityFrac, Unit.fraction),
      ),
      targetDistanceM: targetM,
    );

    final cartridgeInfoLine = buildCartridgeInfoLine(
      profile,
      conditions,
      formatter,
      l10n,
    );

    final vAdjMil = reticle.verticalAdjInClicks
        ? reticle.verticalAdjustment
        : reticle.verticalAdjustment.convert(
            reticle.verticalAdjustmentUnitValue,
            Unit.mil,
          );
    final hAdjMil = reticle.horizontalAdjInClicks
        ? reticle.horizontalAdjustment
        : reticle.horizontalAdjustment.convert(
            reticle.horizontalAdjustmentUnitValue,
            Unit.mil,
          );

    final sight = profile.sight;
    final horizontalClickSizeMil = Angular(
      sight.horizontalClick,
      sight.horizontalClickUnitValue,
    ).in_(Unit.mil);
    final verticalClickSizeMil = Angular(
      sight.verticalClick,
      sight.verticalClickUnitValue,
    ).in_(Unit.mil);
    final adjustedMessageLine = buildAdjustedMessageLine(
      reticle,
      vClickSizeMil: verticalClickSizeMil,
      hClickSizeMil: horizontalClickSizeMil,
      l10n: l10n,
    );

    final ammo = profile.ammo;
    final zeroOffsetYMil = Angular(
      ammo.zero.offsetY,
      ammo.zeroOffsetYUnitValue,
    ).in_(Unit.mil);
    final zeroOffsetXMil = Angular(
      ammo.zero.offsetX,
      ammo.zeroOffsetXUnitValue,
    ).in_(Unit.mil);
    final zeroOffsetMessageLine = buildZeroOffsetMessageLine(
      zeroOffsetYMil: zeroOffsetYMil,
      zeroOffsetXMil: zeroOffsetXMil,
      zeroOffsetYUnit: ammo.zeroOffsetYUnitValue,
      zeroOffsetXUnit: ammo.zeroOffsetXUnitValue,
    );

    final elevMil =
        Angular.radian(result.holdRad).in_(Unit.mil) + vAdjMil + zeroOffsetYMil;
    final targetPoint = hit.trajectory.isNotEmpty
        ? hit.getAtDistance(Distance.meter(targetM))
        : null;
    final windMil =
        (targetPoint?.windageAngle.in_(Unit.mil) ?? 0.0) +
        hAdjMil +
        zeroOffsetXMil;

    final adjustmentData = buildAdjustment(
      hit,
      targetM,
      Angular(elevMil, Unit.mil),
      Angular(windMil, Unit.mil),
      horizontalClickSizeMil,
      verticalClickSizeMil,
      settings,
      l10n,
    );

    final targetSvg = await ref
        .read(targetSvgProvider(reticle.targetImage).future)
        .catchError((_) => '');
    final targetSizeMil = parseMilWidth(targetSvg);
    final targetSizeMilAtDistance = targetM > 0
        ? targetSizeMil * 100 / targetM
        : 0.0;

    final reticleState = ReticleUiState(
      reticleId: profile.sight.reticleImage.isNotEmpty
          ? profile.sight.reticleImage
          : null,
      targetId: reticle.targetImage,
      targetSizeMilAtDistance: targetSizeMilAtDistance,
      adjustedMessageLine: adjustedMessageLine,
      zeroOffsetMessageLine: zeroOffsetMessageLine,
      cartridgeInfoLine: cartridgeInfoLine,
      adjustment: adjustmentData,
      adjustmentFormat: settings.adjustmentDisplayFormat,
      adjustmentElevMil: elevMil,
      adjustmentWindMil: windMil,
    );

    final tableData = buildHomeTable(
      hit,
      targetM,
      result.zeroElevationRad,
      result.tableHolds,
      settings,
      units,
      formatter,
      l10n,
    );
    final chartData = buildChartData(hit, targetM, settings);
    final autoIndex = closestIndex(chartData.points, targetM);
    final autoInfo = autoIndex == null
        ? null
        : buildPointInfo(chartData.points[autoIndex], formatter);

    return HomeUiReady(
      profileName: profile.name,
      weaponName: profile.weapon.name,
      ammoName: profile.ammo.name,
      conditionsState: conditionsState,
      reticleState: reticleState,
      tableData: tableData,
      chartState: HomeChartUiState(
        chartData: chartData,
        selectedPointInfo: autoInfo,
        selectedChartIndex: autoIndex,
        lookAngleRad: conditions.lookAngleRad,
      ),
    );
  }
}

final homeVmProvider = AsyncNotifierProvider<HomeViewModel, HomeUiState>(
  HomeViewModel.new,
);
