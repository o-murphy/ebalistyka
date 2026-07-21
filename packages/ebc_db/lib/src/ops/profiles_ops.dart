import 'package:uuid/uuid.dart';

import '../generated/field_constraints.g.dart';
import '../proto/profiles.pb.dart';

// The "index 0 is active" convention and the "every copy gets a fresh
// uuid" invariant are facts about ProfilesData's shape — encoded once
// here, next to the type that owns them, rather than re-derived at every
// call site in the app. All three functions take the old value, return a
// new one; none mutate their argument.

const _uuid = Uuid();

/// `profiles[0]` is the active profile, by convention.
Profile? activeProfileOf(List<Profile> profiles) => profiles.firstOrNull;

/// Moves the profile matching [uuid] to index 0. Every other profile
/// keeps its relative order. No-op (returns [profiles] unchanged by
/// value, same order) if [uuid] isn't found.
List<Profile> setActiveProfileOf(List<Profile> profiles, String uuid) {
  final index = profiles.indexWhere((p) => p.uuid == uuid);
  if (index <= 0) return profiles;

  final next = profiles.toList();
  final selected = next.removeAt(index);
  next.insert(0, selected);
  return next;
}

/// Copies [profile] with a freshly generated `uuid`. This is the one
/// place `uuid` regeneration happens — `duplicateProfile`, export, and
/// import all go through this, never regenerating a `uuid` independently.
Profile copyWithFreshUuid(Profile profile) => profile.deepCopy()..uuid = _uuid.v4();

/// Clamps every numeric field this package generates a [FieldLimits] role
/// for into range, on a copy of [profile] — the "reject/repair invalid
/// writes" gate from docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7.
/// Called once, here, rather than ad hoc per `updateX` method in `lib/`
/// (see that doc's "no centralized reject invalid writes gate" note).
///
/// Fields with no generated role are left untouched: `Weapon
/// .zeroElevationRad` (a cached derived value, not a direct input — see
/// that doc) and anything not covered by this pass.
Profile sanitizeProfile(Profile profile) {
  final next = profile.deepCopy();
  // ensureX() (not the plain getter) so an unset sub-message becomes a
  // writable instance instead of the shared frozen default — mutating that
  // default in place would throw.
  _sanitizeWeapon(next.ensureWeapon());
  _sanitizeSight(next.ensureSight());
  _sanitizeAmmo(next.ensureAmmo());
  return next;
}

void _sanitizeWeapon(Weapon w) {
  if (w.hasCaliberInch()) {
    w.caliberInch = FieldLimits.projectileDiameterInch.clamp(w.caliberInch);
  }
  w.twistInch = FieldLimits.twistInch.clamp(w.twistInch);
  if (w.hasBarrelLengthInch()) {
    w.barrelLengthInch = FieldLimits.barrelLengthInch.clamp(w.barrelLengthInch);
  }
}

void _sanitizeSight(Sight s) {
  s.sightHeightInch = FieldLimits.sightHeightInch.clamp(s.sightHeightInch);
  s.sightHorizontalOffsetInch = FieldLimits.sightHeightInch.clamp(s.sightHorizontalOffsetInch);
  s.minMagnification = FieldLimits.magnification.clamp(s.minMagnification);
  s.maxMagnification = FieldLimits.magnification.clamp(s.maxMagnification);
  if (s.hasCalibratedMagnification()) {
    s.calibratedMagnification = FieldLimits.magnification.clamp(s.calibratedMagnification);
  }
}

void _sanitizeAmmo(Ammo a) {
  if (a.hasCaliberInch()) {
    a.caliberInch = FieldLimits.projectileDiameterInch.clamp(a.caliberInch);
  }
  if (a.hasWeightGrain()) {
    a.weightGrain = FieldLimits.projectileWeightGrain.clamp(a.weightGrain);
  }
  if (a.hasLengthInch()) {
    a.lengthInch = FieldLimits.projectileLengthInch.clamp(a.lengthInch);
  }
  if (a.hasBcG1()) {
    a.bcG1 = FieldLimits.ballisticCoefficient.clamp(a.bcG1);
  }
  if (a.hasBcG7()) {
    a.bcG7 = FieldLimits.ballisticCoefficient.clamp(a.bcG7);
  }
  if (a.hasMuzzleVelocityMps()) {
    a.muzzleVelocityMps = FieldLimits.muzzleVelocityMps.clamp(a.muzzleVelocityMps);
  }
  a.muzzleVelocityTemperatureC = FieldLimits.temperatureC.clamp(a.muzzleVelocityTemperatureC);
  a.powderSensitivityFrac = FieldLimits.powderSensitivityFrac.clamp(a.powderSensitivityFrac);
  _sanitizeZero(a.ensureZero());
}

void _sanitizeZero(Zero z) {
  z.distanceMeter = FieldLimits.zeroDistanceMeter.clamp(z.distanceMeter);
  z.lookAngleRad = FieldLimits.lookAngleRad.clamp(z.lookAngleRad);
  z.altitudeMeter = FieldLimits.altitudeMeter.clamp(z.altitudeMeter);
  z.temperatureC = FieldLimits.temperatureC.clamp(z.temperatureC);
  z.pressureHPa = FieldLimits.pressureHPa.clamp(z.pressureHPa);
  z.humidityFrac = FieldLimits.humidityFrac.clamp(z.humidityFrac);
  z.powderTemperatureC = FieldLimits.temperatureC.clamp(z.powderTemperatureC);
  z.latitudeDeg = FieldLimits.latitudeDeg.clamp(z.latitudeDeg);
  z.azimuthDeg = FieldLimits.azimuthDeg.clamp(z.azimuthDeg);
}
