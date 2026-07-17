// This is a generated file - do not edit.
//
// Generated from profiles.proto.

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
    {
      '1': 'zero',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.profiles.Zero',
      '10': 'zero'
    },
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
    'RvbURyYWdUYWJsZUNkEiIKBHplcm8YFiABKAsyDi5wcm9maWxlcy5aZXJvUgR6ZXJvEicKD3By'
    'b2plY3RpbGVfbmFtZRgXIAEoCVIOcHJvamVjdGlsZU5hbWUSFgoGdmVuZG9yGBggASgJUgZ2ZW'
    '5kb3ISFAoFaW1hZ2UYGSABKAlSBWltYWdlQg8KDV9jYWxpYmVyX2luY2hCDwoNX3dlaWdodF9n'
    'cmFpbkIOCgxfbGVuZ3RoX2luY2hCCAoGX2JjX2cxQggKBl9iY19nN0IWChRfbXV6emxlX3ZlbG'
    '9jaXR5X21wcw==');

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
    {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'weapon',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.profiles.Weapon',
      '10': 'weapon'
    },
    {'1': 'ammo', '3': 4, '4': 1, '5': 11, '6': '.profiles.Ammo', '10': 'ammo'},
    {
      '1': 'sight',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.profiles.Sight',
      '10': 'sight'
    },
  ],
};

/// Descriptor for `Profile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileDescriptor = $convert.base64Decode(
    'CgdQcm9maWxlEhIKBHV1aWQYASABKAlSBHV1aWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIoCgZ3ZW'
    'Fwb24YAyABKAsyEC5wcm9maWxlcy5XZWFwb25SBndlYXBvbhIiCgRhbW1vGAQgASgLMg4ucHJv'
    'ZmlsZXMuQW1tb1IEYW1tbxIlCgVzaWdodBgFIAEoCzIPLnByb2ZpbGVzLlNpZ2h0UgVzaWdodA'
    '==');

@$core.Deprecated('Use profilesDataDescriptor instead')
const ProfilesData$json = {
  '1': 'ProfilesData',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 13, '10': 'schemaVersion'},
    {
      '1': 'profiles',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.profiles.Profile',
      '10': 'profiles'
    },
  ],
};

/// Descriptor for `ProfilesData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profilesDataDescriptor = $convert.base64Decode(
    'CgxQcm9maWxlc0RhdGESJQoOc2NoZW1hX3ZlcnNpb24YASABKA1SDXNjaGVtYVZlcnNpb24SLQ'
    'oIcHJvZmlsZXMYAiADKAsyES5wcm9maWxlcy5Qcm9maWxlUghwcm9maWxlcw==');
