// This is a generated file - do not edit.
//
// Generated from settings.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use generalSettingsDescriptor instead')
const GeneralSettings$json = {
  '1': 'GeneralSettings',
  '2': [
    {'1': 'language_code', '3': 1, '4': 1, '5': 9, '10': 'languageCode'},
    {'1': 'theme_mode', '3': 2, '4': 1, '5': 9, '10': 'themeMode'},
    {
      '1': 'adjustment_display_format_value',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'adjustmentDisplayFormatValue'
    },
    {'1': 'home_show_mil', '3': 4, '4': 1, '5': 8, '10': 'homeShowMil'},
    {'1': 'home_show_mrad', '3': 5, '4': 1, '5': 8, '10': 'homeShowMrad'},
    {'1': 'home_show_moa', '3': 6, '4': 1, '5': 8, '10': 'homeShowMoa'},
    {
      '1': 'home_show_cm_per100m',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'homeShowCmPer100m'
    },
    {
      '1': 'home_show_in_per100yd',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'homeShowInPer100yd'
    },
    {
      '1': 'home_show_in_clicks',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'homeShowInClicks'
    },
    {
      '1': 'home_chart_distance_step',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'homeChartDistanceStep'
    },
    {
      '1': 'home_table_distance_step',
      '3': 11,
      '4': 1,
      '5': 1,
      '10': 'homeTableDistanceStep'
    },
    {
      '1': 'home_show_subsonic_transition',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'homeShowSubsonicTransition'
    },
  ],
};

/// Descriptor for `GeneralSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generalSettingsDescriptor = $convert.base64Decode(
    'Cg9HZW5lcmFsU2V0dGluZ3MSIwoNbGFuZ3VhZ2VfY29kZRgBIAEoCVIMbGFuZ3VhZ2VDb2RlEh'
    '0KCnRoZW1lX21vZGUYAiABKAlSCXRoZW1lTW9kZRJFCh9hZGp1c3RtZW50X2Rpc3BsYXlfZm9y'
    'bWF0X3ZhbHVlGAMgASgJUhxhZGp1c3RtZW50RGlzcGxheUZvcm1hdFZhbHVlEiIKDWhvbWVfc2'
    'hvd19taWwYBCABKAhSC2hvbWVTaG93TWlsEiQKDmhvbWVfc2hvd19tcmFkGAUgASgIUgxob21l'
    'U2hvd01yYWQSIgoNaG9tZV9zaG93X21vYRgGIAEoCFILaG9tZVNob3dNb2ESLwoUaG9tZV9zaG'
    '93X2NtX3BlcjEwMG0YByABKAhSEWhvbWVTaG93Q21QZXIxMDBtEjEKFWhvbWVfc2hvd19pbl9w'
    'ZXIxMDB5ZBgIIAEoCFISaG9tZVNob3dJblBlcjEwMHlkEi0KE2hvbWVfc2hvd19pbl9jbGlja3'
    'MYCSABKAhSEGhvbWVTaG93SW5DbGlja3MSNwoYaG9tZV9jaGFydF9kaXN0YW5jZV9zdGVwGAog'
    'ASgBUhVob21lQ2hhcnREaXN0YW5jZVN0ZXASNwoYaG9tZV90YWJsZV9kaXN0YW5jZV9zdGVwGA'
    'sgASgBUhVob21lVGFibGVEaXN0YW5jZVN0ZXASQQodaG9tZV9zaG93X3N1YnNvbmljX3RyYW5z'
    'aXRpb24YDCABKAhSGmhvbWVTaG93U3Vic29uaWNUcmFuc2l0aW9u');

@$core.Deprecated('Use tablesSettingsDescriptor instead')
const TablesSettings$json = {
  '1': 'TablesSettings',
  '2': [
    {
      '1': 'distance_start_meter',
      '3': 1,
      '4': 1,
      '5': 1,
      '10': 'distanceStartMeter'
    },
    {
      '1': 'distance_end_meter',
      '3': 2,
      '4': 1,
      '5': 1,
      '10': 'distanceEndMeter'
    },
    {
      '1': 'distance_step_meter',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'distanceStepMeter'
    },
    {'1': 'show_zeros', '3': 4, '4': 1, '5': 8, '10': 'showZeros'},
    {
      '1': 'show_subsonic_transition',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'showSubsonicTransition'
    },
    {'1': 'hidden_cols', '3': 6, '4': 3, '5': 9, '10': 'hiddenCols'},
    {'1': 'show_mil', '3': 7, '4': 1, '5': 8, '10': 'showMil'},
    {'1': 'show_mrad', '3': 8, '4': 1, '5': 8, '10': 'showMrad'},
    {'1': 'show_moa', '3': 9, '4': 1, '5': 8, '10': 'showMoa'},
    {'1': 'show_cm_per100m', '3': 10, '4': 1, '5': 8, '10': 'showCmPer100m'},
    {'1': 'show_in_per100yd', '3': 11, '4': 1, '5': 8, '10': 'showInPer100yd'},
    {'1': 'show_in_clicks', '3': 12, '4': 1, '5': 8, '10': 'showInClicks'},
  ],
};

/// Descriptor for `TablesSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tablesSettingsDescriptor = $convert.base64Decode(
    'Cg5UYWJsZXNTZXR0aW5ncxIwChRkaXN0YW5jZV9zdGFydF9tZXRlchgBIAEoAVISZGlzdGFuY2'
    'VTdGFydE1ldGVyEiwKEmRpc3RhbmNlX2VuZF9tZXRlchgCIAEoAVIQZGlzdGFuY2VFbmRNZXRl'
    'chIuChNkaXN0YW5jZV9zdGVwX21ldGVyGAMgASgBUhFkaXN0YW5jZVN0ZXBNZXRlchIdCgpzaG'
    '93X3plcm9zGAQgASgIUglzaG93WmVyb3MSOAoYc2hvd19zdWJzb25pY190cmFuc2l0aW9uGAUg'
    'ASgIUhZzaG93U3Vic29uaWNUcmFuc2l0aW9uEh8KC2hpZGRlbl9jb2xzGAYgAygJUgpoaWRkZW'
    '5Db2xzEhkKCHNob3dfbWlsGAcgASgIUgdzaG93TWlsEhsKCXNob3dfbXJhZBgIIAEoCFIIc2hv'
    'd01yYWQSGQoIc2hvd19tb2EYCSABKAhSB3Nob3dNb2ESJgoPc2hvd19jbV9wZXIxMDBtGAogAS'
    'gIUg1zaG93Q21QZXIxMDBtEigKEHNob3dfaW5fcGVyMTAweWQYCyABKAhSDnNob3dJblBlcjEw'
    'MHlkEiQKDnNob3dfaW5fY2xpY2tzGAwgASgIUgxzaG93SW5DbGlja3M=');

@$core.Deprecated('Use unitSettingsDescriptor instead')
const UnitSettings$json = {
  '1': 'UnitSettings',
  '2': [
    {'1': 'angular', '3': 1, '4': 1, '5': 9, '10': 'angular'},
    {'1': 'distance', '3': 2, '4': 1, '5': 9, '10': 'distance'},
    {'1': 'velocity', '3': 3, '4': 1, '5': 9, '10': 'velocity'},
    {'1': 'pressure', '3': 4, '4': 1, '5': 9, '10': 'pressure'},
    {'1': 'temperature', '3': 5, '4': 1, '5': 9, '10': 'temperature'},
    {'1': 'diameter', '3': 6, '4': 1, '5': 9, '10': 'diameter'},
    {'1': 'length', '3': 7, '4': 1, '5': 9, '10': 'length'},
    {'1': 'weight', '3': 8, '4': 1, '5': 9, '10': 'weight'},
    {'1': 'adjustment', '3': 9, '4': 1, '5': 9, '10': 'adjustment'},
    {'1': 'drop', '3': 10, '4': 1, '5': 9, '10': 'drop'},
    {'1': 'energy', '3': 11, '4': 1, '5': 9, '10': 'energy'},
    {'1': 'sight_height', '3': 12, '4': 1, '5': 9, '10': 'sightHeight'},
    {'1': 'twist', '3': 13, '4': 1, '5': 9, '10': 'twist'},
    {'1': 'barrel_length', '3': 14, '4': 1, '5': 9, '10': 'barrelLength'},
    {'1': 'time', '3': 15, '4': 1, '5': 9, '10': 'time'},
    {'1': 'torque', '3': 16, '4': 1, '5': 9, '10': 'torque'},
    {'1': 'target_size', '3': 17, '4': 1, '5': 9, '10': 'targetSize'},
  ],
};

/// Descriptor for `UnitSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unitSettingsDescriptor = $convert.base64Decode(
    'CgxVbml0U2V0dGluZ3MSGAoHYW5ndWxhchgBIAEoCVIHYW5ndWxhchIaCghkaXN0YW5jZRgCIA'
    'EoCVIIZGlzdGFuY2USGgoIdmVsb2NpdHkYAyABKAlSCHZlbG9jaXR5EhoKCHByZXNzdXJlGAQg'
    'ASgJUghwcmVzc3VyZRIgCgt0ZW1wZXJhdHVyZRgFIAEoCVILdGVtcGVyYXR1cmUSGgoIZGlhbW'
    'V0ZXIYBiABKAlSCGRpYW1ldGVyEhYKBmxlbmd0aBgHIAEoCVIGbGVuZ3RoEhYKBndlaWdodBgI'
    'IAEoCVIGd2VpZ2h0Eh4KCmFkanVzdG1lbnQYCSABKAlSCmFkanVzdG1lbnQSEgoEZHJvcBgKIA'
    'EoCVIEZHJvcBIWCgZlbmVyZ3kYCyABKAlSBmVuZXJneRIhCgxzaWdodF9oZWlnaHQYDCABKAlS'
    'C3NpZ2h0SGVpZ2h0EhQKBXR3aXN0GA0gASgJUgV0d2lzdBIjCg1iYXJyZWxfbGVuZ3RoGA4gAS'
    'gJUgxiYXJyZWxMZW5ndGgSEgoEdGltZRgPIAEoCVIEdGltZRIWCgZ0b3JxdWUYECABKAlSBnRv'
    'cnF1ZRIfCgt0YXJnZXRfc2l6ZRgRIAEoCVIKdGFyZ2V0U2l6ZQ==');

@$core.Deprecated('Use shootingConditionsDescriptor instead')
const ShootingConditions$json = {
  '1': 'ShootingConditions',
  '2': [
    {'1': 'distance_meter', '3': 1, '4': 1, '5': 1, '10': 'distanceMeter'},
    {'1': 'look_angle_rad', '3': 2, '4': 1, '5': 1, '10': 'lookAngleRad'},
    {'1': 'altitude_meter', '3': 3, '4': 1, '5': 1, '10': 'altitudeMeter'},
    {'1': 'temperature_c', '3': 4, '4': 1, '5': 1, '10': 'temperatureC'},
    {'1': 'pressure_h_pa', '3': 5, '4': 1, '5': 1, '10': 'pressureHPa'},
    {'1': 'humidity_frac', '3': 6, '4': 1, '5': 1, '10': 'humidityFrac'},
    {
      '1': 'powder_temperature_c',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'powderTemperatureC'
    },
    {
      '1': 'use_powder_sensitivity',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'usePowderSensitivity'
    },
    {
      '1': 'use_diff_powder_temp',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'useDiffPowderTemp'
    },
    {'1': 'use_coriolis', '3': 10, '4': 1, '5': 8, '10': 'useCoriolis'},
    {'1': 'latitude_deg', '3': 11, '4': 1, '5': 1, '10': 'latitudeDeg'},
    {'1': 'azimuth_deg', '3': 12, '4': 1, '5': 1, '10': 'azimuthDeg'},
    {
      '1': 'wind_direction_deg',
      '3': 13,
      '4': 1,
      '5': 1,
      '10': 'windDirectionDeg'
    },
    {'1': 'wind_speed_mps', '3': 14, '4': 1, '5': 1, '10': 'windSpeedMps'},
  ],
};

/// Descriptor for `ShootingConditions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shootingConditionsDescriptor = $convert.base64Decode(
    'ChJTaG9vdGluZ0NvbmRpdGlvbnMSJQoOZGlzdGFuY2VfbWV0ZXIYASABKAFSDWRpc3RhbmNlTW'
    'V0ZXISJAoObG9va19hbmdsZV9yYWQYAiABKAFSDGxvb2tBbmdsZVJhZBIlCg5hbHRpdHVkZV9t'
    'ZXRlchgDIAEoAVINYWx0aXR1ZGVNZXRlchIjCg10ZW1wZXJhdHVyZV9jGAQgASgBUgx0ZW1wZX'
    'JhdHVyZUMSIgoNcHJlc3N1cmVfaF9wYRgFIAEoAVILcHJlc3N1cmVIUGESIwoNaHVtaWRpdHlf'
    'ZnJhYxgGIAEoAVIMaHVtaWRpdHlGcmFjEjAKFHBvd2Rlcl90ZW1wZXJhdHVyZV9jGAcgASgBUh'
    'Jwb3dkZXJUZW1wZXJhdHVyZUMSNAoWdXNlX3Bvd2Rlcl9zZW5zaXRpdml0eRgIIAEoCFIUdXNl'
    'UG93ZGVyU2Vuc2l0aXZpdHkSLwoUdXNlX2RpZmZfcG93ZGVyX3RlbXAYCSABKAhSEXVzZURpZm'
    'ZQb3dkZXJUZW1wEiEKDHVzZV9jb3Jpb2xpcxgKIAEoCFILdXNlQ29yaW9saXMSIQoMbGF0aXR1'
    'ZGVfZGVnGAsgASgBUgtsYXRpdHVkZURlZxIfCgthemltdXRoX2RlZxgMIAEoAVIKYXppbXV0aE'
    'RlZxIsChJ3aW5kX2RpcmVjdGlvbl9kZWcYDSABKAFSEHdpbmREaXJlY3Rpb25EZWcSJAoOd2lu'
    'ZF9zcGVlZF9tcHMYDiABKAFSDHdpbmRTcGVlZE1wcw==');

@$core.Deprecated('Use unitValueDescriptor instead')
const UnitValue$json = {
  '1': 'UnitValue',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 1, '10': 'value'},
    {'1': 'last_unit', '3': 2, '4': 1, '5': 9, '10': 'lastUnit'},
  ],
};

/// Descriptor for `UnitValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unitValueDescriptor = $convert.base64Decode(
    'CglVbml0VmFsdWUSFAoFdmFsdWUYASABKAFSBXZhbHVlEhsKCWxhc3RfdW5pdBgCIAEoCVIIbG'
    'FzdFVuaXQ=');

@$core.Deprecated('Use anglesConvDescriptor instead')
const AnglesConv$json = {
  '1': 'AnglesConv',
  '2': [
    {
      '1': 'distance_value_meter',
      '3': 1,
      '4': 1,
      '5': 1,
      '10': 'distanceValueMeter'
    },
    {
      '1': 'distance_last_unit',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'distanceLastUnit'
    },
    {'1': 'angular_value_mil', '3': 3, '4': 1, '5': 1, '10': 'angularValueMil'},
    {'1': 'angular_last_unit', '3': 4, '4': 1, '5': 9, '10': 'angularLastUnit'},
    {'1': 'output_last_unit', '3': 5, '4': 1, '5': 9, '10': 'outputLastUnit'},
  ],
};

/// Descriptor for `AnglesConv`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anglesConvDescriptor = $convert.base64Decode(
    'CgpBbmdsZXNDb252EjAKFGRpc3RhbmNlX3ZhbHVlX21ldGVyGAEgASgBUhJkaXN0YW5jZVZhbH'
    'VlTWV0ZXISLAoSZGlzdGFuY2VfbGFzdF91bml0GAIgASgJUhBkaXN0YW5jZUxhc3RVbml0EioK'
    'EWFuZ3VsYXJfdmFsdWVfbWlsGAMgASgBUg9hbmd1bGFyVmFsdWVNaWwSKgoRYW5ndWxhcl9sYX'
    'N0X3VuaXQYBCABKAlSD2FuZ3VsYXJMYXN0VW5pdBIoChBvdXRwdXRfbGFzdF91bml0GAUgASgJ'
    'Ug5vdXRwdXRMYXN0VW5pdA==');

@$core.Deprecated('Use velocityConvDescriptor instead')
const VelocityConv$json = {
  '1': 'VelocityConv',
  '2': [
    {'1': 'value_mps', '3': 1, '4': 1, '5': 1, '10': 'valueMps'},
    {'1': 'last_unit', '3': 2, '4': 1, '5': 9, '10': 'lastUnit'},
    {'1': 'mach_input_value', '3': 3, '4': 1, '5': 1, '10': 'machInputValue'},
    {
      '1': 'mach_use_custom_atmo',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'machUseCustomAtmo'
    },
    {
      '1': 'atmo_temperature_c',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'atmoTemperatureC'
    },
    {
      '1': 'atmo_pressure_h_pa',
      '3': 6,
      '4': 1,
      '5': 1,
      '10': 'atmoPressureHPa'
    },
    {
      '1': 'atmo_humidity_frac',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'atmoHumidityFrac'
    },
    {
      '1': 'atmo_altitude_meter',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'atmoAltitudeMeter'
    },
  ],
};

/// Descriptor for `VelocityConv`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List velocityConvDescriptor = $convert.base64Decode(
    'CgxWZWxvY2l0eUNvbnYSGwoJdmFsdWVfbXBzGAEgASgBUgh2YWx1ZU1wcxIbCglsYXN0X3VuaX'
    'QYAiABKAlSCGxhc3RVbml0EigKEG1hY2hfaW5wdXRfdmFsdWUYAyABKAFSDm1hY2hJbnB1dFZh'
    'bHVlEi8KFG1hY2hfdXNlX2N1c3RvbV9hdG1vGAQgASgIUhFtYWNoVXNlQ3VzdG9tQXRtbxIsCh'
    'JhdG1vX3RlbXBlcmF0dXJlX2MYBSABKAFSEGF0bW9UZW1wZXJhdHVyZUMSKwoSYXRtb19wcmVz'
    'c3VyZV9oX3BhGAYgASgBUg9hdG1vUHJlc3N1cmVIUGESLAoSYXRtb19odW1pZGl0eV9mcmFjGA'
    'cgASgBUhBhdG1vSHVtaWRpdHlGcmFjEi4KE2F0bW9fYWx0aXR1ZGVfbWV0ZXIYCCABKAFSEWF0'
    'bW9BbHRpdHVkZU1ldGVy');

@$core.Deprecated('Use distanceConvTargetSizeDescriptor instead')
const DistanceConvTargetSize$json = {
  '1': 'DistanceConvTargetSize',
  '2': [
    {'1': 'size_inch', '3': 1, '4': 1, '5': 1, '10': 'sizeInch'},
    {'1': 'size_unit', '3': 2, '4': 1, '5': 9, '10': 'sizeUnit'},
    {'1': 'size_angular_mil', '3': 3, '4': 1, '5': 1, '10': 'sizeAngularMil'},
    {'1': 'size_angular_unit', '3': 4, '4': 1, '5': 9, '10': 'sizeAngularUnit'},
  ],
};

/// Descriptor for `DistanceConvTargetSize`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List distanceConvTargetSizeDescriptor = $convert.base64Decode(
    'ChZEaXN0YW5jZUNvbnZUYXJnZXRTaXplEhsKCXNpemVfaW5jaBgBIAEoAVIIc2l6ZUluY2gSGw'
    'oJc2l6ZV91bml0GAIgASgJUghzaXplVW5pdBIoChBzaXplX2FuZ3VsYXJfbWlsGAMgASgBUg5z'
    'aXplQW5ndWxhck1pbBIqChFzaXplX2FuZ3VsYXJfdW5pdBgEIAEoCVIPc2l6ZUFuZ3VsYXJVbm'
    'l0');

@$core.Deprecated('Use convertorsStateDescriptor instead')
const ConvertorsState$json = {
  '1': 'ConvertorsState',
  '2': [
    {
      '1': 'length',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.settings.UnitValue',
      '10': 'length'
    },
    {
      '1': 'weight',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.settings.UnitValue',
      '10': 'weight'
    },
    {
      '1': 'pressure',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.settings.UnitValue',
      '10': 'pressure'
    },
    {
      '1': 'temperature',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.settings.UnitValue',
      '10': 'temperature'
    },
    {
      '1': 'torque',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.settings.UnitValue',
      '10': 'torque'
    },
    {
      '1': 'angles',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.settings.AnglesConv',
      '10': 'angles'
    },
    {
      '1': 'velocity',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.settings.VelocityConv',
      '10': 'velocity'
    },
    {
      '1': 'distance_conv_target_size',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.settings.DistanceConvTargetSize',
      '10': 'distanceConvTargetSize'
    },
  ],
};

/// Descriptor for `ConvertorsState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List convertorsStateDescriptor = $convert.base64Decode(
    'Cg9Db252ZXJ0b3JzU3RhdGUSKwoGbGVuZ3RoGAEgASgLMhMuc2V0dGluZ3MuVW5pdFZhbHVlUg'
    'ZsZW5ndGgSKwoGd2VpZ2h0GAIgASgLMhMuc2V0dGluZ3MuVW5pdFZhbHVlUgZ3ZWlnaHQSLwoI'
    'cHJlc3N1cmUYAyABKAsyEy5zZXR0aW5ncy5Vbml0VmFsdWVSCHByZXNzdXJlEjUKC3RlbXBlcm'
    'F0dXJlGAQgASgLMhMuc2V0dGluZ3MuVW5pdFZhbHVlUgt0ZW1wZXJhdHVyZRIrCgZ0b3JxdWUY'
    'BSABKAsyEy5zZXR0aW5ncy5Vbml0VmFsdWVSBnRvcnF1ZRIsCgZhbmdsZXMYBiABKAsyFC5zZX'
    'R0aW5ncy5BbmdsZXNDb252UgZhbmdsZXMSMgoIdmVsb2NpdHkYByABKAsyFi5zZXR0aW5ncy5W'
    'ZWxvY2l0eUNvbnZSCHZlbG9jaXR5ElsKGWRpc3RhbmNlX2NvbnZfdGFyZ2V0X3NpemUYCCABKA'
    'syIC5zZXR0aW5ncy5EaXN0YW5jZUNvbnZUYXJnZXRTaXplUhZkaXN0YW5jZUNvbnZUYXJnZXRT'
    'aXpl');

@$core.Deprecated('Use reticleSettingsDescriptor instead')
const ReticleSettings$json = {
  '1': 'ReticleSettings',
  '2': [
    {
      '1': 'vertical_adjustment',
      '3': 1,
      '4': 1,
      '5': 1,
      '10': 'verticalAdjustment'
    },
    {
      '1': 'vertical_adjustment_unit',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'verticalAdjustmentUnit'
    },
    {
      '1': 'horizontal_adjustment',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'horizontalAdjustment'
    },
    {
      '1': 'horizontal_adjustment_unit',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'horizontalAdjustmentUnit'
    },
    {'1': 'target_image', '3': 5, '4': 1, '5': 9, '10': 'targetImage'},
  ],
};

/// Descriptor for `ReticleSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reticleSettingsDescriptor = $convert.base64Decode(
    'Cg9SZXRpY2xlU2V0dGluZ3MSLwoTdmVydGljYWxfYWRqdXN0bWVudBgBIAEoAVISdmVydGljYW'
    'xBZGp1c3RtZW50EjgKGHZlcnRpY2FsX2FkanVzdG1lbnRfdW5pdBgCIAEoCVIWdmVydGljYWxB'
    'ZGp1c3RtZW50VW5pdBIzChVob3Jpem9udGFsX2FkanVzdG1lbnQYAyABKAFSFGhvcml6b250YW'
    'xBZGp1c3RtZW50EjwKGmhvcml6b250YWxfYWRqdXN0bWVudF91bml0GAQgASgJUhhob3Jpem9u'
    'dGFsQWRqdXN0bWVudFVuaXQSIQoMdGFyZ2V0X2ltYWdlGAUgASgJUgt0YXJnZXRJbWFnZQ==');

@$core.Deprecated('Use settingsDataDescriptor instead')
const SettingsData$json = {
  '1': 'SettingsData',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 13, '10': 'schemaVersion'},
    {
      '1': 'general_settings',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.settings.GeneralSettings',
      '10': 'generalSettings'
    },
    {
      '1': 'unit_settings',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.settings.UnitSettings',
      '10': 'unitSettings'
    },
    {
      '1': 'tables_settings',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.settings.TablesSettings',
      '10': 'tablesSettings'
    },
    {
      '1': 'reticle_settings',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.settings.ReticleSettings',
      '10': 'reticleSettings'
    },
    {
      '1': 'convertors_state',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.settings.ConvertorsState',
      '10': 'convertorsState'
    },
    {
      '1': 'shooting_conditions',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.settings.ShootingConditions',
      '10': 'shootingConditions'
    },
  ],
};

/// Descriptor for `SettingsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDataDescriptor = $convert.base64Decode(
    'CgxTZXR0aW5nc0RhdGESJQoOc2NoZW1hX3ZlcnNpb24YASABKA1SDXNjaGVtYVZlcnNpb24SRA'
    'oQZ2VuZXJhbF9zZXR0aW5ncxgCIAEoCzIZLnNldHRpbmdzLkdlbmVyYWxTZXR0aW5nc1IPZ2Vu'
    'ZXJhbFNldHRpbmdzEjsKDXVuaXRfc2V0dGluZ3MYAyABKAsyFi5zZXR0aW5ncy5Vbml0U2V0dG'
    'luZ3NSDHVuaXRTZXR0aW5ncxJBCg90YWJsZXNfc2V0dGluZ3MYBCABKAsyGC5zZXR0aW5ncy5U'
    'YWJsZXNTZXR0aW5nc1IOdGFibGVzU2V0dGluZ3MSRAoQcmV0aWNsZV9zZXR0aW5ncxgFIAEoCz'
    'IZLnNldHRpbmdzLlJldGljbGVTZXR0aW5nc1IPcmV0aWNsZVNldHRpbmdzEkQKEGNvbnZlcnRv'
    'cnNfc3RhdGUYBiABKAsyGS5zZXR0aW5ncy5Db252ZXJ0b3JzU3RhdGVSD2NvbnZlcnRvcnNTdG'
    'F0ZRJNChNzaG9vdGluZ19jb25kaXRpb25zGAcgASgLMhwuc2V0dGluZ3MuU2hvb3RpbmdDb25k'
    'aXRpb25zUhJzaG9vdGluZ0NvbmRpdGlvbnM=');
