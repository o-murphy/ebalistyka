// Characterization test for the "name string <-> enum / Unit" getters in
// core/extensions: each getter's fallback on an empty message and the
// setter -> getter round trip. The dump is compared with
// enum_name_getters_golden.txt; delete the golden to regenerate it.
import 'dart:io';

import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/convertors_extensions.dart';
import 'package:ebalistyka/core/extensions/settings_extensions.dart';
import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('name-backed getters keep their fallbacks and round trips', () {
    final out = StringBuffer();
  out.writeln('GeneralSettings.adjustmentDisplayFormat: default=${GeneralSettings().adjustmentDisplayFormat.name}'
      ' roundtrip=${((GeneralSettings()..adjustmentDisplayFormat = AdjustmentDisplayFormat.values.last).adjustmentDisplayFormat).name}');
  out.writeln('UnitSettings.angularUnit: default=${UnitSettings().angularUnit.name}'
      ' roundtrip=${((UnitSettings()..angularUnit = Unit.psi).angularUnit).name}');
  out.writeln('UnitSettings.distanceUnit: default=${UnitSettings().distanceUnit.name}'
      ' roundtrip=${((UnitSettings()..distanceUnit = Unit.psi).distanceUnit).name}');
  out.writeln('UnitSettings.velocityUnit: default=${UnitSettings().velocityUnit.name}'
      ' roundtrip=${((UnitSettings()..velocityUnit = Unit.psi).velocityUnit).name}');
  out.writeln('UnitSettings.pressureUnit: default=${UnitSettings().pressureUnit.name}'
      ' roundtrip=${((UnitSettings()..pressureUnit = Unit.psi).pressureUnit).name}');
  out.writeln('UnitSettings.temperatureUnit: default=${UnitSettings().temperatureUnit.name}'
      ' roundtrip=${((UnitSettings()..temperatureUnit = Unit.psi).temperatureUnit).name}');
  out.writeln('UnitSettings.diameterUnit: default=${UnitSettings().diameterUnit.name}'
      ' roundtrip=${((UnitSettings()..diameterUnit = Unit.psi).diameterUnit).name}');
  out.writeln('UnitSettings.lengthUnit: default=${UnitSettings().lengthUnit.name}'
      ' roundtrip=${((UnitSettings()..lengthUnit = Unit.psi).lengthUnit).name}');
  out.writeln('UnitSettings.weightUnit: default=${UnitSettings().weightUnit.name}'
      ' roundtrip=${((UnitSettings()..weightUnit = Unit.psi).weightUnit).name}');
  out.writeln('UnitSettings.dropUnit: default=${UnitSettings().dropUnit.name}'
      ' roundtrip=${((UnitSettings()..dropUnit = Unit.psi).dropUnit).name}');
  out.writeln('UnitSettings.energyUnit: default=${UnitSettings().energyUnit.name}'
      ' roundtrip=${((UnitSettings()..energyUnit = Unit.psi).energyUnit).name}');
  out.writeln('UnitSettings.targetSizeUnit: default=${UnitSettings().targetSizeUnit.name}'
      ' roundtrip=${((UnitSettings()..targetSizeUnit = Unit.psi).targetSizeUnit).name}');
  out.writeln('UnitSettings.adjustmentUnit: default=${UnitSettings().adjustmentUnit.name}'
      ' roundtrip=${((UnitSettings()..adjustmentUnit = Unit.psi).adjustmentUnit).name}');
  out.writeln('UnitSettings.sightHeightUnit: default=${UnitSettings().sightHeightUnit.name}'
      ' roundtrip=${((UnitSettings()..sightHeightUnit = Unit.psi).sightHeightUnit).name}');
  out.writeln('UnitSettings.twistUnit: default=${UnitSettings().twistUnit.name}'
      ' roundtrip=${((UnitSettings()..twistUnit = Unit.psi).twistUnit).name}');
  out.writeln('UnitSettings.barrelLengthUnit: default=${UnitSettings().barrelLengthUnit.name}'
      ' roundtrip=${((UnitSettings()..barrelLengthUnit = Unit.psi).barrelLengthUnit).name}');
  out.writeln('UnitSettings.torqueUnit: default=${UnitSettings().torqueUnit.name}'
      ' roundtrip=${((UnitSettings()..torqueUnit = Unit.psi).torqueUnit).name}');
  out.writeln('ReticleSettings.verticalAdjustmentUnitValue: default=${ReticleSettings().verticalAdjustmentUnitValue.name}'
      ' roundtrip=${((ReticleSettings()..verticalAdjustmentUnitValue = Unit.psi).verticalAdjustmentUnitValue).name}');
  out.writeln('ReticleSettings.horizontalAdjustmentUnitValue: default=${ReticleSettings().horizontalAdjustmentUnitValue.name}'
      ' roundtrip=${((ReticleSettings()..horizontalAdjustmentUnitValue = Unit.psi).horizontalAdjustmentUnitValue).name}');
  out.writeln('ConvertorsState.lengthUnit: default=${ConvertorsState().lengthUnit.name}'
      ' roundtrip=${((ConvertorsState()..lengthUnit = Unit.psi).lengthUnit).name}');
  out.writeln('ConvertorsState.weightUnit: default=${ConvertorsState().weightUnit.name}'
      ' roundtrip=${((ConvertorsState()..weightUnit = Unit.psi).weightUnit).name}');
  out.writeln('ConvertorsState.pressureUnit: default=${ConvertorsState().pressureUnit.name}'
      ' roundtrip=${((ConvertorsState()..pressureUnit = Unit.psi).pressureUnit).name}');
  out.writeln('ConvertorsState.temperatureUnit: default=${ConvertorsState().temperatureUnit.name}'
      ' roundtrip=${((ConvertorsState()..temperatureUnit = Unit.psi).temperatureUnit).name}');
  out.writeln('ConvertorsState.torqueUnit: default=${ConvertorsState().torqueUnit.name}'
      ' roundtrip=${((ConvertorsState()..torqueUnit = Unit.psi).torqueUnit).name}');
  out.writeln('ConvertorsState.anglesConvDistanceUnit: default=${ConvertorsState().anglesConvDistanceUnit.name}'
      ' roundtrip=${((ConvertorsState()..anglesConvDistanceUnit = Unit.psi).anglesConvDistanceUnit).name}');
  out.writeln('ConvertorsState.anglesConvAngularUnit: default=${ConvertorsState().anglesConvAngularUnit.name}'
      ' roundtrip=${((ConvertorsState()..anglesConvAngularUnit = Unit.psi).anglesConvAngularUnit).name}');
  out.writeln('ConvertorsState.anglesConvOutputUnit: default=${ConvertorsState().anglesConvOutputUnit.name}'
      ' roundtrip=${((ConvertorsState()..anglesConvOutputUnit = Unit.psi).anglesConvOutputUnit).name}');
  out.writeln('ConvertorsState.distanceConvTargetSizeUnitValue: default=${ConvertorsState().distanceConvTargetSizeUnitValue.name}'
      ' roundtrip=${((ConvertorsState()..distanceConvTargetSizeUnitValue = Unit.psi).distanceConvTargetSizeUnitValue).name}');
  out.writeln('ConvertorsState.distanceConvTargetSizeAngularUnitValue: default=${ConvertorsState().distanceConvTargetSizeAngularUnitValue.name}'
      ' roundtrip=${((ConvertorsState()..distanceConvTargetSizeAngularUnitValue = Unit.psi).distanceConvTargetSizeAngularUnitValue).name}');
  out.writeln('ConvertorsState.velocityUnit: default=${ConvertorsState().velocityUnit.name}'
      ' roundtrip=${((ConvertorsState()..velocityUnit = Unit.psi).velocityUnit).name}');
  out.writeln('Ammo.dragType: default=${Ammo().dragType.name}'
      ' roundtrip=${((Ammo()..dragType = DragType.values.last).dragType).name}');
  out.writeln('Ammo.zeroOffsetXUnitValue: default=${Ammo().zeroOffsetXUnitValue.name}'
      ' roundtrip=${((Ammo()..zeroOffsetXUnitValue = Unit.psi).zeroOffsetXUnitValue).name}');
  out.writeln('Ammo.zeroOffsetYUnitValue: default=${Ammo().zeroOffsetYUnitValue.name}'
      ' roundtrip=${((Ammo()..zeroOffsetYUnitValue = Unit.psi).zeroOffsetYUnitValue).name}');
  out.writeln('Sight.focalPlane: default=${Sight().focalPlane.name}'
      ' roundtrip=${((Sight()..focalPlane = FocalPlane.values.last).focalPlane).name}');
  out.writeln('Sight.verticalClickUnitValue: default=${Sight().verticalClickUnitValue.name}'
      ' roundtrip=${((Sight()..verticalClickUnitValue = Unit.psi).verticalClickUnitValue).name}');
  out.writeln('Sight.horizontalClickUnitValue: default=${Sight().horizontalClickUnitValue.name}'
      ' roundtrip=${((Sight()..horizontalClickUnitValue = Unit.psi).horizontalClickUnitValue).name}');
    final golden = File('test/core/extensions/enum_name_getters_golden.txt');
    if (!golden.existsSync()) {
      golden.writeAsStringSync(out.toString());
      // ignore: avoid_print
      print('Wrote ${golden.path} — review and commit it.');
      return;
    }
    expect(out.toString(), golden.readAsStringSync());
  });
}
