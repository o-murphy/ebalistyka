// This is a generated file - do not edit.
//
// Generated from ebcp.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'profiles.pb.dart' as $0;
import 'settings.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// The shareable/exportable .ebcp container — successor to today's ZIP+JSON
/// .ebcp format. Bundles one or more ProfilesData blocks and, optionally,
/// one SettingsData block into a single MD5-hex + protobuf-bytes file (same
/// wire convention as profiles.ebcp/settings.ebcp).
class EbcpData extends $pb.GeneratedMessage {
  factory EbcpData({
    $core.int? schemaVersion,
    $core.Iterable<$0.ProfilesData>? profilesData,
    $1.SettingsData? settingsData,
  }) {
    final result = create();
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (profilesData != null) result.profilesData.addAll(profilesData);
    if (settingsData != null) result.settingsData = settingsData;
    return result;
  }

  EbcpData._();

  factory EbcpData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EbcpData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EbcpData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebcp'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'schemaVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<$0.ProfilesData>(2, _omitFieldNames ? '' : 'profilesData',
        subBuilder: $0.ProfilesData.create)
    ..aOM<$1.SettingsData>(3, _omitFieldNames ? '' : 'settingsData',
        subBuilder: $1.SettingsData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EbcpData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EbcpData copyWith(void Function(EbcpData) updates) =>
      super.copyWith((message) => updates(message as EbcpData)) as EbcpData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EbcpData create() => EbcpData._();
  @$core.override
  EbcpData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EbcpData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EbcpData>(create);
  static EbcpData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schemaVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set schemaVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$0.ProfilesData> get profilesData => $_getList(1);

  @$pb.TagNumber(3)
  $1.SettingsData get settingsData => $_getN(2);
  @$pb.TagNumber(3)
  set settingsData($1.SettingsData value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSettingsData() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettingsData() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.SettingsData ensureSettingsData() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
