// This is a generated file - do not edit.
//
// Generated from profiles.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Weapon extends $pb.GeneratedMessage {
  factory Weapon({
    $core.String? name,
    $core.double? caliberInch,
    $core.String? caliberName,
    $core.double? twistInch,
    $core.double? barrelLengthInch,
    $core.double? zeroElevationRad,
    $core.String? vendor,
    $core.String? notes,
    $core.String? image,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (caliberInch != null) result.caliberInch = caliberInch;
    if (caliberName != null) result.caliberName = caliberName;
    if (twistInch != null) result.twistInch = twistInch;
    if (barrelLengthInch != null) result.barrelLengthInch = barrelLengthInch;
    if (zeroElevationRad != null) result.zeroElevationRad = zeroElevationRad;
    if (vendor != null) result.vendor = vendor;
    if (notes != null) result.notes = notes;
    if (image != null) result.image = image;
    return result;
  }

  Weapon._();

  factory Weapon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Weapon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Weapon',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'profiles'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aD(2, _omitFieldNames ? '' : 'caliberInch')
    ..aOS(3, _omitFieldNames ? '' : 'caliberName')
    ..aD(4, _omitFieldNames ? '' : 'twistInch')
    ..aD(5, _omitFieldNames ? '' : 'barrelLengthInch')
    ..aD(6, _omitFieldNames ? '' : 'zeroElevationRad')
    ..aOS(7, _omitFieldNames ? '' : 'vendor')
    ..aOS(8, _omitFieldNames ? '' : 'notes')
    ..aOS(9, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Weapon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Weapon copyWith(void Function(Weapon) updates) =>
      super.copyWith((message) => updates(message as Weapon)) as Weapon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Weapon create() => Weapon._();
  @$core.override
  Weapon createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Weapon getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Weapon>(create);
  static Weapon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get caliberInch => $_getN(1);
  @$pb.TagNumber(2)
  set caliberInch($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaliberInch() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaliberInch() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get caliberName => $_getSZ(2);
  @$pb.TagNumber(3)
  set caliberName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCaliberName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCaliberName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get twistInch => $_getN(3);
  @$pb.TagNumber(4)
  set twistInch($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTwistInch() => $_has(3);
  @$pb.TagNumber(4)
  void clearTwistInch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get barrelLengthInch => $_getN(4);
  @$pb.TagNumber(5)
  set barrelLengthInch($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBarrelLengthInch() => $_has(4);
  @$pb.TagNumber(5)
  void clearBarrelLengthInch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get zeroElevationRad => $_getN(5);
  @$pb.TagNumber(6)
  set zeroElevationRad($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasZeroElevationRad() => $_has(5);
  @$pb.TagNumber(6)
  void clearZeroElevationRad() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get vendor => $_getSZ(6);
  @$pb.TagNumber(7)
  set vendor($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVendor() => $_has(6);
  @$pb.TagNumber(7)
  void clearVendor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get notes => $_getSZ(7);
  @$pb.TagNumber(8)
  set notes($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNotes() => $_has(7);
  @$pb.TagNumber(8)
  void clearNotes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get image => $_getSZ(8);
  @$pb.TagNumber(9)
  set image($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasImage() => $_has(8);
  @$pb.TagNumber(9)
  void clearImage() => $_clearField(9);
}

class Sight extends $pb.GeneratedMessage {
  factory Sight({
    $core.String? name,
    $core.String? focalPlaneValue,
    $core.double? sightHeightInch,
    $core.double? sightHorizontalOffsetInch,
    $core.double? verticalClick,
    $core.double? horizontalClick,
    $core.String? verticalClickUnit,
    $core.String? horizontalClickUnit,
    $core.double? minMagnification,
    $core.double? maxMagnification,
    $core.String? reticleImage,
    $core.double? calibratedMagnification,
    $core.String? vendor,
    $core.String? notes,
    $core.String? image,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (focalPlaneValue != null) result.focalPlaneValue = focalPlaneValue;
    if (sightHeightInch != null) result.sightHeightInch = sightHeightInch;
    if (sightHorizontalOffsetInch != null)
      result.sightHorizontalOffsetInch = sightHorizontalOffsetInch;
    if (verticalClick != null) result.verticalClick = verticalClick;
    if (horizontalClick != null) result.horizontalClick = horizontalClick;
    if (verticalClickUnit != null) result.verticalClickUnit = verticalClickUnit;
    if (horizontalClickUnit != null)
      result.horizontalClickUnit = horizontalClickUnit;
    if (minMagnification != null) result.minMagnification = minMagnification;
    if (maxMagnification != null) result.maxMagnification = maxMagnification;
    if (reticleImage != null) result.reticleImage = reticleImage;
    if (calibratedMagnification != null)
      result.calibratedMagnification = calibratedMagnification;
    if (vendor != null) result.vendor = vendor;
    if (notes != null) result.notes = notes;
    if (image != null) result.image = image;
    return result;
  }

  Sight._();

  factory Sight.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Sight.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Sight',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'profiles'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'focalPlaneValue')
    ..aD(3, _omitFieldNames ? '' : 'sightHeightInch')
    ..aD(4, _omitFieldNames ? '' : 'sightHorizontalOffsetInch')
    ..aD(5, _omitFieldNames ? '' : 'verticalClick')
    ..aD(6, _omitFieldNames ? '' : 'horizontalClick')
    ..aOS(7, _omitFieldNames ? '' : 'verticalClickUnit')
    ..aOS(8, _omitFieldNames ? '' : 'horizontalClickUnit')
    ..aD(9, _omitFieldNames ? '' : 'minMagnification')
    ..aD(10, _omitFieldNames ? '' : 'maxMagnification')
    ..aOS(11, _omitFieldNames ? '' : 'reticleImage')
    ..aD(12, _omitFieldNames ? '' : 'calibratedMagnification')
    ..aOS(13, _omitFieldNames ? '' : 'vendor')
    ..aOS(14, _omitFieldNames ? '' : 'notes')
    ..aOS(15, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Sight clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Sight copyWith(void Function(Sight) updates) =>
      super.copyWith((message) => updates(message as Sight)) as Sight;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Sight create() => Sight._();
  @$core.override
  Sight createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Sight getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sight>(create);
  static Sight? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get focalPlaneValue => $_getSZ(1);
  @$pb.TagNumber(2)
  set focalPlaneValue($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFocalPlaneValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearFocalPlaneValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get sightHeightInch => $_getN(2);
  @$pb.TagNumber(3)
  set sightHeightInch($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSightHeightInch() => $_has(2);
  @$pb.TagNumber(3)
  void clearSightHeightInch() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get sightHorizontalOffsetInch => $_getN(3);
  @$pb.TagNumber(4)
  set sightHorizontalOffsetInch($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSightHorizontalOffsetInch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSightHorizontalOffsetInch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get verticalClick => $_getN(4);
  @$pb.TagNumber(5)
  set verticalClick($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVerticalClick() => $_has(4);
  @$pb.TagNumber(5)
  void clearVerticalClick() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get horizontalClick => $_getN(5);
  @$pb.TagNumber(6)
  set horizontalClick($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHorizontalClick() => $_has(5);
  @$pb.TagNumber(6)
  void clearHorizontalClick() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get verticalClickUnit => $_getSZ(6);
  @$pb.TagNumber(7)
  set verticalClickUnit($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVerticalClickUnit() => $_has(6);
  @$pb.TagNumber(7)
  void clearVerticalClickUnit() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get horizontalClickUnit => $_getSZ(7);
  @$pb.TagNumber(8)
  set horizontalClickUnit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHorizontalClickUnit() => $_has(7);
  @$pb.TagNumber(8)
  void clearHorizontalClickUnit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get minMagnification => $_getN(8);
  @$pb.TagNumber(9)
  set minMagnification($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMinMagnification() => $_has(8);
  @$pb.TagNumber(9)
  void clearMinMagnification() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get maxMagnification => $_getN(9);
  @$pb.TagNumber(10)
  set maxMagnification($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMaxMagnification() => $_has(9);
  @$pb.TagNumber(10)
  void clearMaxMagnification() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get reticleImage => $_getSZ(10);
  @$pb.TagNumber(11)
  set reticleImage($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReticleImage() => $_has(10);
  @$pb.TagNumber(11)
  void clearReticleImage() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get calibratedMagnification => $_getN(11);
  @$pb.TagNumber(12)
  set calibratedMagnification($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCalibratedMagnification() => $_has(11);
  @$pb.TagNumber(12)
  void clearCalibratedMagnification() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get vendor => $_getSZ(12);
  @$pb.TagNumber(13)
  set vendor($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasVendor() => $_has(12);
  @$pb.TagNumber(13)
  void clearVendor() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get notes => $_getSZ(13);
  @$pb.TagNumber(14)
  set notes($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNotes() => $_has(13);
  @$pb.TagNumber(14)
  void clearNotes() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get image => $_getSZ(14);
  @$pb.TagNumber(15)
  set image($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasImage() => $_has(14);
  @$pb.TagNumber(15)
  void clearImage() => $_clearField(15);
}

/// One velocity/BC breakpoint of a multi-BC (velocity-dependent) drag table.
/// Replaces the earlier multi_bc_table_g{1,7}_v_mps/_bc parallel-array pair —
/// a single repeated field makes a v_mps/bc length mismatch inexpressible,
/// rather than merely unchecked (see
/// docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7's "Repeated-field
/// length" note).
class MultiBcPoint extends $pb.GeneratedMessage {
  factory MultiBcPoint({
    $core.double? vMps,
    $core.double? bc,
  }) {
    final result = create();
    if (vMps != null) result.vMps = vMps;
    if (bc != null) result.bc = bc;
    return result;
  }

  MultiBcPoint._();

  factory MultiBcPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MultiBcPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MultiBcPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'profiles'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'vMps')
    ..aD(2, _omitFieldNames ? '' : 'bc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiBcPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiBcPoint copyWith(void Function(MultiBcPoint) updates) =>
      super.copyWith((message) => updates(message as MultiBcPoint))
          as MultiBcPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiBcPoint create() => MultiBcPoint._();
  @$core.override
  MultiBcPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MultiBcPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MultiBcPoint>(create);
  static MultiBcPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get vMps => $_getN(0);
  @$pb.TagNumber(1)
  set vMps($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVMps() => $_has(0);
  @$pb.TagNumber(1)
  void clearVMps() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get bc => $_getN(1);
  @$pb.TagNumber(2)
  set bc($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBc() => $_has(1);
  @$pb.TagNumber(2)
  void clearBc() => $_clearField(2);
}

class Ammo extends $pb.GeneratedMessage {
  factory Ammo({
    $core.String? name,
    $core.double? caliberInch,
    $core.double? weightGrain,
    $core.double? lengthInch,
    $core.String? dragTypeValue,
    $core.double? bcG1,
    $core.double? bcG7,
    $core.bool? useMultiBcG1,
    $core.bool? useMultiBcG7,
    $core.double? muzzleVelocityMps,
    $core.double? muzzleVelocityTemperatureC,
    $core.bool? usePowderSensitivity,
    $core.double? powderSensitivityFrac,
    $core.Iterable<$core.double>? powderSensitivityTc,
    $core.Iterable<$core.double>? powderSensitivityVMps,
    $core.Iterable<MultiBcPoint>? multiBcTableG1,
    $core.Iterable<MultiBcPoint>? multiBcTableG7,
    $core.Iterable<$core.double>? customDragTableMach,
    $core.Iterable<$core.double>? customDragTableCd,
    Zero? zero,
    $core.String? projectileName,
    $core.String? vendor,
    $core.String? image,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (caliberInch != null) result.caliberInch = caliberInch;
    if (weightGrain != null) result.weightGrain = weightGrain;
    if (lengthInch != null) result.lengthInch = lengthInch;
    if (dragTypeValue != null) result.dragTypeValue = dragTypeValue;
    if (bcG1 != null) result.bcG1 = bcG1;
    if (bcG7 != null) result.bcG7 = bcG7;
    if (useMultiBcG1 != null) result.useMultiBcG1 = useMultiBcG1;
    if (useMultiBcG7 != null) result.useMultiBcG7 = useMultiBcG7;
    if (muzzleVelocityMps != null) result.muzzleVelocityMps = muzzleVelocityMps;
    if (muzzleVelocityTemperatureC != null)
      result.muzzleVelocityTemperatureC = muzzleVelocityTemperatureC;
    if (usePowderSensitivity != null)
      result.usePowderSensitivity = usePowderSensitivity;
    if (powderSensitivityFrac != null)
      result.powderSensitivityFrac = powderSensitivityFrac;
    if (powderSensitivityTc != null)
      result.powderSensitivityTc.addAll(powderSensitivityTc);
    if (powderSensitivityVMps != null)
      result.powderSensitivityVMps.addAll(powderSensitivityVMps);
    if (multiBcTableG1 != null) result.multiBcTableG1.addAll(multiBcTableG1);
    if (multiBcTableG7 != null) result.multiBcTableG7.addAll(multiBcTableG7);
    if (customDragTableMach != null)
      result.customDragTableMach.addAll(customDragTableMach);
    if (customDragTableCd != null)
      result.customDragTableCd.addAll(customDragTableCd);
    if (zero != null) result.zero = zero;
    if (projectileName != null) result.projectileName = projectileName;
    if (vendor != null) result.vendor = vendor;
    if (image != null) result.image = image;
    return result;
  }

  Ammo._();

  factory Ammo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ammo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ammo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'profiles'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aD(2, _omitFieldNames ? '' : 'caliberInch')
    ..aD(3, _omitFieldNames ? '' : 'weightGrain')
    ..aD(4, _omitFieldNames ? '' : 'lengthInch')
    ..aOS(5, _omitFieldNames ? '' : 'dragTypeValue')
    ..aD(6, _omitFieldNames ? '' : 'bcG1')
    ..aD(7, _omitFieldNames ? '' : 'bcG7')
    ..aOB(8, _omitFieldNames ? '' : 'useMultiBcG1')
    ..aOB(9, _omitFieldNames ? '' : 'useMultiBcG7')
    ..aD(10, _omitFieldNames ? '' : 'muzzleVelocityMps')
    ..aD(11, _omitFieldNames ? '' : 'muzzleVelocityTemperatureC')
    ..aOB(12, _omitFieldNames ? '' : 'usePowderSensitivity')
    ..aD(13, _omitFieldNames ? '' : 'powderSensitivityFrac')
    ..p<$core.double>(
        14, _omitFieldNames ? '' : 'powderSensitivityTc', $pb.PbFieldType.KD)
    ..p<$core.double>(
        15, _omitFieldNames ? '' : 'powderSensitivityVMps', $pb.PbFieldType.KD)
    ..pPM<MultiBcPoint>(16, _omitFieldNames ? '' : 'multiBcTableG1',
        subBuilder: MultiBcPoint.create)
    ..pPM<MultiBcPoint>(18, _omitFieldNames ? '' : 'multiBcTableG7',
        subBuilder: MultiBcPoint.create)
    ..p<$core.double>(
        20, _omitFieldNames ? '' : 'customDragTableMach', $pb.PbFieldType.KD)
    ..p<$core.double>(
        21, _omitFieldNames ? '' : 'customDragTableCd', $pb.PbFieldType.KD)
    ..aOM<Zero>(22, _omitFieldNames ? '' : 'zero', subBuilder: Zero.create)
    ..aOS(23, _omitFieldNames ? '' : 'projectileName')
    ..aOS(24, _omitFieldNames ? '' : 'vendor')
    ..aOS(25, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ammo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ammo copyWith(void Function(Ammo) updates) =>
      super.copyWith((message) => updates(message as Ammo)) as Ammo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ammo create() => Ammo._();
  @$core.override
  Ammo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ammo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ammo>(create);
  static Ammo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get caliberInch => $_getN(1);
  @$pb.TagNumber(2)
  set caliberInch($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaliberInch() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaliberInch() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get weightGrain => $_getN(2);
  @$pb.TagNumber(3)
  set weightGrain($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWeightGrain() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeightGrain() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get lengthInch => $_getN(3);
  @$pb.TagNumber(4)
  set lengthInch($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLengthInch() => $_has(3);
  @$pb.TagNumber(4)
  void clearLengthInch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dragTypeValue => $_getSZ(4);
  @$pb.TagNumber(5)
  set dragTypeValue($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDragTypeValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearDragTypeValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get bcG1 => $_getN(5);
  @$pb.TagNumber(6)
  set bcG1($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBcG1() => $_has(5);
  @$pb.TagNumber(6)
  void clearBcG1() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get bcG7 => $_getN(6);
  @$pb.TagNumber(7)
  set bcG7($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBcG7() => $_has(6);
  @$pb.TagNumber(7)
  void clearBcG7() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get useMultiBcG1 => $_getBF(7);
  @$pb.TagNumber(8)
  set useMultiBcG1($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUseMultiBcG1() => $_has(7);
  @$pb.TagNumber(8)
  void clearUseMultiBcG1() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get useMultiBcG7 => $_getBF(8);
  @$pb.TagNumber(9)
  set useMultiBcG7($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUseMultiBcG7() => $_has(8);
  @$pb.TagNumber(9)
  void clearUseMultiBcG7() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get muzzleVelocityMps => $_getN(9);
  @$pb.TagNumber(10)
  set muzzleVelocityMps($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMuzzleVelocityMps() => $_has(9);
  @$pb.TagNumber(10)
  void clearMuzzleVelocityMps() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get muzzleVelocityTemperatureC => $_getN(10);
  @$pb.TagNumber(11)
  set muzzleVelocityTemperatureC($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMuzzleVelocityTemperatureC() => $_has(10);
  @$pb.TagNumber(11)
  void clearMuzzleVelocityTemperatureC() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get usePowderSensitivity => $_getBF(11);
  @$pb.TagNumber(12)
  set usePowderSensitivity($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUsePowderSensitivity() => $_has(11);
  @$pb.TagNumber(12)
  void clearUsePowderSensitivity() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get powderSensitivityFrac => $_getN(12);
  @$pb.TagNumber(13)
  set powderSensitivityFrac($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPowderSensitivityFrac() => $_has(12);
  @$pb.TagNumber(13)
  void clearPowderSensitivityFrac() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<$core.double> get powderSensitivityTc => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<$core.double> get powderSensitivityVMps => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<MultiBcPoint> get multiBcTableG1 => $_getList(15);

  @$pb.TagNumber(18)
  $pb.PbList<MultiBcPoint> get multiBcTableG7 => $_getList(16);

  @$pb.TagNumber(20)
  $pb.PbList<$core.double> get customDragTableMach => $_getList(17);

  @$pb.TagNumber(21)
  $pb.PbList<$core.double> get customDragTableCd => $_getList(18);

  @$pb.TagNumber(22)
  Zero get zero => $_getN(19);
  @$pb.TagNumber(22)
  set zero(Zero value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasZero() => $_has(19);
  @$pb.TagNumber(22)
  void clearZero() => $_clearField(22);
  @$pb.TagNumber(22)
  Zero ensureZero() => $_ensure(19);

  @$pb.TagNumber(23)
  $core.String get projectileName => $_getSZ(20);
  @$pb.TagNumber(23)
  set projectileName($core.String value) => $_setString(20, value);
  @$pb.TagNumber(23)
  $core.bool hasProjectileName() => $_has(20);
  @$pb.TagNumber(23)
  void clearProjectileName() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get vendor => $_getSZ(21);
  @$pb.TagNumber(24)
  set vendor($core.String value) => $_setString(21, value);
  @$pb.TagNumber(24)
  $core.bool hasVendor() => $_has(21);
  @$pb.TagNumber(24)
  void clearVendor() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get image => $_getSZ(22);
  @$pb.TagNumber(25)
  set image($core.String value) => $_setString(22, value);
  @$pb.TagNumber(25)
  $core.bool hasImage() => $_has(22);
  @$pb.TagNumber(25)
  void clearImage() => $_clearField(25);
}

class Zero extends $pb.GeneratedMessage {
  factory Zero({
    $core.double? distanceMeter,
    $core.double? lookAngleRad,
    $core.double? altitudeMeter,
    $core.double? temperatureC,
    $core.double? pressureHPa,
    $core.double? humidityFrac,
    $core.bool? useDiffPowderTemperature,
    $core.bool? useCoriolis,
    $core.double? powderTemperatureC,
    $core.double? latitudeDeg,
    $core.double? azimuthDeg,
    $core.double? offsetX,
    $core.double? offsetY,
    $core.String? offsetXUnit,
    $core.String? offsetYUnit,
  }) {
    final result = create();
    if (distanceMeter != null) result.distanceMeter = distanceMeter;
    if (lookAngleRad != null) result.lookAngleRad = lookAngleRad;
    if (altitudeMeter != null) result.altitudeMeter = altitudeMeter;
    if (temperatureC != null) result.temperatureC = temperatureC;
    if (pressureHPa != null) result.pressureHPa = pressureHPa;
    if (humidityFrac != null) result.humidityFrac = humidityFrac;
    if (useDiffPowderTemperature != null)
      result.useDiffPowderTemperature = useDiffPowderTemperature;
    if (useCoriolis != null) result.useCoriolis = useCoriolis;
    if (powderTemperatureC != null)
      result.powderTemperatureC = powderTemperatureC;
    if (latitudeDeg != null) result.latitudeDeg = latitudeDeg;
    if (azimuthDeg != null) result.azimuthDeg = azimuthDeg;
    if (offsetX != null) result.offsetX = offsetX;
    if (offsetY != null) result.offsetY = offsetY;
    if (offsetXUnit != null) result.offsetXUnit = offsetXUnit;
    if (offsetYUnit != null) result.offsetYUnit = offsetYUnit;
    return result;
  }

  Zero._();

  factory Zero.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Zero.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Zero',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'profiles'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'distanceMeter')
    ..aD(2, _omitFieldNames ? '' : 'lookAngleRad')
    ..aD(3, _omitFieldNames ? '' : 'altitudeMeter')
    ..aD(4, _omitFieldNames ? '' : 'temperatureC')
    ..aD(5, _omitFieldNames ? '' : 'pressureHPa')
    ..aD(6, _omitFieldNames ? '' : 'humidityFrac')
    ..aOB(7, _omitFieldNames ? '' : 'useDiffPowderTemperature')
    ..aOB(8, _omitFieldNames ? '' : 'useCoriolis')
    ..aD(9, _omitFieldNames ? '' : 'powderTemperatureC')
    ..aD(10, _omitFieldNames ? '' : 'latitudeDeg')
    ..aD(11, _omitFieldNames ? '' : 'azimuthDeg')
    ..aD(12, _omitFieldNames ? '' : 'offsetX')
    ..aD(13, _omitFieldNames ? '' : 'offsetY')
    ..aOS(14, _omitFieldNames ? '' : 'offsetXUnit')
    ..aOS(15, _omitFieldNames ? '' : 'offsetYUnit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Zero clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Zero copyWith(void Function(Zero) updates) =>
      super.copyWith((message) => updates(message as Zero)) as Zero;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Zero create() => Zero._();
  @$core.override
  Zero createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Zero getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Zero>(create);
  static Zero? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get distanceMeter => $_getN(0);
  @$pb.TagNumber(1)
  set distanceMeter($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDistanceMeter() => $_has(0);
  @$pb.TagNumber(1)
  void clearDistanceMeter() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get lookAngleRad => $_getN(1);
  @$pb.TagNumber(2)
  set lookAngleRad($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLookAngleRad() => $_has(1);
  @$pb.TagNumber(2)
  void clearLookAngleRad() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get altitudeMeter => $_getN(2);
  @$pb.TagNumber(3)
  set altitudeMeter($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAltitudeMeter() => $_has(2);
  @$pb.TagNumber(3)
  void clearAltitudeMeter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get temperatureC => $_getN(3);
  @$pb.TagNumber(4)
  set temperatureC($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTemperatureC() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemperatureC() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get pressureHPa => $_getN(4);
  @$pb.TagNumber(5)
  set pressureHPa($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPressureHPa() => $_has(4);
  @$pb.TagNumber(5)
  void clearPressureHPa() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get humidityFrac => $_getN(5);
  @$pb.TagNumber(6)
  set humidityFrac($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHumidityFrac() => $_has(5);
  @$pb.TagNumber(6)
  void clearHumidityFrac() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get useDiffPowderTemperature => $_getBF(6);
  @$pb.TagNumber(7)
  set useDiffPowderTemperature($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUseDiffPowderTemperature() => $_has(6);
  @$pb.TagNumber(7)
  void clearUseDiffPowderTemperature() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get useCoriolis => $_getBF(7);
  @$pb.TagNumber(8)
  set useCoriolis($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUseCoriolis() => $_has(7);
  @$pb.TagNumber(8)
  void clearUseCoriolis() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get powderTemperatureC => $_getN(8);
  @$pb.TagNumber(9)
  set powderTemperatureC($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPowderTemperatureC() => $_has(8);
  @$pb.TagNumber(9)
  void clearPowderTemperatureC() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get latitudeDeg => $_getN(9);
  @$pb.TagNumber(10)
  set latitudeDeg($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLatitudeDeg() => $_has(9);
  @$pb.TagNumber(10)
  void clearLatitudeDeg() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get azimuthDeg => $_getN(10);
  @$pb.TagNumber(11)
  set azimuthDeg($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAzimuthDeg() => $_has(10);
  @$pb.TagNumber(11)
  void clearAzimuthDeg() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get offsetX => $_getN(11);
  @$pb.TagNumber(12)
  set offsetX($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOffsetX() => $_has(11);
  @$pb.TagNumber(12)
  void clearOffsetX() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get offsetY => $_getN(12);
  @$pb.TagNumber(13)
  set offsetY($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasOffsetY() => $_has(12);
  @$pb.TagNumber(13)
  void clearOffsetY() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get offsetXUnit => $_getSZ(13);
  @$pb.TagNumber(14)
  set offsetXUnit($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOffsetXUnit() => $_has(13);
  @$pb.TagNumber(14)
  void clearOffsetXUnit() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get offsetYUnit => $_getSZ(14);
  @$pb.TagNumber(15)
  set offsetYUnit($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOffsetYUnit() => $_has(14);
  @$pb.TagNumber(15)
  void clearOffsetYUnit() => $_clearField(15);
}

class Profile extends $pb.GeneratedMessage {
  factory Profile({
    $core.String? uuid,
    $core.String? name,
    Weapon? weapon,
    Ammo? ammo,
    Sight? sight,
  }) {
    final result = create();
    if (uuid != null) result.uuid = uuid;
    if (name != null) result.name = name;
    if (weapon != null) result.weapon = weapon;
    if (ammo != null) result.ammo = ammo;
    if (sight != null) result.sight = sight;
    return result;
  }

  Profile._();

  factory Profile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Profile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Profile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'profiles'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uuid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<Weapon>(3, _omitFieldNames ? '' : 'weapon', subBuilder: Weapon.create)
    ..aOM<Ammo>(4, _omitFieldNames ? '' : 'ammo', subBuilder: Ammo.create)
    ..aOM<Sight>(5, _omitFieldNames ? '' : 'sight', subBuilder: Sight.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile copyWith(void Function(Profile) updates) =>
      super.copyWith((message) => updates(message as Profile)) as Profile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Profile create() => Profile._();
  @$core.override
  Profile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Profile getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Profile>(create);
  static Profile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  Weapon get weapon => $_getN(2);
  @$pb.TagNumber(3)
  set weapon(Weapon value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWeapon() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeapon() => $_clearField(3);
  @$pb.TagNumber(3)
  Weapon ensureWeapon() => $_ensure(2);

  @$pb.TagNumber(4)
  Ammo get ammo => $_getN(3);
  @$pb.TagNumber(4)
  set ammo(Ammo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAmmo() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmmo() => $_clearField(4);
  @$pb.TagNumber(4)
  Ammo ensureAmmo() => $_ensure(3);

  @$pb.TagNumber(5)
  Sight get sight => $_getN(4);
  @$pb.TagNumber(5)
  set sight(Sight value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSight() => $_has(4);
  @$pb.TagNumber(5)
  void clearSight() => $_clearField(5);
  @$pb.TagNumber(5)
  Sight ensureSight() => $_ensure(4);
}

class ProfilesData extends $pb.GeneratedMessage {
  factory ProfilesData({
    $core.int? schemaVersion,
    $core.Iterable<Profile>? profiles,
  }) {
    final result = create();
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (profiles != null) result.profiles.addAll(profiles);
    return result;
  }

  ProfilesData._();

  factory ProfilesData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProfilesData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfilesData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'profiles'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'schemaVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<Profile>(2, _omitFieldNames ? '' : 'profiles',
        subBuilder: Profile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfilesData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfilesData copyWith(void Function(ProfilesData) updates) =>
      super.copyWith((message) => updates(message as ProfilesData))
          as ProfilesData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProfilesData create() => ProfilesData._();
  @$core.override
  ProfilesData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProfilesData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfilesData>(create);
  static ProfilesData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schemaVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set schemaVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Profile> get profiles => $_getList(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
