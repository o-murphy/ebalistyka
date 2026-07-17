// This is a generated file - do not edit.
//
// Generated from ebcp.proto.

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

@$core.Deprecated('Use ebcpDataDescriptor instead')
const EbcpData$json = {
  '1': 'EbcpData',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 13, '10': 'schemaVersion'},
    {
      '1': 'profiles_data',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.profiles.ProfilesData',
      '10': 'profilesData'
    },
    {
      '1': 'settings_data',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.settings.SettingsData',
      '9': 0,
      '10': 'settingsData',
      '17': true
    },
  ],
  '8': [
    {'1': '_settings_data'},
  ],
};

/// Descriptor for `EbcpData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ebcpDataDescriptor = $convert.base64Decode(
    'CghFYmNwRGF0YRIlCg5zY2hlbWFfdmVyc2lvbhgBIAEoDVINc2NoZW1hVmVyc2lvbhI7Cg1wcm'
    '9maWxlc19kYXRhGAIgAygLMhYucHJvZmlsZXMuUHJvZmlsZXNEYXRhUgxwcm9maWxlc0RhdGES'
    'QAoNc2V0dGluZ3NfZGF0YRgDIAEoCzIWLnNldHRpbmdzLlNldHRpbmdzRGF0YUgAUgxzZXR0aW'
    '5nc0RhdGGIAQFCEAoOX3NldHRpbmdzX2RhdGE=');
