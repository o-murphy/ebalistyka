import 'package:dart_bclibc_flutter/bclibc.dart' as bclibc;
import 'package:dart_bclibc_flutter/unit.dart';
import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebc_db/ebc_db.dart';

extension ProfileExtension on Profile {
  // Named to avoid colliding with protobuf's own generated `hasWeapon()`/
  // `hasSight()` methods, which check wire presence, not `.name`.
  bool get isWeaponSelected => weapon.name.isNotEmpty;
  bool get isSightSelected => sight.name.isNotEmpty;

  /// `sight.sightHeightInch` feeds directly into [toZeroShot]'s
  /// `bclibc.Weapon.sightHeight` (see `ballistics_service_impl.dart`'s
  /// `weapon.toWeapon(sight.sightHeight)`) — an unset `Sight` silently
  /// defaults it to `0`, which still "calculates" but against a bogus
  /// sight height, not a genuine absence-of-data error. So a missing
  /// sight has to gate readiness here, same as ammo/weapon, rather than
  /// being left to produce a quietly wrong trajectory.
  bool get isReadyForCalculation =>
      isWeaponSelected && isSightSelected && ammo.isReadyForCalculation;

  Velocity getCalculatedZeroVelocity() =>
      ammo.toZeroAmmo().getVelocityForTemp(ammo.toZeroAtmo().powderTemp);

  Velocity getCalculatedCurrentVelocity(ShootingConditions cond) => ammo
      .toCurrentAmmo(cond)
      .getVelocityForTemp(cond.toCurrentAtmo().powderTemp);

  bclibc.Shot toZeroShot(bclibc.Weapon weapon, Angular lookAngle) => bclibc.Shot(
    weapon: weapon,
    ammo: ammo.toZeroAmmo(),
    lookAngle: lookAngle,
    atmo: ammo.toZeroAtmo(),
    winds: const [],
    latitudeDeg: ammo.zeroUseCoriolis ? ammo.zeroLatitude.in_(Unit.degree) : null,
    azimuthDeg: ammo.zeroUseCoriolis ? ammo.zeroAzimuth.in_(Unit.degree) : null,
  );

  bclibc.Shot toCurrentShot(ShootingConditions cond, bclibc.Weapon weapon) =>
      bclibc.Shot(
        weapon: weapon,
        ammo: ammo.toCurrentAmmo(cond),
        lookAngle: cond.lookAngle,
        atmo: cond.toCurrentAtmo(),
        winds: [cond.toWind()],
        latitudeDeg: cond.useCoriolis ? cond.latitude.in_(Unit.degree) : null,
        azimuthDeg: cond.useCoriolis ? cond.azimuth.in_(Unit.degree) : null,
      );
}
