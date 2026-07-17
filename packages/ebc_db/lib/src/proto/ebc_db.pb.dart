// This is a generated file - do not edit.
//
// Generated from ebc_db.proto.

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
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
    $core.String? uiKey,
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
    if (uiKey != null) result.uiKey = uiKey;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uiKey')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'focalPlaneValue')
    ..aD(4, _omitFieldNames ? '' : 'sightHeightInch')
    ..aD(5, _omitFieldNames ? '' : 'sightHorizontalOffsetInch')
    ..aD(6, _omitFieldNames ? '' : 'verticalClick')
    ..aD(7, _omitFieldNames ? '' : 'horizontalClick')
    ..aOS(8, _omitFieldNames ? '' : 'verticalClickUnit')
    ..aOS(9, _omitFieldNames ? '' : 'horizontalClickUnit')
    ..aD(10, _omitFieldNames ? '' : 'minMagnification')
    ..aD(11, _omitFieldNames ? '' : 'maxMagnification')
    ..aOS(12, _omitFieldNames ? '' : 'reticleImage')
    ..aD(13, _omitFieldNames ? '' : 'calibratedMagnification')
    ..aOS(14, _omitFieldNames ? '' : 'vendor')
    ..aOS(15, _omitFieldNames ? '' : 'notes')
    ..aOS(16, _omitFieldNames ? '' : 'image')
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
  $core.String get uiKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set uiKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUiKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearUiKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get focalPlaneValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set focalPlaneValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFocalPlaneValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearFocalPlaneValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get sightHeightInch => $_getN(3);
  @$pb.TagNumber(4)
  set sightHeightInch($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSightHeightInch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSightHeightInch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get sightHorizontalOffsetInch => $_getN(4);
  @$pb.TagNumber(5)
  set sightHorizontalOffsetInch($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSightHorizontalOffsetInch() => $_has(4);
  @$pb.TagNumber(5)
  void clearSightHorizontalOffsetInch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get verticalClick => $_getN(5);
  @$pb.TagNumber(6)
  set verticalClick($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVerticalClick() => $_has(5);
  @$pb.TagNumber(6)
  void clearVerticalClick() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get horizontalClick => $_getN(6);
  @$pb.TagNumber(7)
  set horizontalClick($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHorizontalClick() => $_has(6);
  @$pb.TagNumber(7)
  void clearHorizontalClick() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get verticalClickUnit => $_getSZ(7);
  @$pb.TagNumber(8)
  set verticalClickUnit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVerticalClickUnit() => $_has(7);
  @$pb.TagNumber(8)
  void clearVerticalClickUnit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get horizontalClickUnit => $_getSZ(8);
  @$pb.TagNumber(9)
  set horizontalClickUnit($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHorizontalClickUnit() => $_has(8);
  @$pb.TagNumber(9)
  void clearHorizontalClickUnit() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get minMagnification => $_getN(9);
  @$pb.TagNumber(10)
  set minMagnification($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMinMagnification() => $_has(9);
  @$pb.TagNumber(10)
  void clearMinMagnification() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get maxMagnification => $_getN(10);
  @$pb.TagNumber(11)
  set maxMagnification($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMaxMagnification() => $_has(10);
  @$pb.TagNumber(11)
  void clearMaxMagnification() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get reticleImage => $_getSZ(11);
  @$pb.TagNumber(12)
  set reticleImage($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReticleImage() => $_has(11);
  @$pb.TagNumber(12)
  void clearReticleImage() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get calibratedMagnification => $_getN(12);
  @$pb.TagNumber(13)
  set calibratedMagnification($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCalibratedMagnification() => $_has(12);
  @$pb.TagNumber(13)
  void clearCalibratedMagnification() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get vendor => $_getSZ(13);
  @$pb.TagNumber(14)
  set vendor($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVendor() => $_has(13);
  @$pb.TagNumber(14)
  void clearVendor() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get notes => $_getSZ(14);
  @$pb.TagNumber(15)
  set notes($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNotes() => $_has(14);
  @$pb.TagNumber(15)
  void clearNotes() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get image => $_getSZ(15);
  @$pb.TagNumber(16)
  set image($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasImage() => $_has(15);
  @$pb.TagNumber(16)
  void clearImage() => $_clearField(16);
}

class Ammo extends $pb.GeneratedMessage {
  factory Ammo({
    $core.String? uiKey,
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
    $core.Iterable<$core.double>? multiBcTableG1VMps,
    $core.Iterable<$core.double>? multiBcTableG1Bc,
    $core.Iterable<$core.double>? multiBcTableG7VMps,
    $core.Iterable<$core.double>? multiBcTableG7Bc,
    $core.Iterable<$core.double>? customDragTableMach,
    $core.Iterable<$core.double>? customDragTableCd,
    Zero? zero,
    $core.String? projectileName,
    $core.String? vendor,
    $core.String? image,
  }) {
    final result = create();
    if (uiKey != null) result.uiKey = uiKey;
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
    if (multiBcTableG1VMps != null)
      result.multiBcTableG1VMps.addAll(multiBcTableG1VMps);
    if (multiBcTableG1Bc != null)
      result.multiBcTableG1Bc.addAll(multiBcTableG1Bc);
    if (multiBcTableG7VMps != null)
      result.multiBcTableG7VMps.addAll(multiBcTableG7VMps);
    if (multiBcTableG7Bc != null)
      result.multiBcTableG7Bc.addAll(multiBcTableG7Bc);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uiKey')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aD(3, _omitFieldNames ? '' : 'caliberInch')
    ..aD(4, _omitFieldNames ? '' : 'weightGrain')
    ..aD(5, _omitFieldNames ? '' : 'lengthInch')
    ..aOS(6, _omitFieldNames ? '' : 'dragTypeValue')
    ..aD(7, _omitFieldNames ? '' : 'bcG1')
    ..aD(8, _omitFieldNames ? '' : 'bcG7')
    ..aOB(9, _omitFieldNames ? '' : 'useMultiBcG1')
    ..aOB(10, _omitFieldNames ? '' : 'useMultiBcG7')
    ..aD(11, _omitFieldNames ? '' : 'muzzleVelocityMps')
    ..aD(12, _omitFieldNames ? '' : 'muzzleVelocityTemperatureC')
    ..aOB(13, _omitFieldNames ? '' : 'usePowderSensitivity')
    ..aD(14, _omitFieldNames ? '' : 'powderSensitivityFrac')
    ..p<$core.double>(
        15, _omitFieldNames ? '' : 'powderSensitivityTc', $pb.PbFieldType.KD)
    ..p<$core.double>(
        16, _omitFieldNames ? '' : 'powderSensitivityVMps', $pb.PbFieldType.KD)
    ..p<$core.double>(
        17, _omitFieldNames ? '' : 'multiBcTableG1VMps', $pb.PbFieldType.KD)
    ..p<$core.double>(
        18, _omitFieldNames ? '' : 'multiBcTableG1Bc', $pb.PbFieldType.KD)
    ..p<$core.double>(
        19, _omitFieldNames ? '' : 'multiBcTableG7VMps', $pb.PbFieldType.KD)
    ..p<$core.double>(
        20, _omitFieldNames ? '' : 'multiBcTableG7Bc', $pb.PbFieldType.KD)
    ..p<$core.double>(
        21, _omitFieldNames ? '' : 'customDragTableMach', $pb.PbFieldType.KD)
    ..p<$core.double>(
        22, _omitFieldNames ? '' : 'customDragTableCd', $pb.PbFieldType.KD)
    ..aOM<Zero>(23, _omitFieldNames ? '' : 'zero', subBuilder: Zero.create)
    ..aOS(24, _omitFieldNames ? '' : 'projectileName')
    ..aOS(25, _omitFieldNames ? '' : 'vendor')
    ..aOS(26, _omitFieldNames ? '' : 'image')
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
  $core.String get uiKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set uiKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUiKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearUiKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get caliberInch => $_getN(2);
  @$pb.TagNumber(3)
  set caliberInch($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCaliberInch() => $_has(2);
  @$pb.TagNumber(3)
  void clearCaliberInch() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get weightGrain => $_getN(3);
  @$pb.TagNumber(4)
  set weightGrain($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWeightGrain() => $_has(3);
  @$pb.TagNumber(4)
  void clearWeightGrain() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get lengthInch => $_getN(4);
  @$pb.TagNumber(5)
  set lengthInch($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLengthInch() => $_has(4);
  @$pb.TagNumber(5)
  void clearLengthInch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dragTypeValue => $_getSZ(5);
  @$pb.TagNumber(6)
  set dragTypeValue($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDragTypeValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearDragTypeValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get bcG1 => $_getN(6);
  @$pb.TagNumber(7)
  set bcG1($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBcG1() => $_has(6);
  @$pb.TagNumber(7)
  void clearBcG1() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get bcG7 => $_getN(7);
  @$pb.TagNumber(8)
  set bcG7($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBcG7() => $_has(7);
  @$pb.TagNumber(8)
  void clearBcG7() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get useMultiBcG1 => $_getBF(8);
  @$pb.TagNumber(9)
  set useMultiBcG1($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUseMultiBcG1() => $_has(8);
  @$pb.TagNumber(9)
  void clearUseMultiBcG1() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get useMultiBcG7 => $_getBF(9);
  @$pb.TagNumber(10)
  set useMultiBcG7($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUseMultiBcG7() => $_has(9);
  @$pb.TagNumber(10)
  void clearUseMultiBcG7() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get muzzleVelocityMps => $_getN(10);
  @$pb.TagNumber(11)
  set muzzleVelocityMps($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMuzzleVelocityMps() => $_has(10);
  @$pb.TagNumber(11)
  void clearMuzzleVelocityMps() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get muzzleVelocityTemperatureC => $_getN(11);
  @$pb.TagNumber(12)
  set muzzleVelocityTemperatureC($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMuzzleVelocityTemperatureC() => $_has(11);
  @$pb.TagNumber(12)
  void clearMuzzleVelocityTemperatureC() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get usePowderSensitivity => $_getBF(12);
  @$pb.TagNumber(13)
  set usePowderSensitivity($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasUsePowderSensitivity() => $_has(12);
  @$pb.TagNumber(13)
  void clearUsePowderSensitivity() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get powderSensitivityFrac => $_getN(13);
  @$pb.TagNumber(14)
  set powderSensitivityFrac($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPowderSensitivityFrac() => $_has(13);
  @$pb.TagNumber(14)
  void clearPowderSensitivityFrac() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbList<$core.double> get powderSensitivityTc => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<$core.double> get powderSensitivityVMps => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<$core.double> get multiBcTableG1VMps => $_getList(16);

  @$pb.TagNumber(18)
  $pb.PbList<$core.double> get multiBcTableG1Bc => $_getList(17);

  @$pb.TagNumber(19)
  $pb.PbList<$core.double> get multiBcTableG7VMps => $_getList(18);

  @$pb.TagNumber(20)
  $pb.PbList<$core.double> get multiBcTableG7Bc => $_getList(19);

  @$pb.TagNumber(21)
  $pb.PbList<$core.double> get customDragTableMach => $_getList(20);

  @$pb.TagNumber(22)
  $pb.PbList<$core.double> get customDragTableCd => $_getList(21);

  @$pb.TagNumber(23)
  Zero get zero => $_getN(22);
  @$pb.TagNumber(23)
  set zero(Zero value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasZero() => $_has(22);
  @$pb.TagNumber(23)
  void clearZero() => $_clearField(23);
  @$pb.TagNumber(23)
  Zero ensureZero() => $_ensure(22);

  @$pb.TagNumber(24)
  $core.String get projectileName => $_getSZ(23);
  @$pb.TagNumber(24)
  set projectileName($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasProjectileName() => $_has(23);
  @$pb.TagNumber(24)
  void clearProjectileName() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get vendor => $_getSZ(24);
  @$pb.TagNumber(25)
  set vendor($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasVendor() => $_has(24);
  @$pb.TagNumber(25)
  void clearVendor() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get image => $_getSZ(25);
  @$pb.TagNumber(26)
  set image($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasImage() => $_has(25);
  @$pb.TagNumber(26)
  void clearImage() => $_clearField(26);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
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
    $core.String? uiKey,
    $core.String? name,
    Weapon? weapon,
    $core.Iterable<Ammo>? ammo,
    $core.Iterable<Sight>? sights,
  }) {
    final result = create();
    if (uiKey != null) result.uiKey = uiKey;
    if (name != null) result.name = name;
    if (weapon != null) result.weapon = weapon;
    if (ammo != null) result.ammo.addAll(ammo);
    if (sights != null) result.sights.addAll(sights);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uiKey')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<Weapon>(3, _omitFieldNames ? '' : 'weapon', subBuilder: Weapon.create)
    ..pPM<Ammo>(4, _omitFieldNames ? '' : 'ammo', subBuilder: Ammo.create)
    ..pPM<Sight>(5, _omitFieldNames ? '' : 'sights', subBuilder: Sight.create)
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
  $core.String get uiKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set uiKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUiKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearUiKey() => $_clearField(1);

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
  $pb.PbList<Ammo> get ammo => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<Sight> get sights => $_getList(4);
}

class GeneralSettings extends $pb.GeneratedMessage {
  factory GeneralSettings({
    $core.String? languageCode,
    $core.String? themeMode,
    $core.String? adjustmentDisplayFormatValue,
    $core.bool? homeShowMil,
    $core.bool? homeShowMrad,
    $core.bool? homeShowMoa,
    $core.bool? homeShowCmPer100m,
    $core.bool? homeShowInPer100yd,
    $core.bool? homeShowInClicks,
    $core.double? homeChartDistanceStep,
    $core.double? homeTableDistanceStep,
    $core.bool? homeShowSubsonicTransition,
  }) {
    final result = create();
    if (languageCode != null) result.languageCode = languageCode;
    if (themeMode != null) result.themeMode = themeMode;
    if (adjustmentDisplayFormatValue != null)
      result.adjustmentDisplayFormatValue = adjustmentDisplayFormatValue;
    if (homeShowMil != null) result.homeShowMil = homeShowMil;
    if (homeShowMrad != null) result.homeShowMrad = homeShowMrad;
    if (homeShowMoa != null) result.homeShowMoa = homeShowMoa;
    if (homeShowCmPer100m != null) result.homeShowCmPer100m = homeShowCmPer100m;
    if (homeShowInPer100yd != null)
      result.homeShowInPer100yd = homeShowInPer100yd;
    if (homeShowInClicks != null) result.homeShowInClicks = homeShowInClicks;
    if (homeChartDistanceStep != null)
      result.homeChartDistanceStep = homeChartDistanceStep;
    if (homeTableDistanceStep != null)
      result.homeTableDistanceStep = homeTableDistanceStep;
    if (homeShowSubsonicTransition != null)
      result.homeShowSubsonicTransition = homeShowSubsonicTransition;
    return result;
  }

  GeneralSettings._();

  factory GeneralSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GeneralSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeneralSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'languageCode')
    ..aOS(2, _omitFieldNames ? '' : 'themeMode')
    ..aOS(3, _omitFieldNames ? '' : 'adjustmentDisplayFormatValue')
    ..aOB(4, _omitFieldNames ? '' : 'homeShowMil')
    ..aOB(5, _omitFieldNames ? '' : 'homeShowMrad')
    ..aOB(6, _omitFieldNames ? '' : 'homeShowMoa')
    ..aOB(7, _omitFieldNames ? '' : 'homeShowCmPer100m')
    ..aOB(8, _omitFieldNames ? '' : 'homeShowInPer100yd')
    ..aOB(9, _omitFieldNames ? '' : 'homeShowInClicks')
    ..aD(10, _omitFieldNames ? '' : 'homeChartDistanceStep')
    ..aD(11, _omitFieldNames ? '' : 'homeTableDistanceStep')
    ..aOB(12, _omitFieldNames ? '' : 'homeShowSubsonicTransition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeneralSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeneralSettings copyWith(void Function(GeneralSettings) updates) =>
      super.copyWith((message) => updates(message as GeneralSettings))
          as GeneralSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GeneralSettings create() => GeneralSettings._();
  @$core.override
  GeneralSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GeneralSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GeneralSettings>(create);
  static GeneralSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get languageCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set languageCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLanguageCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanguageCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get themeMode => $_getSZ(1);
  @$pb.TagNumber(2)
  set themeMode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThemeMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearThemeMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get adjustmentDisplayFormatValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set adjustmentDisplayFormatValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAdjustmentDisplayFormatValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdjustmentDisplayFormatValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get homeShowMil => $_getBF(3);
  @$pb.TagNumber(4)
  set homeShowMil($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHomeShowMil() => $_has(3);
  @$pb.TagNumber(4)
  void clearHomeShowMil() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get homeShowMrad => $_getBF(4);
  @$pb.TagNumber(5)
  set homeShowMrad($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHomeShowMrad() => $_has(4);
  @$pb.TagNumber(5)
  void clearHomeShowMrad() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get homeShowMoa => $_getBF(5);
  @$pb.TagNumber(6)
  set homeShowMoa($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHomeShowMoa() => $_has(5);
  @$pb.TagNumber(6)
  void clearHomeShowMoa() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get homeShowCmPer100m => $_getBF(6);
  @$pb.TagNumber(7)
  set homeShowCmPer100m($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHomeShowCmPer100m() => $_has(6);
  @$pb.TagNumber(7)
  void clearHomeShowCmPer100m() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get homeShowInPer100yd => $_getBF(7);
  @$pb.TagNumber(8)
  set homeShowInPer100yd($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHomeShowInPer100yd() => $_has(7);
  @$pb.TagNumber(8)
  void clearHomeShowInPer100yd() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get homeShowInClicks => $_getBF(8);
  @$pb.TagNumber(9)
  set homeShowInClicks($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHomeShowInClicks() => $_has(8);
  @$pb.TagNumber(9)
  void clearHomeShowInClicks() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get homeChartDistanceStep => $_getN(9);
  @$pb.TagNumber(10)
  set homeChartDistanceStep($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHomeChartDistanceStep() => $_has(9);
  @$pb.TagNumber(10)
  void clearHomeChartDistanceStep() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get homeTableDistanceStep => $_getN(10);
  @$pb.TagNumber(11)
  set homeTableDistanceStep($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHomeTableDistanceStep() => $_has(10);
  @$pb.TagNumber(11)
  void clearHomeTableDistanceStep() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get homeShowSubsonicTransition => $_getBF(11);
  @$pb.TagNumber(12)
  set homeShowSubsonicTransition($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasHomeShowSubsonicTransition() => $_has(11);
  @$pb.TagNumber(12)
  void clearHomeShowSubsonicTransition() => $_clearField(12);
}

class TablesSettings extends $pb.GeneratedMessage {
  factory TablesSettings({
    $core.double? distanceStartMeter,
    $core.double? distanceEndMeter,
    $core.double? distanceStepMeter,
    $core.bool? showZeros,
    $core.bool? showSubsonicTransition,
    $core.Iterable<$core.String>? hiddenCols,
    $core.bool? showMil,
    $core.bool? showMrad,
    $core.bool? showMoa,
    $core.bool? showCmPer100m,
    $core.bool? showInPer100yd,
    $core.bool? showInClicks,
  }) {
    final result = create();
    if (distanceStartMeter != null)
      result.distanceStartMeter = distanceStartMeter;
    if (distanceEndMeter != null) result.distanceEndMeter = distanceEndMeter;
    if (distanceStepMeter != null) result.distanceStepMeter = distanceStepMeter;
    if (showZeros != null) result.showZeros = showZeros;
    if (showSubsonicTransition != null)
      result.showSubsonicTransition = showSubsonicTransition;
    if (hiddenCols != null) result.hiddenCols.addAll(hiddenCols);
    if (showMil != null) result.showMil = showMil;
    if (showMrad != null) result.showMrad = showMrad;
    if (showMoa != null) result.showMoa = showMoa;
    if (showCmPer100m != null) result.showCmPer100m = showCmPer100m;
    if (showInPer100yd != null) result.showInPer100yd = showInPer100yd;
    if (showInClicks != null) result.showInClicks = showInClicks;
    return result;
  }

  TablesSettings._();

  factory TablesSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TablesSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TablesSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'distanceStartMeter')
    ..aD(2, _omitFieldNames ? '' : 'distanceEndMeter')
    ..aD(3, _omitFieldNames ? '' : 'distanceStepMeter')
    ..aOB(4, _omitFieldNames ? '' : 'showZeros')
    ..aOB(5, _omitFieldNames ? '' : 'showSubsonicTransition')
    ..pPS(6, _omitFieldNames ? '' : 'hiddenCols')
    ..aOB(7, _omitFieldNames ? '' : 'showMil')
    ..aOB(8, _omitFieldNames ? '' : 'showMrad')
    ..aOB(9, _omitFieldNames ? '' : 'showMoa')
    ..aOB(10, _omitFieldNames ? '' : 'showCmPer100m')
    ..aOB(11, _omitFieldNames ? '' : 'showInPer100yd')
    ..aOB(12, _omitFieldNames ? '' : 'showInClicks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TablesSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TablesSettings copyWith(void Function(TablesSettings) updates) =>
      super.copyWith((message) => updates(message as TablesSettings))
          as TablesSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TablesSettings create() => TablesSettings._();
  @$core.override
  TablesSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TablesSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TablesSettings>(create);
  static TablesSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get distanceStartMeter => $_getN(0);
  @$pb.TagNumber(1)
  set distanceStartMeter($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDistanceStartMeter() => $_has(0);
  @$pb.TagNumber(1)
  void clearDistanceStartMeter() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get distanceEndMeter => $_getN(1);
  @$pb.TagNumber(2)
  set distanceEndMeter($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDistanceEndMeter() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistanceEndMeter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get distanceStepMeter => $_getN(2);
  @$pb.TagNumber(3)
  set distanceStepMeter($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDistanceStepMeter() => $_has(2);
  @$pb.TagNumber(3)
  void clearDistanceStepMeter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get showZeros => $_getBF(3);
  @$pb.TagNumber(4)
  set showZeros($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowZeros() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowZeros() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get showSubsonicTransition => $_getBF(4);
  @$pb.TagNumber(5)
  set showSubsonicTransition($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShowSubsonicTransition() => $_has(4);
  @$pb.TagNumber(5)
  void clearShowSubsonicTransition() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get hiddenCols => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get showMil => $_getBF(6);
  @$pb.TagNumber(7)
  set showMil($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasShowMil() => $_has(6);
  @$pb.TagNumber(7)
  void clearShowMil() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get showMrad => $_getBF(7);
  @$pb.TagNumber(8)
  set showMrad($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasShowMrad() => $_has(7);
  @$pb.TagNumber(8)
  void clearShowMrad() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get showMoa => $_getBF(8);
  @$pb.TagNumber(9)
  set showMoa($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasShowMoa() => $_has(8);
  @$pb.TagNumber(9)
  void clearShowMoa() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get showCmPer100m => $_getBF(9);
  @$pb.TagNumber(10)
  set showCmPer100m($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasShowCmPer100m() => $_has(9);
  @$pb.TagNumber(10)
  void clearShowCmPer100m() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get showInPer100yd => $_getBF(10);
  @$pb.TagNumber(11)
  set showInPer100yd($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasShowInPer100yd() => $_has(10);
  @$pb.TagNumber(11)
  void clearShowInPer100yd() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get showInClicks => $_getBF(11);
  @$pb.TagNumber(12)
  set showInClicks($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasShowInClicks() => $_has(11);
  @$pb.TagNumber(12)
  void clearShowInClicks() => $_clearField(12);
}

class UnitSettings extends $pb.GeneratedMessage {
  factory UnitSettings({
    $core.String? angular,
    $core.String? distance,
    $core.String? velocity,
    $core.String? pressure,
    $core.String? temperature,
    $core.String? diameter,
    $core.String? length,
    $core.String? weight,
    $core.String? adjustment,
    $core.String? drop,
    $core.String? energy,
    $core.String? sightHeight,
    $core.String? twist,
    $core.String? barrelLength,
    $core.String? time,
    $core.String? torque,
    $core.String? targetSize,
  }) {
    final result = create();
    if (angular != null) result.angular = angular;
    if (distance != null) result.distance = distance;
    if (velocity != null) result.velocity = velocity;
    if (pressure != null) result.pressure = pressure;
    if (temperature != null) result.temperature = temperature;
    if (diameter != null) result.diameter = diameter;
    if (length != null) result.length = length;
    if (weight != null) result.weight = weight;
    if (adjustment != null) result.adjustment = adjustment;
    if (drop != null) result.drop = drop;
    if (energy != null) result.energy = energy;
    if (sightHeight != null) result.sightHeight = sightHeight;
    if (twist != null) result.twist = twist;
    if (barrelLength != null) result.barrelLength = barrelLength;
    if (time != null) result.time = time;
    if (torque != null) result.torque = torque;
    if (targetSize != null) result.targetSize = targetSize;
    return result;
  }

  UnitSettings._();

  factory UnitSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnitSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnitSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'angular')
    ..aOS(2, _omitFieldNames ? '' : 'distance')
    ..aOS(3, _omitFieldNames ? '' : 'velocity')
    ..aOS(4, _omitFieldNames ? '' : 'pressure')
    ..aOS(5, _omitFieldNames ? '' : 'temperature')
    ..aOS(6, _omitFieldNames ? '' : 'diameter')
    ..aOS(7, _omitFieldNames ? '' : 'length')
    ..aOS(8, _omitFieldNames ? '' : 'weight')
    ..aOS(9, _omitFieldNames ? '' : 'adjustment')
    ..aOS(10, _omitFieldNames ? '' : 'drop')
    ..aOS(11, _omitFieldNames ? '' : 'energy')
    ..aOS(12, _omitFieldNames ? '' : 'sightHeight')
    ..aOS(13, _omitFieldNames ? '' : 'twist')
    ..aOS(14, _omitFieldNames ? '' : 'barrelLength')
    ..aOS(15, _omitFieldNames ? '' : 'time')
    ..aOS(16, _omitFieldNames ? '' : 'torque')
    ..aOS(17, _omitFieldNames ? '' : 'targetSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnitSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnitSettings copyWith(void Function(UnitSettings) updates) =>
      super.copyWith((message) => updates(message as UnitSettings))
          as UnitSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnitSettings create() => UnitSettings._();
  @$core.override
  UnitSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnitSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnitSettings>(create);
  static UnitSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get angular => $_getSZ(0);
  @$pb.TagNumber(1)
  set angular($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAngular() => $_has(0);
  @$pb.TagNumber(1)
  void clearAngular() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get distance => $_getSZ(1);
  @$pb.TagNumber(2)
  set distance($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDistance() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistance() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get velocity => $_getSZ(2);
  @$pb.TagNumber(3)
  set velocity($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVelocity() => $_has(2);
  @$pb.TagNumber(3)
  void clearVelocity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pressure => $_getSZ(3);
  @$pb.TagNumber(4)
  set pressure($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPressure() => $_has(3);
  @$pb.TagNumber(4)
  void clearPressure() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get temperature => $_getSZ(4);
  @$pb.TagNumber(5)
  set temperature($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTemperature() => $_has(4);
  @$pb.TagNumber(5)
  void clearTemperature() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get diameter => $_getSZ(5);
  @$pb.TagNumber(6)
  set diameter($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDiameter() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiameter() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get length => $_getSZ(6);
  @$pb.TagNumber(7)
  set length($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLength() => $_has(6);
  @$pb.TagNumber(7)
  void clearLength() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get weight => $_getSZ(7);
  @$pb.TagNumber(8)
  set weight($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWeight() => $_has(7);
  @$pb.TagNumber(8)
  void clearWeight() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get adjustment => $_getSZ(8);
  @$pb.TagNumber(9)
  set adjustment($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAdjustment() => $_has(8);
  @$pb.TagNumber(9)
  void clearAdjustment() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get drop => $_getSZ(9);
  @$pb.TagNumber(10)
  set drop($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDrop() => $_has(9);
  @$pb.TagNumber(10)
  void clearDrop() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get energy => $_getSZ(10);
  @$pb.TagNumber(11)
  set energy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEnergy() => $_has(10);
  @$pb.TagNumber(11)
  void clearEnergy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get sightHeight => $_getSZ(11);
  @$pb.TagNumber(12)
  set sightHeight($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSightHeight() => $_has(11);
  @$pb.TagNumber(12)
  void clearSightHeight() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get twist => $_getSZ(12);
  @$pb.TagNumber(13)
  set twist($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTwist() => $_has(12);
  @$pb.TagNumber(13)
  void clearTwist() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get barrelLength => $_getSZ(13);
  @$pb.TagNumber(14)
  set barrelLength($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasBarrelLength() => $_has(13);
  @$pb.TagNumber(14)
  void clearBarrelLength() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get time => $_getSZ(14);
  @$pb.TagNumber(15)
  set time($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTime() => $_has(14);
  @$pb.TagNumber(15)
  void clearTime() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get torque => $_getSZ(15);
  @$pb.TagNumber(16)
  set torque($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasTorque() => $_has(15);
  @$pb.TagNumber(16)
  void clearTorque() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get targetSize => $_getSZ(16);
  @$pb.TagNumber(17)
  set targetSize($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasTargetSize() => $_has(16);
  @$pb.TagNumber(17)
  void clearTargetSize() => $_clearField(17);
}

class ShootingConditions extends $pb.GeneratedMessage {
  factory ShootingConditions({
    $core.double? distanceMeter,
    $core.double? lookAngleRad,
    $core.double? altitudeMeter,
    $core.double? temperatureC,
    $core.double? pressureHPa,
    $core.double? humidityFrac,
    $core.double? powderTemperatureC,
    $core.bool? usePowderSensitivity,
    $core.bool? useDiffPowderTemp,
    $core.bool? useCoriolis,
    $core.double? latitudeDeg,
    $core.double? azimuthDeg,
    $core.double? windDirectionDeg,
    $core.double? windSpeedMps,
  }) {
    final result = create();
    if (distanceMeter != null) result.distanceMeter = distanceMeter;
    if (lookAngleRad != null) result.lookAngleRad = lookAngleRad;
    if (altitudeMeter != null) result.altitudeMeter = altitudeMeter;
    if (temperatureC != null) result.temperatureC = temperatureC;
    if (pressureHPa != null) result.pressureHPa = pressureHPa;
    if (humidityFrac != null) result.humidityFrac = humidityFrac;
    if (powderTemperatureC != null)
      result.powderTemperatureC = powderTemperatureC;
    if (usePowderSensitivity != null)
      result.usePowderSensitivity = usePowderSensitivity;
    if (useDiffPowderTemp != null) result.useDiffPowderTemp = useDiffPowderTemp;
    if (useCoriolis != null) result.useCoriolis = useCoriolis;
    if (latitudeDeg != null) result.latitudeDeg = latitudeDeg;
    if (azimuthDeg != null) result.azimuthDeg = azimuthDeg;
    if (windDirectionDeg != null) result.windDirectionDeg = windDirectionDeg;
    if (windSpeedMps != null) result.windSpeedMps = windSpeedMps;
    return result;
  }

  ShootingConditions._();

  factory ShootingConditions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShootingConditions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShootingConditions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'distanceMeter')
    ..aD(2, _omitFieldNames ? '' : 'lookAngleRad')
    ..aD(3, _omitFieldNames ? '' : 'altitudeMeter')
    ..aD(4, _omitFieldNames ? '' : 'temperatureC')
    ..aD(5, _omitFieldNames ? '' : 'pressureHPa')
    ..aD(6, _omitFieldNames ? '' : 'humidityFrac')
    ..aD(7, _omitFieldNames ? '' : 'powderTemperatureC')
    ..aOB(8, _omitFieldNames ? '' : 'usePowderSensitivity')
    ..aOB(9, _omitFieldNames ? '' : 'useDiffPowderTemp')
    ..aOB(10, _omitFieldNames ? '' : 'useCoriolis')
    ..aD(11, _omitFieldNames ? '' : 'latitudeDeg')
    ..aD(12, _omitFieldNames ? '' : 'azimuthDeg')
    ..aD(13, _omitFieldNames ? '' : 'windDirectionDeg')
    ..aD(14, _omitFieldNames ? '' : 'windSpeedMps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShootingConditions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShootingConditions copyWith(void Function(ShootingConditions) updates) =>
      super.copyWith((message) => updates(message as ShootingConditions))
          as ShootingConditions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShootingConditions create() => ShootingConditions._();
  @$core.override
  ShootingConditions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShootingConditions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShootingConditions>(create);
  static ShootingConditions? _defaultInstance;

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
  $core.double get powderTemperatureC => $_getN(6);
  @$pb.TagNumber(7)
  set powderTemperatureC($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPowderTemperatureC() => $_has(6);
  @$pb.TagNumber(7)
  void clearPowderTemperatureC() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get usePowderSensitivity => $_getBF(7);
  @$pb.TagNumber(8)
  set usePowderSensitivity($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUsePowderSensitivity() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsePowderSensitivity() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get useDiffPowderTemp => $_getBF(8);
  @$pb.TagNumber(9)
  set useDiffPowderTemp($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUseDiffPowderTemp() => $_has(8);
  @$pb.TagNumber(9)
  void clearUseDiffPowderTemp() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get useCoriolis => $_getBF(9);
  @$pb.TagNumber(10)
  set useCoriolis($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUseCoriolis() => $_has(9);
  @$pb.TagNumber(10)
  void clearUseCoriolis() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get latitudeDeg => $_getN(10);
  @$pb.TagNumber(11)
  set latitudeDeg($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLatitudeDeg() => $_has(10);
  @$pb.TagNumber(11)
  void clearLatitudeDeg() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get azimuthDeg => $_getN(11);
  @$pb.TagNumber(12)
  set azimuthDeg($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAzimuthDeg() => $_has(11);
  @$pb.TagNumber(12)
  void clearAzimuthDeg() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get windDirectionDeg => $_getN(12);
  @$pb.TagNumber(13)
  set windDirectionDeg($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasWindDirectionDeg() => $_has(12);
  @$pb.TagNumber(13)
  void clearWindDirectionDeg() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get windSpeedMps => $_getN(13);
  @$pb.TagNumber(14)
  set windSpeedMps($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(14)
  $core.bool hasWindSpeedMps() => $_has(13);
  @$pb.TagNumber(14)
  void clearWindSpeedMps() => $_clearField(14);
}

/// A raw stored value plus the unit last selected for display — the shape
/// shared by every simple (non-composite) convertor below.
class UnitValue extends $pb.GeneratedMessage {
  factory UnitValue({
    $core.double? value,
    $core.String? lastUnit,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (lastUnit != null) result.lastUnit = lastUnit;
    return result;
  }

  UnitValue._();

  factory UnitValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnitValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnitValue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value')
    ..aOS(2, _omitFieldNames ? '' : 'lastUnit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnitValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnitValue copyWith(void Function(UnitValue) updates) =>
      super.copyWith((message) => updates(message as UnitValue)) as UnitValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnitValue create() => UnitValue._();
  @$core.override
  UnitValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnitValue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnitValue>(create);
  static UnitValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastUnit => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastUnit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastUnit() => $_clearField(2);
}

class AnglesConv extends $pb.GeneratedMessage {
  factory AnglesConv({
    $core.double? distanceValueMeter,
    $core.String? distanceLastUnit,
    $core.double? angularValueMil,
    $core.String? angularLastUnit,
    $core.String? outputLastUnit,
  }) {
    final result = create();
    if (distanceValueMeter != null)
      result.distanceValueMeter = distanceValueMeter;
    if (distanceLastUnit != null) result.distanceLastUnit = distanceLastUnit;
    if (angularValueMil != null) result.angularValueMil = angularValueMil;
    if (angularLastUnit != null) result.angularLastUnit = angularLastUnit;
    if (outputLastUnit != null) result.outputLastUnit = outputLastUnit;
    return result;
  }

  AnglesConv._();

  factory AnglesConv.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AnglesConv.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnglesConv',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'distanceValueMeter')
    ..aOS(2, _omitFieldNames ? '' : 'distanceLastUnit')
    ..aD(3, _omitFieldNames ? '' : 'angularValueMil')
    ..aOS(4, _omitFieldNames ? '' : 'angularLastUnit')
    ..aOS(5, _omitFieldNames ? '' : 'outputLastUnit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnglesConv clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnglesConv copyWith(void Function(AnglesConv) updates) =>
      super.copyWith((message) => updates(message as AnglesConv)) as AnglesConv;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnglesConv create() => AnglesConv._();
  @$core.override
  AnglesConv createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AnglesConv getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnglesConv>(create);
  static AnglesConv? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get distanceValueMeter => $_getN(0);
  @$pb.TagNumber(1)
  set distanceValueMeter($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDistanceValueMeter() => $_has(0);
  @$pb.TagNumber(1)
  void clearDistanceValueMeter() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get distanceLastUnit => $_getSZ(1);
  @$pb.TagNumber(2)
  set distanceLastUnit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDistanceLastUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistanceLastUnit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get angularValueMil => $_getN(2);
  @$pb.TagNumber(3)
  set angularValueMil($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAngularValueMil() => $_has(2);
  @$pb.TagNumber(3)
  void clearAngularValueMil() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get angularLastUnit => $_getSZ(3);
  @$pb.TagNumber(4)
  set angularLastUnit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAngularLastUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearAngularLastUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get outputLastUnit => $_getSZ(4);
  @$pb.TagNumber(5)
  set outputLastUnit($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOutputLastUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutputLastUnit() => $_clearField(5);
}

class VelocityConv extends $pb.GeneratedMessage {
  factory VelocityConv({
    $core.double? valueMps,
    $core.String? lastUnit,
    $core.double? machInputValue,
    $core.bool? machUseCustomAtmo,
    $core.double? atmoTemperatureC,
    $core.double? atmoPressureHPa,
    $core.double? atmoHumidityFrac,
    $core.double? atmoAltitudeMeter,
  }) {
    final result = create();
    if (valueMps != null) result.valueMps = valueMps;
    if (lastUnit != null) result.lastUnit = lastUnit;
    if (machInputValue != null) result.machInputValue = machInputValue;
    if (machUseCustomAtmo != null) result.machUseCustomAtmo = machUseCustomAtmo;
    if (atmoTemperatureC != null) result.atmoTemperatureC = atmoTemperatureC;
    if (atmoPressureHPa != null) result.atmoPressureHPa = atmoPressureHPa;
    if (atmoHumidityFrac != null) result.atmoHumidityFrac = atmoHumidityFrac;
    if (atmoAltitudeMeter != null) result.atmoAltitudeMeter = atmoAltitudeMeter;
    return result;
  }

  VelocityConv._();

  factory VelocityConv.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VelocityConv.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VelocityConv',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'valueMps')
    ..aOS(2, _omitFieldNames ? '' : 'lastUnit')
    ..aD(3, _omitFieldNames ? '' : 'machInputValue')
    ..aOB(4, _omitFieldNames ? '' : 'machUseCustomAtmo')
    ..aD(5, _omitFieldNames ? '' : 'atmoTemperatureC')
    ..aD(6, _omitFieldNames ? '' : 'atmoPressureHPa')
    ..aD(7, _omitFieldNames ? '' : 'atmoHumidityFrac')
    ..aD(8, _omitFieldNames ? '' : 'atmoAltitudeMeter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VelocityConv clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VelocityConv copyWith(void Function(VelocityConv) updates) =>
      super.copyWith((message) => updates(message as VelocityConv))
          as VelocityConv;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VelocityConv create() => VelocityConv._();
  @$core.override
  VelocityConv createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VelocityConv getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VelocityConv>(create);
  static VelocityConv? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get valueMps => $_getN(0);
  @$pb.TagNumber(1)
  set valueMps($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValueMps() => $_has(0);
  @$pb.TagNumber(1)
  void clearValueMps() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastUnit => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastUnit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastUnit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get machInputValue => $_getN(2);
  @$pb.TagNumber(3)
  set machInputValue($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMachInputValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearMachInputValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get machUseCustomAtmo => $_getBF(3);
  @$pb.TagNumber(4)
  set machUseCustomAtmo($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMachUseCustomAtmo() => $_has(3);
  @$pb.TagNumber(4)
  void clearMachUseCustomAtmo() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get atmoTemperatureC => $_getN(4);
  @$pb.TagNumber(5)
  set atmoTemperatureC($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAtmoTemperatureC() => $_has(4);
  @$pb.TagNumber(5)
  void clearAtmoTemperatureC() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get atmoPressureHPa => $_getN(5);
  @$pb.TagNumber(6)
  set atmoPressureHPa($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAtmoPressureHPa() => $_has(5);
  @$pb.TagNumber(6)
  void clearAtmoPressureHPa() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get atmoHumidityFrac => $_getN(6);
  @$pb.TagNumber(7)
  set atmoHumidityFrac($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAtmoHumidityFrac() => $_has(6);
  @$pb.TagNumber(7)
  void clearAtmoHumidityFrac() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get atmoAltitudeMeter => $_getN(7);
  @$pb.TagNumber(8)
  set atmoAltitudeMeter($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAtmoAltitudeMeter() => $_has(7);
  @$pb.TagNumber(8)
  void clearAtmoAltitudeMeter() => $_clearField(8);
}

class DistanceConvTargetSize extends $pb.GeneratedMessage {
  factory DistanceConvTargetSize({
    $core.double? sizeInch,
    $core.String? sizeUnit,
    $core.double? sizeAngularMil,
    $core.String? sizeAngularUnit,
  }) {
    final result = create();
    if (sizeInch != null) result.sizeInch = sizeInch;
    if (sizeUnit != null) result.sizeUnit = sizeUnit;
    if (sizeAngularMil != null) result.sizeAngularMil = sizeAngularMil;
    if (sizeAngularUnit != null) result.sizeAngularUnit = sizeAngularUnit;
    return result;
  }

  DistanceConvTargetSize._();

  factory DistanceConvTargetSize.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DistanceConvTargetSize.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DistanceConvTargetSize',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'sizeInch')
    ..aOS(2, _omitFieldNames ? '' : 'sizeUnit')
    ..aD(3, _omitFieldNames ? '' : 'sizeAngularMil')
    ..aOS(4, _omitFieldNames ? '' : 'sizeAngularUnit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DistanceConvTargetSize clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DistanceConvTargetSize copyWith(
          void Function(DistanceConvTargetSize) updates) =>
      super.copyWith((message) => updates(message as DistanceConvTargetSize))
          as DistanceConvTargetSize;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DistanceConvTargetSize create() => DistanceConvTargetSize._();
  @$core.override
  DistanceConvTargetSize createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DistanceConvTargetSize getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DistanceConvTargetSize>(create);
  static DistanceConvTargetSize? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get sizeInch => $_getN(0);
  @$pb.TagNumber(1)
  set sizeInch($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSizeInch() => $_has(0);
  @$pb.TagNumber(1)
  void clearSizeInch() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sizeUnit => $_getSZ(1);
  @$pb.TagNumber(2)
  set sizeUnit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSizeUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearSizeUnit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get sizeAngularMil => $_getN(2);
  @$pb.TagNumber(3)
  set sizeAngularMil($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSizeAngularMil() => $_has(2);
  @$pb.TagNumber(3)
  void clearSizeAngularMil() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sizeAngularUnit => $_getSZ(3);
  @$pb.TagNumber(4)
  set sizeAngularUnit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSizeAngularUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearSizeAngularUnit() => $_clearField(4);
}

class ConvertorsState extends $pb.GeneratedMessage {
  factory ConvertorsState({
    UnitValue? length,
    UnitValue? weight,
    UnitValue? pressure,
    UnitValue? temperature,
    UnitValue? torque,
    AnglesConv? angles,
    VelocityConv? velocity,
    DistanceConvTargetSize? distanceConvTargetSize,
  }) {
    final result = create();
    if (length != null) result.length = length;
    if (weight != null) result.weight = weight;
    if (pressure != null) result.pressure = pressure;
    if (temperature != null) result.temperature = temperature;
    if (torque != null) result.torque = torque;
    if (angles != null) result.angles = angles;
    if (velocity != null) result.velocity = velocity;
    if (distanceConvTargetSize != null)
      result.distanceConvTargetSize = distanceConvTargetSize;
    return result;
  }

  ConvertorsState._();

  factory ConvertorsState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConvertorsState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConvertorsState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aOM<UnitValue>(1, _omitFieldNames ? '' : 'length',
        subBuilder: UnitValue.create)
    ..aOM<UnitValue>(2, _omitFieldNames ? '' : 'weight',
        subBuilder: UnitValue.create)
    ..aOM<UnitValue>(3, _omitFieldNames ? '' : 'pressure',
        subBuilder: UnitValue.create)
    ..aOM<UnitValue>(4, _omitFieldNames ? '' : 'temperature',
        subBuilder: UnitValue.create)
    ..aOM<UnitValue>(5, _omitFieldNames ? '' : 'torque',
        subBuilder: UnitValue.create)
    ..aOM<AnglesConv>(6, _omitFieldNames ? '' : 'angles',
        subBuilder: AnglesConv.create)
    ..aOM<VelocityConv>(7, _omitFieldNames ? '' : 'velocity',
        subBuilder: VelocityConv.create)
    ..aOM<DistanceConvTargetSize>(
        8, _omitFieldNames ? '' : 'distanceConvTargetSize',
        subBuilder: DistanceConvTargetSize.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConvertorsState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConvertorsState copyWith(void Function(ConvertorsState) updates) =>
      super.copyWith((message) => updates(message as ConvertorsState))
          as ConvertorsState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConvertorsState create() => ConvertorsState._();
  @$core.override
  ConvertorsState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConvertorsState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConvertorsState>(create);
  static ConvertorsState? _defaultInstance;

  @$pb.TagNumber(1)
  UnitValue get length => $_getN(0);
  @$pb.TagNumber(1)
  set length(UnitValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLength() => $_has(0);
  @$pb.TagNumber(1)
  void clearLength() => $_clearField(1);
  @$pb.TagNumber(1)
  UnitValue ensureLength() => $_ensure(0);

  @$pb.TagNumber(2)
  UnitValue get weight => $_getN(1);
  @$pb.TagNumber(2)
  set weight(UnitValue value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeight() => $_clearField(2);
  @$pb.TagNumber(2)
  UnitValue ensureWeight() => $_ensure(1);

  @$pb.TagNumber(3)
  UnitValue get pressure => $_getN(2);
  @$pb.TagNumber(3)
  set pressure(UnitValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPressure() => $_has(2);
  @$pb.TagNumber(3)
  void clearPressure() => $_clearField(3);
  @$pb.TagNumber(3)
  UnitValue ensurePressure() => $_ensure(2);

  @$pb.TagNumber(4)
  UnitValue get temperature => $_getN(3);
  @$pb.TagNumber(4)
  set temperature(UnitValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTemperature() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemperature() => $_clearField(4);
  @$pb.TagNumber(4)
  UnitValue ensureTemperature() => $_ensure(3);

  @$pb.TagNumber(5)
  UnitValue get torque => $_getN(4);
  @$pb.TagNumber(5)
  set torque(UnitValue value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTorque() => $_has(4);
  @$pb.TagNumber(5)
  void clearTorque() => $_clearField(5);
  @$pb.TagNumber(5)
  UnitValue ensureTorque() => $_ensure(4);

  @$pb.TagNumber(6)
  AnglesConv get angles => $_getN(5);
  @$pb.TagNumber(6)
  set angles(AnglesConv value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAngles() => $_has(5);
  @$pb.TagNumber(6)
  void clearAngles() => $_clearField(6);
  @$pb.TagNumber(6)
  AnglesConv ensureAngles() => $_ensure(5);

  @$pb.TagNumber(7)
  VelocityConv get velocity => $_getN(6);
  @$pb.TagNumber(7)
  set velocity(VelocityConv value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasVelocity() => $_has(6);
  @$pb.TagNumber(7)
  void clearVelocity() => $_clearField(7);
  @$pb.TagNumber(7)
  VelocityConv ensureVelocity() => $_ensure(6);

  @$pb.TagNumber(8)
  DistanceConvTargetSize get distanceConvTargetSize => $_getN(7);
  @$pb.TagNumber(8)
  set distanceConvTargetSize(DistanceConvTargetSize value) =>
      $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDistanceConvTargetSize() => $_has(7);
  @$pb.TagNumber(8)
  void clearDistanceConvTargetSize() => $_clearField(8);
  @$pb.TagNumber(8)
  DistanceConvTargetSize ensureDistanceConvTargetSize() => $_ensure(7);
}

class ReticleSettings extends $pb.GeneratedMessage {
  factory ReticleSettings({
    $core.double? verticalAdjustment,
    $core.String? verticalAdjustmentUnit,
    $core.double? horizontalAdjustment,
    $core.String? horizontalAdjustmentUnit,
    $core.String? targetImage,
  }) {
    final result = create();
    if (verticalAdjustment != null)
      result.verticalAdjustment = verticalAdjustment;
    if (verticalAdjustmentUnit != null)
      result.verticalAdjustmentUnit = verticalAdjustmentUnit;
    if (horizontalAdjustment != null)
      result.horizontalAdjustment = horizontalAdjustment;
    if (horizontalAdjustmentUnit != null)
      result.horizontalAdjustmentUnit = horizontalAdjustmentUnit;
    if (targetImage != null) result.targetImage = targetImage;
    return result;
  }

  ReticleSettings._();

  factory ReticleSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReticleSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReticleSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'verticalAdjustment')
    ..aOS(2, _omitFieldNames ? '' : 'verticalAdjustmentUnit')
    ..aD(3, _omitFieldNames ? '' : 'horizontalAdjustment')
    ..aOS(4, _omitFieldNames ? '' : 'horizontalAdjustmentUnit')
    ..aOS(5, _omitFieldNames ? '' : 'targetImage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReticleSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReticleSettings copyWith(void Function(ReticleSettings) updates) =>
      super.copyWith((message) => updates(message as ReticleSettings))
          as ReticleSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReticleSettings create() => ReticleSettings._();
  @$core.override
  ReticleSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReticleSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReticleSettings>(create);
  static ReticleSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get verticalAdjustment => $_getN(0);
  @$pb.TagNumber(1)
  set verticalAdjustment($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVerticalAdjustment() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerticalAdjustment() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get verticalAdjustmentUnit => $_getSZ(1);
  @$pb.TagNumber(2)
  set verticalAdjustmentUnit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVerticalAdjustmentUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerticalAdjustmentUnit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get horizontalAdjustment => $_getN(2);
  @$pb.TagNumber(3)
  set horizontalAdjustment($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHorizontalAdjustment() => $_has(2);
  @$pb.TagNumber(3)
  void clearHorizontalAdjustment() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get horizontalAdjustmentUnit => $_getSZ(3);
  @$pb.TagNumber(4)
  set horizontalAdjustmentUnit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHorizontalAdjustmentUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearHorizontalAdjustmentUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetImage => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetImage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetImage() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetImage() => $_clearField(5);
}

class Db extends $pb.GeneratedMessage {
  factory Db({
    $core.int? schemaVersion,
    GeneralSettings? generalSettings,
    UnitSettings? unitSettings,
    TablesSettings? tablesSettings,
    ReticleSettings? reticleSettings,
    ConvertorsState? convertorsState,
    ShootingConditions? shootingConditions,
    $core.Iterable<Profile>? profiles,
  }) {
    final result = create();
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (generalSettings != null) result.generalSettings = generalSettings;
    if (unitSettings != null) result.unitSettings = unitSettings;
    if (tablesSettings != null) result.tablesSettings = tablesSettings;
    if (reticleSettings != null) result.reticleSettings = reticleSettings;
    if (convertorsState != null) result.convertorsState = convertorsState;
    if (shootingConditions != null)
      result.shootingConditions = shootingConditions;
    if (profiles != null) result.profiles.addAll(profiles);
    return result;
  }

  Db._();

  factory Db.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Db.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Db',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ebc_db'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'schemaVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aOM<GeneralSettings>(2, _omitFieldNames ? '' : 'generalSettings',
        subBuilder: GeneralSettings.create)
    ..aOM<UnitSettings>(3, _omitFieldNames ? '' : 'unitSettings',
        subBuilder: UnitSettings.create)
    ..aOM<TablesSettings>(4, _omitFieldNames ? '' : 'tablesSettings',
        subBuilder: TablesSettings.create)
    ..aOM<ReticleSettings>(5, _omitFieldNames ? '' : 'reticleSettings',
        subBuilder: ReticleSettings.create)
    ..aOM<ConvertorsState>(6, _omitFieldNames ? '' : 'convertorsState',
        subBuilder: ConvertorsState.create)
    ..aOM<ShootingConditions>(7, _omitFieldNames ? '' : 'shootingConditions',
        subBuilder: ShootingConditions.create)
    ..pPM<Profile>(8, _omitFieldNames ? '' : 'profiles',
        subBuilder: Profile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Db clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Db copyWith(void Function(Db) updates) =>
      super.copyWith((message) => updates(message as Db)) as Db;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Db create() => Db._();
  @$core.override
  Db createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Db getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Db>(create);
  static Db? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schemaVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set schemaVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  GeneralSettings get generalSettings => $_getN(1);
  @$pb.TagNumber(2)
  set generalSettings(GeneralSettings value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGeneralSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeneralSettings() => $_clearField(2);
  @$pb.TagNumber(2)
  GeneralSettings ensureGeneralSettings() => $_ensure(1);

  @$pb.TagNumber(3)
  UnitSettings get unitSettings => $_getN(2);
  @$pb.TagNumber(3)
  set unitSettings(UnitSettings value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitSettings() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitSettings() => $_clearField(3);
  @$pb.TagNumber(3)
  UnitSettings ensureUnitSettings() => $_ensure(2);

  @$pb.TagNumber(4)
  TablesSettings get tablesSettings => $_getN(3);
  @$pb.TagNumber(4)
  set tablesSettings(TablesSettings value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTablesSettings() => $_has(3);
  @$pb.TagNumber(4)
  void clearTablesSettings() => $_clearField(4);
  @$pb.TagNumber(4)
  TablesSettings ensureTablesSettings() => $_ensure(3);

  @$pb.TagNumber(5)
  ReticleSettings get reticleSettings => $_getN(4);
  @$pb.TagNumber(5)
  set reticleSettings(ReticleSettings value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReticleSettings() => $_has(4);
  @$pb.TagNumber(5)
  void clearReticleSettings() => $_clearField(5);
  @$pb.TagNumber(5)
  ReticleSettings ensureReticleSettings() => $_ensure(4);

  @$pb.TagNumber(6)
  ConvertorsState get convertorsState => $_getN(5);
  @$pb.TagNumber(6)
  set convertorsState(ConvertorsState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConvertorsState() => $_has(5);
  @$pb.TagNumber(6)
  void clearConvertorsState() => $_clearField(6);
  @$pb.TagNumber(6)
  ConvertorsState ensureConvertorsState() => $_ensure(5);

  @$pb.TagNumber(7)
  ShootingConditions get shootingConditions => $_getN(6);
  @$pb.TagNumber(7)
  set shootingConditions(ShootingConditions value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasShootingConditions() => $_has(6);
  @$pb.TagNumber(7)
  void clearShootingConditions() => $_clearField(7);
  @$pb.TagNumber(7)
  ShootingConditions ensureShootingConditions() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<Profile> get profiles => $_getList(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
