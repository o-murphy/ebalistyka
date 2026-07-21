import 'dart:math' show pi;

import 'package:dart_bclibc/bclibc.dart' as bclibc;
import 'package:dart_bclibc/unit.dart';
import 'package:ebc_db/ebc_db.dart';

extension ConditionsExtension on ShootingConditions {
  // ── Distance ────────────────────────────────────────────────────────────────

  Distance get distance => Distance.meter(distanceMeter);
  set distance(Distance v) => distanceMeter = v.in_(Unit.meter);

  Distance get altitude => Distance.meter(altitudeMeter);
  set altitude(Distance v) => altitudeMeter = v.in_(Unit.meter);

  // ── Angle ───────────────────────────────────────────────────────────────────

  Angular get lookAngle => Angular.radian(lookAngleRad);
  set lookAngle(Angular v) => lookAngleRad = v.in_(Unit.radian);

  // windDirection/azimuth are compass bearings, stored as [0,360) — but
  // Angular's own raw representation is always normalized to (-180,180]
  // (see dart_bclibc's Angular._toRaw), so e.g. Angular.degree(240).in_
  // (Unit.degree) comes back as -120.0, not 240.0. Re-normalize into
  // [0,360) here, at the one place these fields cross from Angular into
  // storage — otherwise a bearing past 180° gets stored negative, which
  // FieldLimits.windDirectionDeg/.azimuthDeg's [0,360] *clamp* (not a
  // wrap) then collapses to 0 instead of the equivalent positive bearing.
  Angular get windDirection => Angular.degree(windDirectionDeg);
  set windDirection(Angular v) =>
      windDirectionDeg = ((v.in_(Unit.degree) % 360) + 360) % 360;

  Angular get latitude => Angular.degree(latitudeDeg);
  set latitude(Angular v) => latitudeDeg = v.in_(Unit.degree);

  Angular get azimuth => Angular.degree(azimuthDeg);
  set azimuth(Angular v) =>
      azimuthDeg = ((v.in_(Unit.degree) % 360) + 360) % 360;

  // ── Atmosphere ──────────────────────────────────────────────────────────────

  Temperature get temperature =>
      Temperature.celsius(hasTemperatureC() && temperatureC != 0 ? temperatureC : 15.0);
  set temperature(Temperature v) => temperatureC = v.in_(Unit.celsius);

  Temperature get powderTemperature => Temperature.celsius(powderTemperatureC);
  set powderTemperature(Temperature v) =>
      powderTemperatureC = v.in_(Unit.celsius);

  Pressure get pressure =>
      Pressure.hPa(hasPressureHPa() && pressureHPa != 0 ? pressureHPa : 1013.25);
  set pressure(Pressure v) => pressureHPa = v.in_(Unit.hPa);

  Ratio get humidity => Ratio.fraction(humidityFrac);
  set humidity(Ratio v) => humidityFrac = v.in_(Unit.fraction);

  // ── Wind ────────────────────────────────────────────────────────────────────

  Velocity get windSpeed => Velocity.mps(windSpeedMps);
  set windSpeed(Velocity v) => windSpeedMps = v.in_(Unit.mps);

  // ── bclibc conversion ────────────────────────────────────────────────────────

  bclibc.Atmo toCurrentAtmo() => bclibc.Atmo(
    altitude: altitude,
    pressure: pressure,
    temperature: temperature,
    humidity: humidityFrac,
    powderTemperature: useDiffPowderTemp ? powderTemperature : temperature,
  );

  bclibc.Wind toWind() => bclibc.Wind(
    velocity: windSpeed,
    // The C library's wind formula uses z = vel*sin(dir) where positive z = air
    // moves right. Our UI stores the "wind FROM" angle (clock convention), so
    // 90° = wind from right = air moves LEFT = negative z. Adding π converts
    // "from" direction to "to" direction, matching the C library expectation.
    directionFrom: Angular.radian(windDirection.in_(Unit.radian) + pi),
  );
}
