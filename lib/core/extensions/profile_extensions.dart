import 'package:dart_bclibc/bclibc.dart' as bclibc;
import 'package:dart_bclibc/unit.dart';
import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebc_db/ebc_db.dart';

extension ProfileExtension on Profile {
  bool get isReadyForCalculation => ammo.isReadyForCalculation;

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
