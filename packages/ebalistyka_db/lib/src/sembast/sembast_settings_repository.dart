import 'package:ebalistyka_db/src/entities.dart';
import 'package:ebalistyka_db/src/export/conditions_export.dart';
import 'package:ebalistyka_db/src/export/general_settings_export.dart';
import 'package:ebalistyka_db/src/export/reticle_settings_export.dart';
import 'package:ebalistyka_db/src/export/tables_settings_export.dart';
import 'package:ebalistyka_db/src/export/unit_settings_export.dart';
import 'package:ebalistyka_db/src/repository.dart';
import 'package:sembast/sembast.dart';

// Uses ownerId as the record key — one settings record per owner.
class SembastSettingsRepository implements ISettingsRepository {
  final Database _db;

  final _generalStore = intMapStoreFactory.store('general_settings');
  final _unitStore = intMapStoreFactory.store('unit_settings');
  final _tablesStore = intMapStoreFactory.store('tables_settings');
  final _reticleStore = intMapStoreFactory.store('reticle_settings');
  final _conditionsStore = intMapStoreFactory.store('shooting_conditions');
  final _convertorsStore = intMapStoreFactory.store('convertors_state');

  SembastSettingsRepository(this._db);

  // ── GeneralSettings ───────────────────────────────────────────────────────────

  @override
  Future<GeneralSettings> loadOrCreateGeneralSettings(int ownerId) async {
    final map = await _generalStore.record(ownerId).get(_db);
    if (map != null) return _generalFromMap(ownerId, map);
    final s = GeneralSettings()..id = ownerId;
    await _generalStore.record(ownerId).put(_db, _generalToMap(s));
    return s;
  }

  @override
  Stream<void> watchGeneralSettings(int ownerId) =>
      _generalStore.record(ownerId).onSnapshot(_db).map((_) => null);

  @override
  Future<void> saveGeneralSettings(GeneralSettings s, int ownerId) async {
    await _generalStore.record(ownerId).put(_db, _generalToMap(s));
  }

  @override
  Future<void> restoreGeneralSettings(
      GeneralSettingsExport export, int ownerId) async {
    final updated = export.toEntity()..id = ownerId;
    await _generalStore.record(ownerId).put(_db, _generalToMap(updated));
  }

  Map<String, dynamic> _generalToMap(GeneralSettings s) => {
        'languageCode': s.languageCode,
        'themeMode': s.themeMode,
        'adjustmentDisplayFormatValue': s.adjustmentDisplayFormatValue,
        'homeShowMil': s.homeShowMil,
        'homeShowMrad': s.homeShowMrad,
        'homeShowMoa': s.homeShowMoa,
        'homeShowCmPer100m': s.homeShowCmPer100m,
        'homeShowInPer100yd': s.homeShowInPer100yd,
        'homeShowInClicks': s.homeShowInClicks,
        'homeChartDistanceStep': s.homeChartDistanceStep,
        'homeTableDistanceStep': s.homeTableDistanceStep,
        'homeShowSubsonicTransition': s.homeShowSubsonicTransition,
      };

  GeneralSettings _generalFromMap(int id, Map<String, dynamic> m) =>
      GeneralSettings()
        ..id = id
        ..languageCode = m['languageCode'] as String? ?? 'en'
        ..themeMode = m['themeMode'] as String? ?? 'system'
        ..adjustmentDisplayFormatValue =
            m['adjustmentDisplayFormatValue'] as String? ?? 'arrows'
        ..homeShowMil = m['homeShowMil'] as bool? ?? false
        ..homeShowMrad = m['homeShowMrad'] as bool? ?? false
        ..homeShowMoa = m['homeShowMoa'] as bool? ?? false
        ..homeShowCmPer100m = m['homeShowCmPer100m'] as bool? ?? false
        ..homeShowInPer100yd = m['homeShowInPer100yd'] as bool? ?? false
        ..homeShowInClicks = m['homeShowInClicks'] as bool? ?? false
        ..homeChartDistanceStep =
            (m['homeChartDistanceStep'] as num?)?.toDouble() ?? 10.0
        ..homeTableDistanceStep =
            (m['homeTableDistanceStep'] as num?)?.toDouble() ?? 10.0
        ..homeShowSubsonicTransition =
            m['homeShowSubsonicTransition'] as bool? ?? false;

  // ── UnitSettings ──────────────────────────────────────────────────────────────

  @override
  Future<UnitSettings> loadOrCreateUnitSettings(int ownerId) async {
    final map = await _unitStore.record(ownerId).get(_db);
    if (map != null) return _unitFromMap(ownerId, map);
    final s = UnitSettings()..id = ownerId;
    await _unitStore.record(ownerId).put(_db, _unitToMap(s));
    return s;
  }

  @override
  Stream<void> watchUnitSettings(int ownerId) =>
      _unitStore.record(ownerId).onSnapshot(_db).map((_) => null);

  @override
  Future<void> saveUnitSettings(UnitSettings s, int ownerId) async {
    await _unitStore.record(ownerId).put(_db, _unitToMap(s));
  }

  @override
  Future<void> restoreUnitSettings(
      UnitSettingsExport export, int ownerId) async {
    final updated = export.toEntity()..id = ownerId;
    await _unitStore.record(ownerId).put(_db, _unitToMap(updated));
  }

  Map<String, dynamic> _unitToMap(UnitSettings s) => {
        'angular': s.angular,
        'distance': s.distance,
        'velocity': s.velocity,
        'pressure': s.pressure,
        'temperature': s.temperature,
        'diameter': s.diameter,
        'length': s.length,
        'weight': s.weight,
        'adjustment': s.adjustment,
        'drop': s.drop,
        'energy': s.energy,
        'sightHeight': s.sightHeight,
        'twist': s.twist,
        'barrelLength': s.barrelLength,
        'time': s.time,
        'torque': s.torque,
        'targetSize': s.targetSize,
      };

  UnitSettings _unitFromMap(int id, Map<String, dynamic> m) => UnitSettings()
    ..id = id
    ..angular = m['angular'] as String? ?? 'degree'
    ..distance = m['distance'] as String? ?? 'meter'
    ..velocity = m['velocity'] as String? ?? 'mps'
    ..pressure = m['pressure'] as String? ?? 'hPa'
    ..temperature = m['temperature'] as String? ?? 'celsius'
    ..diameter = m['diameter'] as String? ?? 'inch'
    ..length = m['length'] as String? ?? 'inch'
    ..weight = m['weight'] as String? ?? 'grain'
    ..adjustment = m['adjustment'] as String? ?? 'mil'
    ..drop = m['drop'] as String? ?? 'cm'
    ..energy = m['energy'] as String? ?? 'joule'
    ..sightHeight = m['sightHeight'] as String? ?? 'inch'
    ..twist = m['twist'] as String? ?? 'inch'
    ..barrelLength = m['barrelLength'] as String? ?? 'inch'
    ..time = m['time'] as String? ?? 'second'
    ..torque = m['torque'] as String? ?? 'newtonMeter'
    ..targetSize = m['targetSize'] as String? ?? 'mil';

  // ── TablesSettings ────────────────────────────────────────────────────────────

  @override
  Future<TablesSettings> loadOrCreateTablesSettings(int ownerId) async {
    final map = await _tablesStore.record(ownerId).get(_db);
    if (map != null) return _tablesFromMap(ownerId, map);
    final s = TablesSettings()..id = ownerId;
    await _tablesStore.record(ownerId).put(_db, _tablesToMap(s));
    return s;
  }

  @override
  Stream<void> watchTablesSettings(int ownerId) =>
      _tablesStore.record(ownerId).onSnapshot(_db).map((_) => null);

  @override
  Future<void> saveTablesSettings(TablesSettings s, int ownerId) async {
    await _tablesStore.record(ownerId).put(_db, _tablesToMap(s));
  }

  @override
  Future<void> restoreTablesSettings(
      TablesSettingsExport export, int ownerId) async {
    final updated = export.toEntity()..id = ownerId;
    await _tablesStore.record(ownerId).put(_db, _tablesToMap(updated));
  }

  Map<String, dynamic> _tablesToMap(TablesSettings s) => {
        'distanceStartMeter': s.distanceStartMeter,
        'distanceEndMeter': s.distanceEndMeter,
        'distanceStepMeter': s.distanceStepMeter,
        'showZeros': s.showZeros,
        'showSubsonicTransition': s.showSubsonicTransition,
        'hiddenCols': s.hiddenCols.toList(),
        'showMil': s.showMil,
        'showMrad': s.showMrad,
        'showMoa': s.showMoa,
        'showCmPer100m': s.showCmPer100m,
        'showInPer100yd': s.showInPer100yd,
        'showInClicks': s.showInClicks,
      };

  TablesSettings _tablesFromMap(int id, Map<String, dynamic> m) =>
      TablesSettings()
        ..id = id
        ..distanceStartMeter =
            (m['distanceStartMeter'] as num?)?.toDouble() ?? 0.0
        ..distanceEndMeter =
            (m['distanceEndMeter'] as num?)?.toDouble() ?? 2000.0
        ..distanceStepMeter =
            (m['distanceStepMeter'] as num?)?.toDouble() ?? 100.0
        ..showZeros = m['showZeros'] as bool? ?? true
        ..showSubsonicTransition =
            m['showSubsonicTransition'] as bool? ?? true
        ..hiddenCols =
            (m['hiddenCols'] as List?)?.cast<String>().toList() ?? []
        ..showMil = m['showMil'] as bool? ?? false
        ..showMrad = m['showMrad'] as bool? ?? false
        ..showMoa = m['showMoa'] as bool? ?? false
        ..showCmPer100m = m['showCmPer100m'] as bool? ?? false
        ..showInPer100yd = m['showInPer100yd'] as bool? ?? false
        ..showInClicks = m['showInClicks'] as bool? ?? false;

  // ── ReticleSettings ───────────────────────────────────────────────────────────

  @override
  Future<ReticleSettings> loadOrCreateReticleSettings(int ownerId) async {
    final map = await _reticleStore.record(ownerId).get(_db);
    if (map != null) return _reticleFromMap(ownerId, map);
    final s = ReticleSettings()..id = ownerId;
    await _reticleStore.record(ownerId).put(_db, _reticleToMap(s));
    return s;
  }

  @override
  Stream<void> watchReticleSettings(int ownerId) =>
      _reticleStore.record(ownerId).onSnapshot(_db).map((_) => null);

  @override
  Future<void> saveReticleSettings(ReticleSettings s, int ownerId) async {
    await _reticleStore.record(ownerId).put(_db, _reticleToMap(s));
  }

  Map<String, dynamic> _reticleToMap(ReticleSettings s) => {
        'verticalAdjustment': s.verticalAdjustment,
        'verticalAdjustmentUnit': s.verticalAdjustmentUnit,
        'horizontalAdjustment': s.horizontalAdjustment,
        'horizontalAdjustmentUnit': s.horizontalAdjustmentUnit,
        'targetImage': s.targetImage,
      };

  ReticleSettings _reticleFromMap(int id, Map<String, dynamic> m) =>
      ReticleSettings()
        ..id = id
        ..verticalAdjustment =
            (m['verticalAdjustment'] as num?)?.toDouble() ?? 0.0
        ..verticalAdjustmentUnit =
            m['verticalAdjustmentUnit'] as String? ?? 'mil'
        ..horizontalAdjustment =
            (m['horizontalAdjustment'] as num?)?.toDouble() ?? 0.0
        ..horizontalAdjustmentUnit =
            m['horizontalAdjustmentUnit'] as String? ?? 'mil'
        ..targetImage = m['targetImage'] as String?;

  // ── ShootingConditions ────────────────────────────────────────────────────────

  @override
  Future<ShootingConditions> loadOrCreateShootingConditions(
      int ownerId) async {
    final map = await _conditionsStore.record(ownerId).get(_db);
    if (map != null) return _conditionsFromMap(ownerId, map);
    final s = ShootingConditions()
      ..id = ownerId
      ..humidityFrac = 0.5
      ..distanceMeter = 450.0;
    await _conditionsStore.record(ownerId).put(_db, _conditionsToMap(s));
    return s;
  }

  @override
  Stream<void> watchShootingConditions(int ownerId) =>
      _conditionsStore.record(ownerId).onSnapshot(_db).map((_) => null);

  @override
  Future<void> saveShootingConditions(
      ShootingConditions s, int ownerId) async {
    await _conditionsStore.record(ownerId).put(_db, _conditionsToMap(s));
  }

  @override
  Future<void> restoreShootingConditions(
      ConditionsExport export, int ownerId) async {
    final updated = export.toEntity()..id = ownerId;
    await _conditionsStore.record(ownerId).put(_db, _conditionsToMap(updated));
  }

  Map<String, dynamic> _conditionsToMap(ShootingConditions s) => {
        'distanceMeter': s.distanceMeter,
        'lookAngleRad': s.lookAngleRad,
        'altitudeMeter': s.altitudeMeter,
        'temperatureC': s.temperatureC,
        'pressurehPa': s.pressurehPa,
        'humidityFrac': s.humidityFrac,
        'powderTemperatureC': s.powderTemperatureC,
        'usePowderSensitivity': s.usePowderSensitivity,
        'useDiffPowderTemp': s.useDiffPowderTemp,
        'useCoriolis': s.useCoriolis,
        'latitudeDeg': s.latitudeDeg,
        'azimuthDeg': s.azimuthDeg,
        'windDirectionDeg': s.windDirectionDeg,
        'windSpeedMps': s.windSpeedMps,
      };

  ShootingConditions _conditionsFromMap(int id, Map<String, dynamic> m) =>
      ShootingConditions()
        ..id = id
        ..distanceMeter = (m['distanceMeter'] as num?)?.toDouble() ?? 100.0
        ..lookAngleRad = (m['lookAngleRad'] as num?)?.toDouble() ?? 0.0
        ..altitudeMeter = (m['altitudeMeter'] as num?)?.toDouble() ?? 0.0
        ..temperatureC = (m['temperatureC'] as num?)?.toDouble() ?? 15.0
        ..pressurehPa = (m['pressurehPa'] as num?)?.toDouble() ?? 1013.25
        ..humidityFrac = (m['humidityFrac'] as num?)?.toDouble() ?? 0.0
        ..powderTemperatureC =
            (m['powderTemperatureC'] as num?)?.toDouble() ?? 15.0
        ..usePowderSensitivity = m['usePowderSensitivity'] as bool? ?? false
        ..useDiffPowderTemp = m['useDiffPowderTemp'] as bool? ?? false
        ..useCoriolis = m['useCoriolis'] as bool? ?? false
        ..latitudeDeg = (m['latitudeDeg'] as num?)?.toDouble() ?? 0.0
        ..azimuthDeg = (m['azimuthDeg'] as num?)?.toDouble() ?? 0.0
        ..windDirectionDeg = (m['windDirectionDeg'] as num?)?.toDouble() ?? 0.0
        ..windSpeedMps = (m['windSpeedMps'] as num?)?.toDouble() ?? 0.0;

  // ── ConvertorsState ───────────────────────────────────────────────────────────

  @override
  Future<ConvertorsState> loadOrCreateConvertorsState(int ownerId) async {
    final map = await _convertorsStore.record(ownerId).get(_db);
    if (map != null) return _convertorsFromMap(ownerId, map);
    final s = ConvertorsState()..id = ownerId;
    await _convertorsStore.record(ownerId).put(_db, _convertorsToMap(s));
    return s;
  }

  @override
  Stream<void> watchConvertorsState(int ownerId) =>
      _convertorsStore.record(ownerId).onSnapshot(_db).map((_) => null);

  @override
  Future<void> saveConvertorsState(ConvertorsState s, int ownerId) async {
    await _convertorsStore.record(ownerId).put(_db, _convertorsToMap(s));
  }

  Map<String, dynamic> _convertorsToMap(ConvertorsState s) => {
        'lengthValueInch': s.lengthValueInch,
        'lengthLastUnit': s.lengthLastUnit,
        'weightValueGrain': s.weightValueGrain,
        'weightLastUnit': s.weightLastUnit,
        'pressureValueMmHg': s.pressureValueMmHg,
        'pressureLastUnit': s.pressureLastUnit,
        'temperatureValueF': s.temperatureValueF,
        'temperatureLastUnit': s.temperatureLastUnit,
        'torqueValueNewtonMeter': s.torqueValueNewtonMeter,
        'torqueLastUnit': s.torqueLastUnit,
        'anglesConvDistanceValueMeter': s.anglesConvDistanceValueMeter,
        'anglesConvDistanceLastUnit': s.anglesConvDistanceLastUnit,
        'anglesConvAngularValueMil': s.anglesConvAngularValueMil,
        'anglesConvAngularLastUnit': s.anglesConvAngularLastUnit,
        'anglesConvOutputLastUnit': s.anglesConvOutputLastUnit,
        'velocityValueMps': s.velocityValueMps,
        'velocityLastUnit': s.velocityLastUnit,
        'velocityMachInputValue': s.velocityMachInputValue,
        'velocityMachUseCustomAtmo': s.velocityMachUseCustomAtmo,
        'velocityAtmoTemperatureC': s.velocityAtmoTemperatureC,
        'velocityAtmoPressureHPa': s.velocityAtmoPressureHPa,
        'velocityAtmoHumidityFrac': s.velocityAtmoHumidityFrac,
        'velocityAtmoAltitudeMeter': s.velocityAtmoAltitudeMeter,
        'distanceConvTargetSizeInch': s.distanceConvTargetSizeInch,
        'distanceConvTargetSizeUnit': s.distanceConvTargetSizeUnit,
        'distanceConvTargetSizeAngularMil': s.distanceConvTargetSizeAngularMil,
        'distanceConvTargetSizeAngularUnit': s.distanceConvTargetSizeAngularUnit,
      };

  ConvertorsState _convertorsFromMap(int id, Map<String, dynamic> m) =>
      ConvertorsState()
        ..id = id
        ..lengthValueInch = (m['lengthValueInch'] as num?)?.toDouble() ?? 100.0
        ..lengthLastUnit = m['lengthLastUnit'] as String? ?? 'inch'
        ..weightValueGrain =
            (m['weightValueGrain'] as num?)?.toDouble() ?? 100.0
        ..weightLastUnit = m['weightLastUnit'] as String? ?? 'grain'
        ..pressureValueMmHg =
            (m['pressureValueMmHg'] as num?)?.toDouble() ?? 1013.0
        ..pressureLastUnit = m['pressureLastUnit'] as String? ?? 'hPa'
        ..temperatureValueF =
            (m['temperatureValueF'] as num?)?.toDouble() ?? 68.0
        ..temperatureLastUnit = m['temperatureLastUnit'] as String? ?? 'celsius'
        ..torqueValueNewtonMeter =
            (m['torqueValueNewtonMeter'] as num?)?.toDouble() ?? 100.0
        ..torqueLastUnit = m['torqueLastUnit'] as String? ?? 'newtonMeter'
        ..anglesConvDistanceValueMeter =
            (m['anglesConvDistanceValueMeter'] as num?)?.toDouble() ?? 100.0
        ..anglesConvDistanceLastUnit =
            m['anglesConvDistanceLastUnit'] as String? ?? 'meter'
        ..anglesConvAngularValueMil =
            (m['anglesConvAngularValueMil'] as num?)?.toDouble() ?? 1.0
        ..anglesConvAngularLastUnit =
            m['anglesConvAngularLastUnit'] as String? ?? 'mil'
        ..anglesConvOutputLastUnit =
            m['anglesConvOutputLastUnit'] as String? ?? 'centimeter'
        ..velocityValueMps =
            (m['velocityValueMps'] as num?)?.toDouble() ?? 300.0
        ..velocityLastUnit = m['velocityLastUnit'] as String? ?? 'mps'
        ..velocityMachInputValue =
            (m['velocityMachInputValue'] as num?)?.toDouble() ?? 0.881
        ..velocityMachUseCustomAtmo =
            m['velocityMachUseCustomAtmo'] as bool? ?? false
        ..velocityAtmoTemperatureC =
            (m['velocityAtmoTemperatureC'] as num?)?.toDouble() ?? 15.0
        ..velocityAtmoPressureHPa =
            (m['velocityAtmoPressureHPa'] as num?)?.toDouble() ?? 1013.25
        ..velocityAtmoHumidityFrac =
            (m['velocityAtmoHumidityFrac'] as num?)?.toDouble() ?? 0.0
        ..velocityAtmoAltitudeMeter =
            (m['velocityAtmoAltitudeMeter'] as num?)?.toDouble() ?? 0.0
        ..distanceConvTargetSizeInch =
            (m['distanceConvTargetSizeInch'] as num?)?.toDouble() ?? 8.0
        ..distanceConvTargetSizeUnit =
            m['distanceConvTargetSizeUnit'] as String? ?? 'inch'
        ..distanceConvTargetSizeAngularMil =
            (m['distanceConvTargetSizeAngularMil'] as num?)?.toDouble() ?? 1.0
        ..distanceConvTargetSizeAngularUnit =
            m['distanceConvTargetSizeAngularUnit'] as String? ?? 'mil';
}
