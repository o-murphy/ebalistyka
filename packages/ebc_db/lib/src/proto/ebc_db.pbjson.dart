// This is a generated file - do not edit.
//
// Generated from ebc_db.proto.

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

@$core.Deprecated('Use weaponDescriptor instead')
const Weapon$json = {
  '1': 'Weapon',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'caliber_inch',
      '3': 2,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'caliberInch',
      '17': true
    },
    {'1': 'caliber_name', '3': 3, '4': 1, '5': 9, '10': 'caliberName'},
    {'1': 'twist_inch', '3': 4, '4': 1, '5': 1, '10': 'twistInch'},
    {
      '1': 'barrel_length_inch',
      '3': 5,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'barrelLengthInch',
      '17': true
    },
    {
      '1': 'zero_elevation_rad',
      '3': 6,
      '4': 1,
      '5': 1,
      '10': 'zeroElevationRad'
    },
    {'1': 'vendor', '3': 7, '4': 1, '5': 9, '10': 'vendor'},
    {'1': 'notes', '3': 8, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'image', '3': 9, '4': 1, '5': 9, '10': 'image'},
  ],
  '8': [
    {'1': '_caliber_inch'},
    {'1': '_barrel_length_inch'},
  ],
};

/// Descriptor for `Weapon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weaponDescriptor = $convert.base64Decode(
    'CgZXZWFwb24SEgoEbmFtZRgBIAEoCVIEbmFtZRImCgxjYWxpYmVyX2luY2gYAiABKAFIAFILY2'
    'FsaWJlckluY2iIAQESIQoMY2FsaWJlcl9uYW1lGAMgASgJUgtjYWxpYmVyTmFtZRIdCgp0d2lz'
    'dF9pbmNoGAQgASgBUgl0d2lzdEluY2gSMQoSYmFycmVsX2xlbmd0aF9pbmNoGAUgASgBSAFSEG'
    'JhcnJlbExlbmd0aEluY2iIAQESLAoSemVyb19lbGV2YXRpb25fcmFkGAYgASgBUhB6ZXJvRWxl'
    'dmF0aW9uUmFkEhYKBnZlbmRvchgHIAEoCVIGdmVuZG9yEhQKBW5vdGVzGAggASgJUgVub3Rlcx'
    'IUCgVpbWFnZRgJIAEoCVIFaW1hZ2VCDwoNX2NhbGliZXJfaW5jaEIVChNfYmFycmVsX2xlbmd0'
    'aF9pbmNo');

@$core.Deprecated('Use sightDescriptor instead')
const Sight$json = {
  '1': 'Sight',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'focal_plane_value', '3': 2, '4': 1, '5': 9, '10': 'focalPlaneValue'},
    {'1': 'sight_height_inch', '3': 3, '4': 1, '5': 1, '10': 'sightHeightInch'},
    {
      '1': 'sight_horizontal_offset_inch',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'sightHorizontalOffsetInch'
    },
    {'1': 'vertical_click', '3': 5, '4': 1, '5': 1, '10': 'verticalClick'},
    {'1': 'horizontal_click', '3': 6, '4': 1, '5': 1, '10': 'horizontalClick'},
    {
      '1': 'vertical_click_unit',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'verticalClickUnit'
    },
    {
      '1': 'horizontal_click_unit',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'horizontalClickUnit'
    },
    {
      '1': 'min_magnification',
      '3': 9,
      '4': 1,
      '5': 1,
      '10': 'minMagnification'
    },
    {
      '1': 'max_magnification',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'maxMagnification'
    },
    {'1': 'reticle_image', '3': 11, '4': 1, '5': 9, '10': 'reticleImage'},
    {
      '1': 'calibrated_magnification',
      '3': 12,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'calibratedMagnification',
      '17': true
    },
    {'1': 'vendor', '3': 13, '4': 1, '5': 9, '10': 'vendor'},
    {'1': 'notes', '3': 14, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'image', '3': 15, '4': 1, '5': 9, '10': 'image'},
  ],
  '8': [
    {'1': '_calibrated_magnification'},
  ],
};

/// Descriptor for `Sight`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sightDescriptor = $convert.base64Decode(
    'CgVTaWdodBISCgRuYW1lGAEgASgJUgRuYW1lEioKEWZvY2FsX3BsYW5lX3ZhbHVlGAIgASgJUg'
    '9mb2NhbFBsYW5lVmFsdWUSKgoRc2lnaHRfaGVpZ2h0X2luY2gYAyABKAFSD3NpZ2h0SGVpZ2h0'
    'SW5jaBI/ChxzaWdodF9ob3Jpem9udGFsX29mZnNldF9pbmNoGAQgASgBUhlzaWdodEhvcml6b2'
    '50YWxPZmZzZXRJbmNoEiUKDnZlcnRpY2FsX2NsaWNrGAUgASgBUg12ZXJ0aWNhbENsaWNrEikK'
    'EGhvcml6b250YWxfY2xpY2sYBiABKAFSD2hvcml6b250YWxDbGljaxIuChN2ZXJ0aWNhbF9jbG'
    'lja191bml0GAcgASgJUhF2ZXJ0aWNhbENsaWNrVW5pdBIyChVob3Jpem9udGFsX2NsaWNrX3Vu'
    'aXQYCCABKAlSE2hvcml6b250YWxDbGlja1VuaXQSKwoRbWluX21hZ25pZmljYXRpb24YCSABKA'
    'FSEG1pbk1hZ25pZmljYXRpb24SKwoRbWF4X21hZ25pZmljYXRpb24YCiABKAFSEG1heE1hZ25p'
    'ZmljYXRpb24SIwoNcmV0aWNsZV9pbWFnZRgLIAEoCVIMcmV0aWNsZUltYWdlEj4KGGNhbGlicm'
    'F0ZWRfbWFnbmlmaWNhdGlvbhgMIAEoAUgAUhdjYWxpYnJhdGVkTWFnbmlmaWNhdGlvbogBARIW'
    'CgZ2ZW5kb3IYDSABKAlSBnZlbmRvchIUCgVub3RlcxgOIAEoCVIFbm90ZXMSFAoFaW1hZ2UYDy'
    'ABKAlSBWltYWdlQhsKGV9jYWxpYnJhdGVkX21hZ25pZmljYXRpb24=');

@$core.Deprecated('Use ammoDescriptor instead')
const Ammo$json = {
  '1': 'Ammo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'caliber_inch',
      '3': 2,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'caliberInch',
      '17': true
    },
    {
      '1': 'weight_grain',
      '3': 3,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'weightGrain',
      '17': true
    },
    {
      '1': 'length_inch',
      '3': 4,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'lengthInch',
      '17': true
    },
    {'1': 'drag_type_value', '3': 5, '4': 1, '5': 9, '10': 'dragTypeValue'},
    {'1': 'bc_g1', '3': 6, '4': 1, '5': 1, '9': 3, '10': 'bcG1', '17': true},
    {'1': 'bc_g7', '3': 7, '4': 1, '5': 1, '9': 4, '10': 'bcG7', '17': true},
    {'1': 'use_multi_bc_g1', '3': 8, '4': 1, '5': 8, '10': 'useMultiBcG1'},
    {'1': 'use_multi_bc_g7', '3': 9, '4': 1, '5': 8, '10': 'useMultiBcG7'},
    {
      '1': 'muzzle_velocity_mps',
      '3': 10,
      '4': 1,
      '5': 1,
      '9': 5,
      '10': 'muzzleVelocityMps',
      '17': true
    },
    {
      '1': 'muzzle_velocity_temperature_c',
      '3': 11,
      '4': 1,
      '5': 1,
      '10': 'muzzleVelocityTemperatureC'
    },
    {
      '1': 'use_powder_sensitivity',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'usePowderSensitivity'
    },
    {
      '1': 'powder_sensitivity_frac',
      '3': 13,
      '4': 1,
      '5': 1,
      '10': 'powderSensitivityFrac'
    },
    {
      '1': 'powder_sensitivity_tc',
      '3': 14,
      '4': 3,
      '5': 1,
      '10': 'powderSensitivityTc'
    },
    {
      '1': 'powder_sensitivity_v_mps',
      '3': 15,
      '4': 3,
      '5': 1,
      '10': 'powderSensitivityVMps'
    },
    {
      '1': 'multi_bc_table_g1_v_mps',
      '3': 16,
      '4': 3,
      '5': 1,
      '10': 'multiBcTableG1VMps'
    },
    {
      '1': 'multi_bc_table_g1_bc',
      '3': 17,
      '4': 3,
      '5': 1,
      '10': 'multiBcTableG1Bc'
    },
    {
      '1': 'multi_bc_table_g7_v_mps',
      '3': 18,
      '4': 3,
      '5': 1,
      '10': 'multiBcTableG7VMps'
    },
    {
      '1': 'multi_bc_table_g7_bc',
      '3': 19,
      '4': 3,
      '5': 1,
      '10': 'multiBcTableG7Bc'
    },
    {
      '1': 'custom_drag_table_mach',
      '3': 20,
      '4': 3,
      '5': 1,
      '10': 'customDragTableMach'
    },
    {
      '1': 'custom_drag_table_cd',
      '3': 21,
      '4': 3,
      '5': 1,
      '10': 'customDragTableCd'
    },
    {'1': 'zero', '3': 22, '4': 1, '5': 11, '6': '.ebc_db.Zero', '10': 'zero'},
    {'1': 'projectile_name', '3': 23, '4': 1, '5': 9, '10': 'projectileName'},
    {'1': 'vendor', '3': 24, '4': 1, '5': 9, '10': 'vendor'},
    {'1': 'image', '3': 25, '4': 1, '5': 9, '10': 'image'},
  ],
  '8': [
    {'1': '_caliber_inch'},
    {'1': '_weight_grain'},
    {'1': '_length_inch'},
    {'1': '_bc_g1'},
    {'1': '_bc_g7'},
    {'1': '_muzzle_velocity_mps'},
  ],
};

/// Descriptor for `Ammo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ammoDescriptor = $convert.base64Decode(
    'CgRBbW1vEhIKBG5hbWUYASABKAlSBG5hbWUSJgoMY2FsaWJlcl9pbmNoGAIgASgBSABSC2NhbG'
    'liZXJJbmNoiAEBEiYKDHdlaWdodF9ncmFpbhgDIAEoAUgBUgt3ZWlnaHRHcmFpbogBARIkCgts'
    'ZW5ndGhfaW5jaBgEIAEoAUgCUgpsZW5ndGhJbmNoiAEBEiYKD2RyYWdfdHlwZV92YWx1ZRgFIA'
    'EoCVINZHJhZ1R5cGVWYWx1ZRIYCgViY19nMRgGIAEoAUgDUgRiY0cxiAEBEhgKBWJjX2c3GAcg'
    'ASgBSARSBGJjRzeIAQESJQoPdXNlX211bHRpX2JjX2cxGAggASgIUgx1c2VNdWx0aUJjRzESJQ'
    'oPdXNlX211bHRpX2JjX2c3GAkgASgIUgx1c2VNdWx0aUJjRzcSMwoTbXV6emxlX3ZlbG9jaXR5'
    'X21wcxgKIAEoAUgFUhFtdXp6bGVWZWxvY2l0eU1wc4gBARJBCh1tdXp6bGVfdmVsb2NpdHlfdG'
    'VtcGVyYXR1cmVfYxgLIAEoAVIabXV6emxlVmVsb2NpdHlUZW1wZXJhdHVyZUMSNAoWdXNlX3Bv'
    'd2Rlcl9zZW5zaXRpdml0eRgMIAEoCFIUdXNlUG93ZGVyU2Vuc2l0aXZpdHkSNgoXcG93ZGVyX3'
    'NlbnNpdGl2aXR5X2ZyYWMYDSABKAFSFXBvd2RlclNlbnNpdGl2aXR5RnJhYxIyChVwb3dkZXJf'
    'c2Vuc2l0aXZpdHlfdGMYDiADKAFSE3Bvd2RlclNlbnNpdGl2aXR5VGMSNwoYcG93ZGVyX3Nlbn'
    'NpdGl2aXR5X3ZfbXBzGA8gAygBUhVwb3dkZXJTZW5zaXRpdml0eVZNcHMSMwoXbXVsdGlfYmNf'
    'dGFibGVfZzFfdl9tcHMYECADKAFSEm11bHRpQmNUYWJsZUcxVk1wcxIuChRtdWx0aV9iY190YW'
    'JsZV9nMV9iYxgRIAMoAVIQbXVsdGlCY1RhYmxlRzFCYxIzChdtdWx0aV9iY190YWJsZV9nN192'
    'X21wcxgSIAMoAVISbXVsdGlCY1RhYmxlRzdWTXBzEi4KFG11bHRpX2JjX3RhYmxlX2c3X2JjGB'
    'MgAygBUhBtdWx0aUJjVGFibGVHN0JjEjMKFmN1c3RvbV9kcmFnX3RhYmxlX21hY2gYFCADKAFS'
    'E2N1c3RvbURyYWdUYWJsZU1hY2gSLwoUY3VzdG9tX2RyYWdfdGFibGVfY2QYFSADKAFSEWN1c3'
    'RvbURyYWdUYWJsZUNkEiAKBHplcm8YFiABKAsyDC5lYmNfZGIuWmVyb1IEemVybxInCg9wcm9q'
    'ZWN0aWxlX25hbWUYFyABKAlSDnByb2plY3RpbGVOYW1lEhYKBnZlbmRvchgYIAEoCVIGdmVuZG'
    '9yEhQKBWltYWdlGBkgASgJUgVpbWFnZUIPCg1fY2FsaWJlcl9pbmNoQg8KDV93ZWlnaHRfZ3Jh'
    'aW5CDgoMX2xlbmd0aF9pbmNoQggKBl9iY19nMUIICgZfYmNfZzdCFgoUX211enpsZV92ZWxvY2'
    'l0eV9tcHM=');

@$core.Deprecated('Use zeroDescriptor instead')
const Zero$json = {
  '1': 'Zero',
  '2': [
    {'1': 'distance_meter', '3': 1, '4': 1, '5': 1, '10': 'distanceMeter'},
    {'1': 'look_angle_rad', '3': 2, '4': 1, '5': 1, '10': 'lookAngleRad'},
    {'1': 'altitude_meter', '3': 3, '4': 1, '5': 1, '10': 'altitudeMeter'},
    {'1': 'temperature_c', '3': 4, '4': 1, '5': 1, '10': 'temperatureC'},
    {'1': 'pressure_h_pa', '3': 5, '4': 1, '5': 1, '10': 'pressureHPa'},
    {'1': 'humidity_frac', '3': 6, '4': 1, '5': 1, '10': 'humidityFrac'},
    {
      '1': 'use_diff_powder_temperature',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'useDiffPowderTemperature'
    },
    {'1': 'use_coriolis', '3': 8, '4': 1, '5': 8, '10': 'useCoriolis'},
    {
      '1': 'powder_temperature_c',
      '3': 9,
      '4': 1,
      '5': 1,
      '10': 'powderTemperatureC'
    },
    {'1': 'latitude_deg', '3': 10, '4': 1, '5': 1, '10': 'latitudeDeg'},
    {'1': 'azimuth_deg', '3': 11, '4': 1, '5': 1, '10': 'azimuthDeg'},
    {'1': 'offset_x', '3': 12, '4': 1, '5': 1, '10': 'offsetX'},
    {'1': 'offset_y', '3': 13, '4': 1, '5': 1, '10': 'offsetY'},
    {'1': 'offset_x_unit', '3': 14, '4': 1, '5': 9, '10': 'offsetXUnit'},
    {'1': 'offset_y_unit', '3': 15, '4': 1, '5': 9, '10': 'offsetYUnit'},
  ],
};

/// Descriptor for `Zero`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List zeroDescriptor = $convert.base64Decode(
    'CgRaZXJvEiUKDmRpc3RhbmNlX21ldGVyGAEgASgBUg1kaXN0YW5jZU1ldGVyEiQKDmxvb2tfYW'
    '5nbGVfcmFkGAIgASgBUgxsb29rQW5nbGVSYWQSJQoOYWx0aXR1ZGVfbWV0ZXIYAyABKAFSDWFs'
    'dGl0dWRlTWV0ZXISIwoNdGVtcGVyYXR1cmVfYxgEIAEoAVIMdGVtcGVyYXR1cmVDEiIKDXByZX'
    'NzdXJlX2hfcGEYBSABKAFSC3ByZXNzdXJlSFBhEiMKDWh1bWlkaXR5X2ZyYWMYBiABKAFSDGh1'
    'bWlkaXR5RnJhYxI9Cht1c2VfZGlmZl9wb3dkZXJfdGVtcGVyYXR1cmUYByABKAhSGHVzZURpZm'
    'ZQb3dkZXJUZW1wZXJhdHVyZRIhCgx1c2VfY29yaW9saXMYCCABKAhSC3VzZUNvcmlvbGlzEjAK'
    'FHBvd2Rlcl90ZW1wZXJhdHVyZV9jGAkgASgBUhJwb3dkZXJUZW1wZXJhdHVyZUMSIQoMbGF0aX'
    'R1ZGVfZGVnGAogASgBUgtsYXRpdHVkZURlZxIfCgthemltdXRoX2RlZxgLIAEoAVIKYXppbXV0'
    'aERlZxIZCghvZmZzZXRfeBgMIAEoAVIHb2Zmc2V0WBIZCghvZmZzZXRfeRgNIAEoAVIHb2Zmc2'
    'V0WRIiCg1vZmZzZXRfeF91bml0GA4gASgJUgtvZmZzZXRYVW5pdBIiCg1vZmZzZXRfeV91bml0'
    'GA8gASgJUgtvZmZzZXRZVW5pdA==');

@$core.Deprecated('Use profileDescriptor instead')
const Profile$json = {
  '1': 'Profile',
  '2': [
    {'1': 'ui_key', '3': 1, '4': 1, '5': 9, '10': 'uiKey'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'weapon',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.Weapon',
      '10': 'weapon'
    },
    {'1': 'ammo', '3': 4, '4': 1, '5': 11, '6': '.ebc_db.Ammo', '10': 'ammo'},
    {
      '1': 'sight',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.Sight',
      '10': 'sight'
    },
  ],
};

/// Descriptor for `Profile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileDescriptor = $convert.base64Decode(
    'CgdQcm9maWxlEhUKBnVpX2tleRgBIAEoCVIFdWlLZXkSEgoEbmFtZRgCIAEoCVIEbmFtZRImCg'
    'Z3ZWFwb24YAyABKAsyDi5lYmNfZGIuV2VhcG9uUgZ3ZWFwb24SIAoEYW1tbxgEIAEoCzIMLmVi'
    'Y19kYi5BbW1vUgRhbW1vEiMKBXNpZ2h0GAUgASgLMg0uZWJjX2RiLlNpZ2h0UgVzaWdodA==');

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
      '6': '.ebc_db.UnitValue',
      '10': 'length'
    },
    {
      '1': 'weight',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.UnitValue',
      '10': 'weight'
    },
    {
      '1': 'pressure',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.UnitValue',
      '10': 'pressure'
    },
    {
      '1': 'temperature',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.UnitValue',
      '10': 'temperature'
    },
    {
      '1': 'torque',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.UnitValue',
      '10': 'torque'
    },
    {
      '1': 'angles',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.AnglesConv',
      '10': 'angles'
    },
    {
      '1': 'velocity',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.VelocityConv',
      '10': 'velocity'
    },
    {
      '1': 'distance_conv_target_size',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.DistanceConvTargetSize',
      '10': 'distanceConvTargetSize'
    },
  ],
};

/// Descriptor for `ConvertorsState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List convertorsStateDescriptor = $convert.base64Decode(
    'Cg9Db252ZXJ0b3JzU3RhdGUSKQoGbGVuZ3RoGAEgASgLMhEuZWJjX2RiLlVuaXRWYWx1ZVIGbG'
    'VuZ3RoEikKBndlaWdodBgCIAEoCzIRLmViY19kYi5Vbml0VmFsdWVSBndlaWdodBItCghwcmVz'
    'c3VyZRgDIAEoCzIRLmViY19kYi5Vbml0VmFsdWVSCHByZXNzdXJlEjMKC3RlbXBlcmF0dXJlGA'
    'QgASgLMhEuZWJjX2RiLlVuaXRWYWx1ZVILdGVtcGVyYXR1cmUSKQoGdG9ycXVlGAUgASgLMhEu'
    'ZWJjX2RiLlVuaXRWYWx1ZVIGdG9ycXVlEioKBmFuZ2xlcxgGIAEoCzISLmViY19kYi5BbmdsZX'
    'NDb252UgZhbmdsZXMSMAoIdmVsb2NpdHkYByABKAsyFC5lYmNfZGIuVmVsb2NpdHlDb252Ugh2'
    'ZWxvY2l0eRJZChlkaXN0YW5jZV9jb252X3RhcmdldF9zaXplGAggASgLMh4uZWJjX2RiLkRpc3'
    'RhbmNlQ29udlRhcmdldFNpemVSFmRpc3RhbmNlQ29udlRhcmdldFNpemU=');

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

@$core.Deprecated('Use dbDescriptor instead')
const Db$json = {
  '1': 'Db',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 13, '10': 'schemaVersion'},
    {
      '1': 'general_settings',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.GeneralSettings',
      '10': 'generalSettings'
    },
    {
      '1': 'unit_settings',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.UnitSettings',
      '10': 'unitSettings'
    },
    {
      '1': 'tables_settings',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.TablesSettings',
      '10': 'tablesSettings'
    },
    {
      '1': 'reticle_settings',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.ReticleSettings',
      '10': 'reticleSettings'
    },
    {
      '1': 'convertors_state',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.ConvertorsState',
      '10': 'convertorsState'
    },
    {
      '1': 'shooting_conditions',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.ebc_db.ShootingConditions',
      '10': 'shootingConditions'
    },
    {
      '1': 'profiles',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.ebc_db.Profile',
      '10': 'profiles'
    },
  ],
};

/// Descriptor for `Db`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dbDescriptor = $convert.base64Decode(
    'CgJEYhIlCg5zY2hlbWFfdmVyc2lvbhgBIAEoDVINc2NoZW1hVmVyc2lvbhJCChBnZW5lcmFsX3'
    'NldHRpbmdzGAIgASgLMhcuZWJjX2RiLkdlbmVyYWxTZXR0aW5nc1IPZ2VuZXJhbFNldHRpbmdz'
    'EjkKDXVuaXRfc2V0dGluZ3MYAyABKAsyFC5lYmNfZGIuVW5pdFNldHRpbmdzUgx1bml0U2V0dG'
    'luZ3MSPwoPdGFibGVzX3NldHRpbmdzGAQgASgLMhYuZWJjX2RiLlRhYmxlc1NldHRpbmdzUg50'
    'YWJsZXNTZXR0aW5ncxJCChByZXRpY2xlX3NldHRpbmdzGAUgASgLMhcuZWJjX2RiLlJldGljbG'
    'VTZXR0aW5nc1IPcmV0aWNsZVNldHRpbmdzEkIKEGNvbnZlcnRvcnNfc3RhdGUYBiABKAsyFy5l'
    'YmNfZGIuQ29udmVydG9yc1N0YXRlUg9jb252ZXJ0b3JzU3RhdGUSSwoTc2hvb3RpbmdfY29uZG'
    'l0aW9ucxgHIAEoCzIaLmViY19kYi5TaG9vdGluZ0NvbmRpdGlvbnNSEnNob290aW5nQ29uZGl0'
    'aW9ucxIrCghwcm9maWxlcxgIIAMoCzIPLmViY19kYi5Qcm9maWxlUghwcm9maWxlcw==');
