import 'package:dart_bclibc/unit.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:dart_bclibc/bclibc.dart' as bclibc;

extension WeaponExtension on Weapon {
  Distance get twist => Distance.inch(twistInch);
  set twist(Distance value) => twistInch = value.in_(Unit.inch);

  bool get isRightHandTwist => twistInch >= 0.0;

  Distance? get caliber => hasCaliberInch() ? Distance.inch(caliberInch) : null;
  set caliber(Distance? value) {
    if (value == null) {
      clearCaliberInch();
    } else {
      caliberInch = value.in_(Unit.inch);
    }
  }

  Angular get zeroElevation => Angular.radian(zeroElevationRad);
  set zeroElevation(Angular value) => zeroElevationRad = value.in_(Unit.radian);

  Distance? get barrelLength =>
      hasBarrelLengthInch() ? Distance.inch(barrelLengthInch) : null;

  set barrelLength(Distance? value) {
    if (value == null) {
      clearBarrelLengthInch();
    } else {
      barrelLengthInch = value.in_(Unit.inch);
    }
  }

  bclibc.Weapon toWeapon(Distance sightHeight) => bclibc.Weapon(
    sightHeight: sightHeight,
    twist: twist,
    zeroElevation: zeroElevation,
  );
}
