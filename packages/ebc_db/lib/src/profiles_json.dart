import 'proto/profiles.pb.dart' as proto;

// Converts protobuf profiles.* messages into the plain snake_case JSON
// shape schema/profiles.schema.json (and the nested defs in
// schema/ebcp.schema.json) are written against. Dart protobuf's own
// writeToJsonMap() uses camelCase (proto3 JSON mapping), which wouldn't
// match the schemas' property names, so this is built by hand instead
// (same reason a7p's A7pValidator does its own conversion). Shared by
// ProfilesValidator and EbcpValidator so the mapping is written once.

Map<String, dynamic> weaponToJson(proto.Weapon w) => {
  'name': w.name,
  'caliber_inch': w.hasCaliberInch() ? w.caliberInch : null,
  'caliber_name': w.caliberName,
  'twist_inch': w.twistInch,
  'barrel_length_inch': w.hasBarrelLengthInch() ? w.barrelLengthInch : null,
  'zero_elevation_rad': w.zeroElevationRad,
  'vendor': w.vendor,
  'notes': w.notes,
  'image': w.image,
};

Map<String, dynamic> sightToJson(proto.Sight s) => {
  'name': s.name,
  'focal_plane_value': s.focalPlaneValue,
  'sight_height_inch': s.sightHeightInch,
  'sight_horizontal_offset_inch': s.sightHorizontalOffsetInch,
  'vertical_click': s.verticalClick,
  'horizontal_click': s.horizontalClick,
  'vertical_click_unit': s.verticalClickUnit,
  'horizontal_click_unit': s.horizontalClickUnit,
  'min_magnification': s.minMagnification,
  'max_magnification': s.maxMagnification,
  'reticle_image': s.reticleImage,
  'calibrated_magnification': s.hasCalibratedMagnification()
      ? s.calibratedMagnification
      : null,
  'vendor': s.vendor,
  'notes': s.notes,
  'image': s.image,
};

Map<String, dynamic> zeroToJson(proto.Zero z) => {
  'distance_meter': z.distanceMeter,
  'look_angle_rad': z.lookAngleRad,
  'altitude_meter': z.altitudeMeter,
  'temperature_c': z.temperatureC,
  'pressure_h_pa': z.pressureHPa,
  'humidity_frac': z.humidityFrac,
  'use_diff_powder_temperature': z.useDiffPowderTemperature,
  'use_coriolis': z.useCoriolis,
  'powder_temperature_c': z.powderTemperatureC,
  'latitude_deg': z.latitudeDeg,
  'azimuth_deg': z.azimuthDeg,
  'offset_x': z.offsetX,
  'offset_y': z.offsetY,
  'offset_x_unit': z.offsetXUnit,
  'offset_y_unit': z.offsetYUnit,
};

Map<String, dynamic> ammoToJson(proto.Ammo a) => {
  'name': a.name,
  'caliber_inch': a.hasCaliberInch() ? a.caliberInch : null,
  'weight_grain': a.hasWeightGrain() ? a.weightGrain : null,
  'length_inch': a.hasLengthInch() ? a.lengthInch : null,
  'drag_type_value': a.dragTypeValue,
  'bc_g1': a.hasBcG1() ? a.bcG1 : null,
  'bc_g7': a.hasBcG7() ? a.bcG7 : null,
  'use_multi_bc_g1': a.useMultiBcG1,
  'use_multi_bc_g7': a.useMultiBcG7,
  'muzzle_velocity_mps': a.hasMuzzleVelocityMps() ? a.muzzleVelocityMps : null,
  'muzzle_velocity_temperature_c': a.muzzleVelocityTemperatureC,
  'use_powder_sensitivity': a.usePowderSensitivity,
  'powder_sensitivity_frac': a.powderSensitivityFrac,
  'powder_sensitivity_tc': a.powderSensitivityTc,
  'powder_sensitivity_v_mps': a.powderSensitivityVMps,
  'multi_bc_table_g1_v_mps': a.multiBcTableG1VMps,
  'multi_bc_table_g1_bc': a.multiBcTableG1Bc,
  'multi_bc_table_g7_v_mps': a.multiBcTableG7VMps,
  'multi_bc_table_g7_bc': a.multiBcTableG7Bc,
  'custom_drag_table_mach': a.customDragTableMach,
  'custom_drag_table_cd': a.customDragTableCd,
  'zero': zeroToJson(a.zero),
  'projectile_name': a.projectileName,
  'vendor': a.vendor,
  'image': a.image,
};

Map<String, dynamic> profileToJson(proto.Profile p) => {
  'uuid': p.uuid,
  'name': p.name,
  'weapon': weaponToJson(p.weapon),
  'ammo': ammoToJson(p.ammo),
  'sight': sightToJson(p.sight),
};

Map<String, dynamic> profilesDataToJson(proto.ProfilesData data) => {
  'schema_version': data.schemaVersion,
  'profiles': data.profiles.map(profileToJson).toList(),
};
