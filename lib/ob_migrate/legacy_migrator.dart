import 'package:ebc_db/ebc_db.dart';
import 'package:ob_dump_reader_flutter/ob_dump_reader_flutter.dart';
import 'package:uuid/uuid.dart';

import 'generated/schema.g.dart' as legacy;

const _uuid = Uuid();

// ObjectBox entity ids — see objectbox-model.json / schema.json.
const _entityAmmo = 1;
const _entityConvertorsState = 2;
const _entityGeneralSettings = 3;
const _entityOwner = 4;
const _entityProfile = 5;
const _entitySight = 6;
const _entityTablesSettings = 7;
const _entityUnitSettings = 8;
const _entityWeapon = 9;
const _entityShootingConditions = 11;
const _entityReticleSettings = 12;

/// Result of decoding the old ObjectBox store and mapping it onto the new
/// `ebc_db` shape. [profiles] has the old active profile (per
/// `Owner.activeProfileId`) at index 0, matching `ProfilesData`'s own
/// "profiles[0] is active" convention. Weapons/ammo/sights that existed in
/// the old app's library (`Owner.weapons`/`.cartridges`/`.sights`) but were
/// never referenced by any old `Profile` have no home in the new schema
/// (`Profile` embeds weapon+ammo+sight directly — there is no standalone
/// library) — they're surfaced here instead of silently dropped, so the
/// caller can warn the user and offer to export them.
class LegacyMigrationResult {
  const LegacyMigrationResult({
    required this.profiles,
    required this.settings,
    required this.orphanedWeapons,
    required this.orphanedAmmo,
    required this.orphanedSights,
    required this.skippedProfileCount,
  });

  final List<Profile> profiles;
  final SettingsData settings;
  final List<Weapon> orphanedWeapons;
  final List<Ammo> orphanedAmmo;
  final List<Sight> orphanedSights;

  /// Old `Profile` rows whose `weaponId`/`sightId`/`ammoId` didn't resolve
  /// to a decoded record (dangling reference) — skipped, not fabricated
  /// with blank data.
  final int skippedProfileCount;
}

/// Decodes every ObjectBox object-data record in [objectboxDir] (a
/// directory containing `data.mdb`, optionally `lock.mdb`) and maps it
/// onto the new `ebc_db` proto types. Pure decode + map — does not touch
/// `profiles.ebcp`/`settings.ebcp` or any provider; the caller decides
/// what to do with the result.
Future<LegacyMigrationResult> migrateLegacyData(String objectboxDir) async {
  legacy.Owner? owner;
  final weapons = <int, legacy.Weapon>{};
  final ammo = <int, legacy.Ammo>{};
  final sights = <int, legacy.Sight>{};
  final profiles = <legacy.Profile>[];
  legacy.GeneralSettings? generalSettings;
  legacy.TablesSettings? tablesSettings;
  legacy.UnitSettings? unitSettings;
  legacy.ShootingConditions? shootingConditions;
  legacy.ConvertorsState? convertorsState;
  legacy.ReticleSettings? reticleSettings;

  await readObjectBoxRecords(objectboxDir, (record) {
    switch (record.entityId) {
      case _entityAmmo:
        ammo[record.objectId] = legacy.Ammo(record.data);
      case _entityConvertorsState:
        convertorsState = legacy.ConvertorsState(record.data);
      case _entityGeneralSettings:
        generalSettings = legacy.GeneralSettings(record.data);
      case _entityOwner:
        owner = legacy.Owner(record.data);
      case _entityProfile:
        profiles.add(legacy.Profile(record.data));
      case _entitySight:
        sights[record.objectId] = legacy.Sight(record.data);
      case _entityTablesSettings:
        tablesSettings = legacy.TablesSettings(record.data);
      case _entityUnitSettings:
        unitSettings = legacy.UnitSettings(record.data);
      case _entityWeapon:
        weapons[record.objectId] = legacy.Weapon(record.data);
      case _entityShootingConditions:
        shootingConditions = legacy.ShootingConditions(record.data);
      case _entityReticleSettings:
        reticleSettings = legacy.ReticleSettings(record.data);
    }
  });

  final usedWeaponIds = <int>{};
  final usedAmmoIds = <int>{};
  final usedSightIds = <int>{};
  final newProfiles = <Profile>[];
  var activeIndex = -1;
  var skippedProfileCount = 0;

  for (final p in profiles) {
    final w = weapons[p.weaponId];
    final a = ammo[p.ammoId];
    final s = sights[p.sightId];
    if (w == null || a == null || s == null) {
      skippedProfileCount++;
      continue;
    }
    usedWeaponIds.add(p.weaponId);
    usedAmmoIds.add(p.ammoId);
    usedSightIds.add(p.sightId);

    if (owner != null && p.id == owner!.activeProfileId) {
      activeIndex = newProfiles.length;
    }
    newProfiles.add(
      Profile(
        uuid: _uuid.v4(),
        name: p.name ?? '',
        weapon: _mapWeapon(w),
        ammo: _mapAmmo(a),
        sight: _mapSight(s),
      ),
    );
  }
  if (activeIndex > 0) {
    final active = newProfiles.removeAt(activeIndex);
    newProfiles.insert(0, active);
  }

  final orphanedWeapons = [
    for (final e in weapons.entries)
      if (!usedWeaponIds.contains(e.key)) _mapWeapon(e.value),
  ];
  final orphanedAmmo = [
    for (final e in ammo.entries)
      if (!usedAmmoIds.contains(e.key)) _mapAmmo(e.value),
  ];
  final orphanedSights = [
    for (final e in sights.entries)
      if (!usedSightIds.contains(e.key)) _mapSight(e.value),
  ];

  return LegacyMigrationResult(
    profiles: newProfiles,
    settings: SettingsData(
      generalSettings: _mapGeneralSettings(generalSettings),
      unitSettings: _mapUnitSettings(unitSettings),
      tablesSettings: _mapTablesSettings(tablesSettings),
      reticleSettings: _mapReticleSettings(reticleSettings),
      convertorsState: _mapConvertorsState(convertorsState),
      shootingConditions: _mapShootingConditions(shootingConditions),
    ),
    orphanedWeapons: orphanedWeapons,
    orphanedAmmo: orphanedAmmo,
    orphanedSights: orphanedSights,
    skippedProfileCount: skippedProfileCount,
  );
}

// ─── Per-type mapping ──────────────────────────────────────────────────────
// Old getter names keep flatc's exact (sometimes quirky) casing —
// `multiBcTableG1Vmps` not `VMps`, `zeroPressurehPa` not `PressureHPa`,
// `zeroOffsetXunit` not `XUnit` — copied verbatim from generated/schema.g.dart.

Weapon _mapWeapon(legacy.Weapon w) => Weapon(
  name: w.name ?? '',
  caliberInch: w.caliberInch > 0 ? w.caliberInch : null,
  caliberName: w.caliberName ?? '',
  twistInch: w.twistInch,
  barrelLengthInch: w.barrelLengthInch > 0 ? w.barrelLengthInch : null,
  zeroElevationRad: w.zeroElevationRad,
  vendor: w.vendor ?? '',
  notes: w.notes ?? '',
  image: w.image ?? '',
);

Sight _mapSight(legacy.Sight s) => Sight(
  name: s.name ?? '',
  focalPlaneValue: s.focalPlaneValue ?? 'ffp',
  sightHeightInch: s.sightHeightInch,
  sightHorizontalOffsetInch: s.sightHorizontalOffsetInch,
  verticalClick: s.verticalClick,
  horizontalClick: s.horizontalClick,
  verticalClickUnit: s.verticalClickUnit ?? 'mil',
  horizontalClickUnit: s.horizontalClickUnit ?? 'mil',
  minMagnification: s.minMagnification,
  maxMagnification: s.maxMagnification,
  reticleImage: s.reticleImage ?? '',
  calibratedMagnification: s.calibratedMagnification > 0
      ? s.calibratedMagnification
      : null,
  vendor: s.vendor ?? '',
  notes: s.notes ?? '',
  image: s.image ?? '',
);

Zero _mapZero(legacy.Ammo a) => Zero(
  distanceMeter: a.zeroDistanceMeter,
  lookAngleRad: a.zeroLookAngleRad,
  altitudeMeter: a.zeroAltitudeMeter,
  temperatureC: a.zeroTemperatureC,
  pressureHPa: a.zeroPressurehPa,
  humidityFrac: a.zeroHumidityFrac,
  useDiffPowderTemperature: a.zeroUseDiffPowderTemperature,
  useCoriolis: a.zeroUseCoriolis,
  powderTemperatureC: a.zeroPowderTemperatureC,
  latitudeDeg: a.zeroLatitudeDeg,
  azimuthDeg: a.zeroAzimuthDeg,
  offsetX: a.zeroOffsetX,
  offsetY: a.zeroOffsetY,
  offsetXUnit: a.zeroOffsetXunit ?? 'mil',
  offsetYUnit: a.zeroOffsetYunit ?? 'mil',
);

/// Zips old parallel-array pairs into the new repeated-message shape.
/// Length mismatch (shouldn't happen — old app never enforced it either,
/// see Phase 7 of the migration doc — but data drifts) truncates to the
/// shorter list rather than throwing.
List<MultiBcPoint> _zipMultiBc(List<double>? vMps, List<double>? bc) {
  if (vMps == null || bc == null) return const [];
  final n = vMps.length < bc.length ? vMps.length : bc.length;
  return [for (var i = 0; i < n; i++) MultiBcPoint(vMps: vMps[i], bc: bc[i])];
}

List<CustomDragPoint> _zipCustomDrag(List<double>? mach, List<double>? cd) {
  if (mach == null || cd == null) return const [];
  final n = mach.length < cd.length ? mach.length : cd.length;
  return [
    for (var i = 0; i < n; i++) CustomDragPoint(mach: mach[i], cd: cd[i]),
  ];
}

List<PowderSensitivityPoint> _zipPowderSensitivity(
  List<double>? tc,
  List<double>? vMps,
) {
  if (tc == null || vMps == null) return const [];
  final n = tc.length < vMps.length ? tc.length : vMps.length;
  return [
    for (var i = 0; i < n; i++)
      PowderSensitivityPoint(tc: tc[i], vMps: vMps[i]),
  ];
}

Ammo _mapAmmo(legacy.Ammo a) => Ammo(
  name: a.name ?? '',
  caliberInch: a.caliberInch > 0 ? a.caliberInch : null,
  weightGrain: a.weightGrain > 0 ? a.weightGrain : null,
  lengthInch: a.lengthInch > 0 ? a.lengthInch : null,
  dragTypeValue: a.dragTypeValue ?? 'g1',
  bcG1: a.bcG1 > 0 ? a.bcG1 : null,
  bcG7: a.bcG7 > 0 ? a.bcG7 : null,
  useMultiBcG1: a.useMultiBcG1,
  useMultiBcG7: a.useMultiBcG7,
  muzzleVelocityMps: a.muzzleVelocityMps > 0 ? a.muzzleVelocityMps : null,
  muzzleVelocityTemperatureC: a.muzzleVelocityTemperatureC,
  usePowderSensitivity: a.usePowderSensitivity,
  powderSensitivityFrac: a.powderSensitivityFrac,
  powderSensitivityTable: _zipPowderSensitivity(
    a.powderSensitivityTc,
    a.powderSensitivityVmps,
  ),
  multiBcTableG1: _zipMultiBc(a.multiBcTableG1Vmps, a.multiBcTableG1Bc),
  multiBcTableG7: _zipMultiBc(a.multiBcTableG7Vmps, a.multiBcTableG7Bc),
  customDragTable: _zipCustomDrag(a.customDragTableMach, a.customDragTableCd),
  zero: _mapZero(a),
  projectileName: a.projectileName ?? '',
  vendor: a.vendor ?? '',
  image: a.image ?? '',
);

GeneralSettings _mapGeneralSettings(legacy.GeneralSettings? g) {
  if (g == null) return GeneralSettings();
  return GeneralSettings(
    languageCode: g.languageCode ?? 'en',
    themeMode: g.themeMode ?? 'system',
    adjustmentDisplayFormatValue: g.adjustmentDisplayFormatValue ?? 'arrows',
    homeShowMil: g.homeShowMil,
    homeShowMrad: g.homeShowMrad,
    homeShowMoa: g.homeShowMoa,
    homeShowCmPer100m: g.homeShowCmPer100m,
    homeShowInPer100yd: g.homeShowInPer100yd,
    homeShowInClicks: g.homeShowInClicks,
    homeChartDistanceStep: g.homeChartDistanceStep,
    homeTableDistanceStep: g.homeTableDistanceStep,
    homeShowSubsonicTransition: g.homeShowSubsonicTransition,
  );
}

TablesSettings _mapTablesSettings(legacy.TablesSettings? t) {
  if (t == null) return TablesSettings();
  return TablesSettings(
    distanceStartMeter: t.distanceStartMeter,
    distanceEndMeter: t.distanceEndMeter,
    distanceStepMeter: t.distanceStepMeter,
    showZeros: t.showZeros,
    showSubsonicTransition: t.showSubsonicTransition,
    hiddenCols: t.hiddenCols ?? const [],
    showMil: t.showMil,
    showMrad: t.showMrad,
    showMoa: t.showMoa,
    showCmPer100m: t.showCmPer100m,
    showInPer100yd: t.showInPer100yd,
    showInClicks: t.showInClicks,
  );
}

UnitSettings _mapUnitSettings(legacy.UnitSettings? u) {
  if (u == null) return UnitSettings();
  return UnitSettings(
    angular: u.angular ?? 'degree',
    distance: u.distance ?? 'meter',
    velocity: u.velocity ?? 'mps',
    pressure: u.pressure ?? 'hPa',
    temperature: u.temperature ?? 'celsius',
    diameter: u.diameter ?? 'inch',
    length: u.length ?? 'inch',
    weight: u.weight ?? 'grain',
    adjustment: u.adjustment ?? 'mil',
    drop: u.drop ?? 'cm',
    energy: u.energy ?? 'joule',
    sightHeight: u.sightHeight ?? 'inch',
    twist: u.twist ?? 'inch',
    barrelLength: u.barrelLength ?? 'inch',
    time: u.time ?? 'second',
    torque: u.torque ?? 'newtonMeter',
    targetSize: u.targetSize ?? 'mil',
  );
}

ShootingConditions _mapShootingConditions(legacy.ShootingConditions? s) {
  if (s == null) return ShootingConditions();
  return ShootingConditions(
    distanceMeter: s.distanceMeter,
    lookAngleRad: s.lookAngleRad,
    altitudeMeter: s.altitudeMeter,
    temperatureC: s.temperatureC,
    pressureHPa: s.pressurehPa,
    humidityFrac: s.humidityFrac,
    powderTemperatureC: s.powderTemperatureC,
    usePowderSensitivity: s.usePowderSensitivity,
    useDiffPowderTemp: s.useDiffPowderTemp,
    useCoriolis: s.useCoriolis,
    latitudeDeg: s.latitudeDeg,
    azimuthDeg: s.azimuthDeg,
    windDirectionDeg: s.windDirectionDeg,
    windSpeedMps: s.windSpeedMps,
  );
}

ReticleSettings _mapReticleSettings(legacy.ReticleSettings? r) {
  if (r == null) return ReticleSettings();
  return ReticleSettings(
    verticalAdjustment: r.verticalAdjustment,
    verticalAdjustmentUnit: r.verticalAdjustmentUnit ?? 'mil',
    horizontalAdjustment: r.horizontalAdjustment,
    horizontalAdjustmentUnit: r.horizontalAdjustmentUnit ?? 'mil',
    targetImage: r.targetImage ?? '',
  );
}

ConvertorsState _mapConvertorsState(legacy.ConvertorsState? c) {
  if (c == null) return ConvertorsState();
  return ConvertorsState(
    length: UnitValue(
      value: c.lengthValueInch,
      lastUnit: c.lengthLastUnit ?? 'inch',
    ),
    weight: UnitValue(
      value: c.weightValueGrain,
      lastUnit: c.weightLastUnit ?? 'grain',
    ),
    // Same unit (mmHg) on both old and new sides — see legacy_migrator.dart
    // header note / docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 5.
    pressure: UnitValue(
      value: c.pressureValueMmHg,
      lastUnit: c.pressureLastUnit ?? 'hPa',
    ),
    // Same unit (Fahrenheit) on both old and new sides.
    temperature: UnitValue(
      value: c.temperatureValueF,
      lastUnit: c.temperatureLastUnit ?? 'celsius',
    ),
    torque: UnitValue(
      value: c.torqueValueNewtonMeter,
      lastUnit: c.torqueLastUnit ?? 'newtonMeter',
    ),
    angles: AnglesConv(
      distanceValueMeter: c.anglesConvDistanceValueMeter,
      distanceLastUnit: c.anglesConvDistanceLastUnit ?? 'meter',
      angularValueMil: c.anglesConvAngularValueMil,
      angularLastUnit: c.anglesConvAngularLastUnit ?? 'mil',
      outputLastUnit: c.anglesConvOutputLastUnit ?? 'centimeter',
    ),
    velocity: VelocityConv(
      valueMps: c.velocityValueMps,
      lastUnit: c.velocityLastUnit ?? 'mps',
      machInputValue: c.velocityMachInputValue,
      machUseCustomAtmo: c.velocityMachUseCustomAtmo,
      atmoTemperatureC: c.velocityAtmoTemperatureC,
      atmoPressureHPa: c.velocityAtmoPressureHpa,
      atmoHumidityFrac: c.velocityAtmoHumidityFrac,
      atmoAltitudeMeter: c.velocityAtmoAltitudeMeter,
    ),
    distanceConvTargetSize: DistanceConvTargetSize(
      sizeInch: c.distanceConvTargetSizeInch,
      sizeUnit: c.distanceConvTargetSizeUnit ?? 'inch',
      sizeAngularMil: c.distanceConvTargetSizeAngularMil,
      sizeAngularUnit: c.distanceConvTargetSizeAngularUnit ?? 'mil',
    ),
  );
}
