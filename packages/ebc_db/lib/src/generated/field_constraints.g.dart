// GENERATED CODE — DO NOT EDIT BY HAND.
// Regenerate with: dart run bin/embed_schema.dart

import '../field_bounds.dart';

/// Numeric bounds for persisted field roles, generated from
/// schema/bounds.schema.json, schema/profiles.schema.json and
/// schema/settings.schema.json. See
/// docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7 — ConvertorsState
/// (length/weight/pressure/temperature/torque) isn't covered yet, see that
/// doc for why.
abstract final class FieldLimits {
  /// FC.temperature, celsius (-100–100). Shared by profiles.schema.json's Zero/Ammo temperature fields and settings.schema.json's ShootingConditions/VelocityConv ones.
  static const temperatureC = FieldBounds(minRaw: -100, maxRaw: 100);

  /// FC.altitude, meter (-500–15000). Shared by profiles.schema.json's Zero.altitude_meter and settings.schema.json's ShootingConditions/VelocityConv altitude fields.
  static const altitudeMeter = FieldBounds(minRaw: -500, maxRaw: 15000);

  /// FC.pressure, hPa (300–1500). Shared by profiles.schema.json's Zero.pressure_h_pa and settings.schema.json's ShootingConditions/VelocityConv pressure fields.
  static const pressureHPa = FieldBounds(minRaw: 300, maxRaw: 1500);

  /// FC.humidity, fraction (0–1). Shared by profiles.schema.json's Zero.humidity_frac and settings.schema.json's ShootingConditions/VelocityConv humidity fields.
  static const humidityFrac = FieldBounds(minRaw: 0, maxRaw: 1);

  /// FC.latitude, degree (-90–90). Shared by profiles.schema.json's Zero.latitude_deg and settings.schema.json's ShootingConditions.latitude_deg.
  static const latitudeDeg = FieldBounds(minRaw: -90, maxRaw: 90);

  /// FC.azimuth, degree (0–360). Shared by profiles.schema.json's Zero.azimuth_deg and settings.schema.json's ShootingConditions.azimuth_deg.
  static const azimuthDeg = FieldBounds(minRaw: 0, maxRaw: 360);

  /// FC.lookAngle, degree→radian (-90°..90°). Shared by profiles.schema.json's Zero.look_angle_rad and settings.schema.json's ShootingConditions.look_angle_rad.
  static const lookAngleRad = FieldBounds(minRaw: -1.5707963267948966, maxRaw: 1.5707963267948966);

  /// FC.projectileDiameter, mm→inch (1–30mm). optional in the .proto — null/absent means unset (ProfilesValidator emits null via hasCaliberInch()).
  static const projectileDiameterInch = FieldBounds(minRaw: 0.03937007874015748, maxRaw: 1.1811023622047243);

  /// FC.twist is [0,30] as an input-widget magnitude; storage is signed (direction encoded by sign, see weapon_wizard_notifier.dart).
  static const twistInch = FieldBounds(minRaw: -30, maxRaw: 30);

  /// FC.barrelLength, inch (1–36). optional in the .proto — null/absent means unset.
  static const barrelLengthInch = FieldBounds(minRaw: 1.0, maxRaw: 36.0);

  /// FC.sightHeight, mm→inch (0–200mm).
  static const sightHeightInch = FieldBounds(minRaw: 0, maxRaw: 7.874015748031496);

  /// FC.magnification, scalar (0.5–100).
  static const magnification = FieldBounds(minRaw: 0.5, maxRaw: 100);

  /// FC.zeroDistance, meter (10–1000).
  static const zeroDistanceMeter = FieldBounds(minRaw: 10, maxRaw: 1000);

  /// FC.projectileWeight, grain (1–800). optional in the .proto — null/absent means unset.
  static const projectileWeightGrain = FieldBounds(minRaw: 1, maxRaw: 800);

  /// FC.projectileLength, mm→inch (1–100mm). optional in the .proto — null/absent means unset.
  static const projectileLengthInch = FieldBounds(minRaw: 0.03937007874015748, maxRaw: 3.937007874015748);

  /// FC.ballisticCoefficient, scalar (0.001–2.000). optional in the .proto — null/absent means unset.
  static const ballisticCoefficient = FieldBounds(minRaw: 0.001, maxRaw: 2.0);

  /// FC.muzzleVelocity, mps (100–1800). optional in the .proto — null/absent means unset.
  static const muzzleVelocityMps = FieldBounds(minRaw: 100, maxRaw: 1800);

  /// FC.powderSensitivity, fraction (0–5).
  static const powderSensitivityFrac = FieldBounds(minRaw: 0, maxRaw: 5);

  /// FC.targetDistance, meter (10–3000).
  static const targetDistanceMeter = FieldBounds(minRaw: 10, maxRaw: 3000);

  /// FC.windDirection, degree (0–360).
  static const windDirectionDeg = FieldBounds(minRaw: 0, maxRaw: 360);

  /// FC.windSpeed, mps (0–30).
  static const windSpeedMps = FieldBounds(minRaw: 0, maxRaw: 30);

  /// FC.distanceStep, meter (1–1000).
  static const distanceStepMeter = FieldBounds(minRaw: 1, maxRaw: 1000);

  /// FC.tableRange, meter (0–5000).
  static const tableRangeMeter = FieldBounds(minRaw: 0, maxRaw: 5000);

  /// FC.convertorDistance, meter (0–5000).
  static const convertorDistanceMeter = FieldBounds(minRaw: 0, maxRaw: 5000);

  /// FC.convertorVelocity, mps (0–3000).
  static const convertorVelocityMps = FieldBounds(minRaw: 0, maxRaw: 3000);

  /// FC.convertorTargetPhysicalSize, inch (0–9999).
  static const convertorTargetPhysicalSizeInch = FieldBounds(minRaw: 0, maxRaw: 9999);

  /// FC.targetSize, mil (0.001–100).
  static const targetSizeMil = FieldBounds(minRaw: 0.001, maxRaw: 100);

}

/// Max element counts for Ammo's paired-array (row-wise) fields —
/// generated from each field's `maxItems` in profiles.schema.json. Only
/// caps each array's own length; does NOT check that a pair (e.g.
/// multiBcTableG1's v_mps/bc arrays) agree on length with each other —
/// see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7.
abstract final class ArrayLimits {
  static const int multiBcTableG1MaxItems = 5;
  static const int multiBcTableG7MaxItems = 5;
  static const int customDragTableMaxItems = 100;
  static const int powderSensitivityTableMaxItems = 5;
}
