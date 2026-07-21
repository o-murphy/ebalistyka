import '../proto/settings.pb.dart' as proto;

// Converts protobuf settings.* messages into the plain snake_case JSON
// shape schema/settings.schema.json (and the nested defs in
// schema/ebcp.schema.json) are written against. Dart protobuf's own
// writeToJsonMap() uses camelCase (proto3 JSON mapping), which wouldn't
// match the schemas' property names, so this is built by hand instead
// (same reason a7p's A7pValidator does its own conversion). Shared by
// SettingsValidator and EbcpValidator so the mapping is written once.

Map<String, dynamic> generalSettingsToJson(proto.GeneralSettings g) => {
  'language_code': g.languageCode,
  'theme_mode': g.themeMode,
  'adjustment_display_format_value': g.adjustmentDisplayFormatValue,
  'home_show_mil': g.homeShowMil,
  'home_show_mrad': g.homeShowMrad,
  'home_show_moa': g.homeShowMoa,
  'home_show_cm_per100m': g.homeShowCmPer100m,
  'home_show_in_per100yd': g.homeShowInPer100yd,
  'home_show_in_clicks': g.homeShowInClicks,
  'home_chart_distance_step': g.homeChartDistanceStep,
  'home_table_distance_step': g.homeTableDistanceStep,
  'home_show_subsonic_transition': g.homeShowSubsonicTransition,
};

Map<String, dynamic> tablesSettingsToJson(proto.TablesSettings t) => {
  'distance_start_meter': t.distanceStartMeter,
  'distance_end_meter': t.distanceEndMeter,
  'distance_step_meter': t.distanceStepMeter,
  'show_zeros': t.showZeros,
  'show_subsonic_transition': t.showSubsonicTransition,
  'hidden_cols': t.hiddenCols,
  'show_mil': t.showMil,
  'show_mrad': t.showMrad,
  'show_moa': t.showMoa,
  'show_cm_per100m': t.showCmPer100m,
  'show_in_per100yd': t.showInPer100yd,
  'show_in_clicks': t.showInClicks,
};

Map<String, dynamic> unitSettingsToJson(proto.UnitSettings u) => {
  'angular': u.angular,
  'distance': u.distance,
  'velocity': u.velocity,
  'pressure': u.pressure,
  'temperature': u.temperature,
  'diameter': u.diameter,
  'length': u.length,
  'weight': u.weight,
  'adjustment': u.adjustment,
  'drop': u.drop,
  'energy': u.energy,
  'sight_height': u.sightHeight,
  'twist': u.twist,
  'barrel_length': u.barrelLength,
  'time': u.time,
  'torque': u.torque,
  'target_size': u.targetSize,
};

Map<String, dynamic> shootingConditionsToJson(proto.ShootingConditions s) => {
  'distance_meter': s.distanceMeter,
  'look_angle_rad': s.lookAngleRad,
  'altitude_meter': s.altitudeMeter,
  'temperature_c': s.temperatureC,
  'pressure_h_pa': s.pressureHPa,
  'humidity_frac': s.humidityFrac,
  'powder_temperature_c': s.powderTemperatureC,
  'use_powder_sensitivity': s.usePowderSensitivity,
  'use_diff_powder_temp': s.useDiffPowderTemp,
  'use_coriolis': s.useCoriolis,
  'latitude_deg': s.latitudeDeg,
  'azimuth_deg': s.azimuthDeg,
  'wind_direction_deg': s.windDirectionDeg,
  'wind_speed_mps': s.windSpeedMps,
};

Map<String, dynamic> unitValueToJson(proto.UnitValue u) => {
  'value': u.value,
  'last_unit': u.lastUnit,
};

Map<String, dynamic> anglesConvToJson(proto.AnglesConv a) => {
  'distance_value_meter': a.distanceValueMeter,
  'distance_last_unit': a.distanceLastUnit,
  'angular_value_mil': a.angularValueMil,
  'angular_last_unit': a.angularLastUnit,
  'output_last_unit': a.outputLastUnit,
};

Map<String, dynamic> velocityConvToJson(proto.VelocityConv v) => {
  'value_mps': v.valueMps,
  'last_unit': v.lastUnit,
  'mach_input_value': v.machInputValue,
  'mach_use_custom_atmo': v.machUseCustomAtmo,
  'atmo_temperature_c': v.atmoTemperatureC,
  'atmo_pressure_h_pa': v.atmoPressureHPa,
  'atmo_humidity_frac': v.atmoHumidityFrac,
  'atmo_altitude_meter': v.atmoAltitudeMeter,
};

Map<String, dynamic> distanceConvTargetSizeToJson(
  proto.DistanceConvTargetSize d,
) => {
  'size_inch': d.sizeInch,
  'size_unit': d.sizeUnit,
  'size_angular_mil': d.sizeAngularMil,
  'size_angular_unit': d.sizeAngularUnit,
};

Map<String, dynamic> convertorsStateToJson(proto.ConvertorsState c) => {
  'length': unitValueToJson(c.length),
  'weight': unitValueToJson(c.weight),
  'pressure': unitValueToJson(c.pressure),
  'temperature': unitValueToJson(c.temperature),
  'torque': unitValueToJson(c.torque),
  'angles': anglesConvToJson(c.angles),
  'velocity': velocityConvToJson(c.velocity),
  'distance_conv_target_size': distanceConvTargetSizeToJson(
    c.distanceConvTargetSize,
  ),
};

Map<String, dynamic> reticleSettingsToJson(proto.ReticleSettings r) => {
  'vertical_adjustment': r.verticalAdjustment,
  'vertical_adjustment_unit': r.verticalAdjustmentUnit,
  'horizontal_adjustment': r.horizontalAdjustment,
  'horizontal_adjustment_unit': r.horizontalAdjustmentUnit,
  'target_image': r.targetImage,
};

Map<String, dynamic> settingsDataToJson(proto.SettingsData data) => {
  'schema_version': data.schemaVersion,
  'general_settings': generalSettingsToJson(data.generalSettings),
  'unit_settings': unitSettingsToJson(data.unitSettings),
  'tables_settings': tablesSettingsToJson(data.tablesSettings),
  'reticle_settings': reticleSettingsToJson(data.reticleSettings),
  'convertors_state': convertorsStateToJson(data.convertorsState),
  'shooting_conditions': shootingConditionsToJson(data.shootingConditions),
};
