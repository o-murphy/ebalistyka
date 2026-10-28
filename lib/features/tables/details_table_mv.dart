import 'package:bclibc/bclibc.dart' as bclibc;
import 'package:ebalistyka/core/formatting/unit_formatter.dart';
import 'package:ebalistyka/core/providers/formatter_provider.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/conditions_extensions.dart';
import 'package:ebalistyka/core/extensions/profile_extensions.dart';
import 'package:ebalistyka/core/extensions/weapon_extensions.dart';
import 'package:ebalistyka/core/providers/settings_provider.dart';
import 'package:ebalistyka/core/providers/shot_context_provider.dart';
import 'package:ebalistyka/core/models/field_constraints.dart';

import 'package:bclibc/unit.dart';

// ── Spoiler data ─────────────────────────────────────────────────────────────

/// A titled group of label/value rows; a null value means "no data".
class DetailsSection {
  const DetailsSection(this.title, this.rows);

  final String title;
  final List<(String label, String? value)> rows;
}

class DetailsTableData {
  final String weaponName;
  final String? caliber;
  final String? twist;
  final String? dragModel;
  final String? bc;
  final String? zeroMv;
  final String? currentMv;
  final String? zeroDist;
  final String? bulletLen;
  final String? bulletDiam;
  final String? bulletWeight;
  final String? formFactor;
  final String? sectionalDensity;
  final String? gyroStability;
  final String? temperature;
  final String? humidity;
  final String? pressure;
  final String? windSpeed;
  final String? windDir;

  const DetailsTableData({
    required this.weaponName,
    this.caliber,
    this.twist,
    this.dragModel,
    this.bc,
    this.zeroMv,
    this.currentMv,
    this.zeroDist,
    this.bulletLen,
    this.bulletDiam,
    this.bulletWeight,
    this.formFactor,
    this.sectionalDensity,
    this.gyroStability,
    this.temperature,
    this.humidity,
    this.pressure,
    this.windSpeed,
    this.windDir,
  });

  /// The details grouped as shown on screen and in the HTML report — the one
  /// place that says which value goes under which label and heading.
  List<DetailsSection> sections(AppLocalizations l10n) => [
    DetailsSection(l10n.weapon, [
      (l10n.weaponName, weaponName),
      (l10n.caliber, caliber),
      (l10n.twistRate, twist),
      (l10n.zeroDistance, zeroDist),
    ]),
    DetailsSection(l10n.cartridge, [
      (l10n.zeroMv, zeroMv),
      (l10n.currentMv, currentMv),
    ]),
    DetailsSection(l10n.projectile, [
      (l10n.dragModel, dragModel),
      (l10n.bc, bc),
      (l10n.length, bulletLen),
      (l10n.caliber, bulletDiam),
      (l10n.weight, bulletWeight),
      (l10n.formFactor, formFactor),
      (l10n.sectionalDensity, sectionalDensity),
      (l10n.gyrostabilitySg, gyroStability),
    ]),
    DetailsSection(l10n.conditions, [
      (l10n.temperature, temperature),
      (l10n.humidity, humidity),
      (l10n.pressure, pressure),
      (l10n.windSpeed, windSpeed),
      (l10n.windDirection, windDir),
    ]),
  ];
}

// ── Private builder ──────────────────────────────────────────────────────────

DetailsTableData _buildDetails(
  Profile profile,
  ShootingConditions conditions,
  UnitSettings units,
  UnitFormatter formatter,
) {
  final weapon = profile.weapon;
  final ammo = profile.ammo;
  final sight = profile.sight;

  final zeroVelocity = profile.getCalculatedZeroVelocity();
  final curVelocity = profile.getCalculatedCurrentVelocity(conditions);

  // Gyrostability (Miller)
  final sightHeight = Distance.inch(sight.sightHeightInch);
  final bcWeapon = weapon.toWeapon(sightHeight);
  final currentShot = profile.toCurrentShot(conditions, bcWeapon);
  final sg = currentShot.calculateStabilityCoefficient();

  // Sectional density + form factor
  final sd = bclibc.calculateSectionalDensity(
    ammo.weightGrain,
    ammo.caliberInch,
  );
  final displayBc = ammo.isMultiBC
      ? 0.0
      : (ammo.dragType == DragType.g7 ? ammo.bc7 : ammo.bc1) ?? 0.0;
  final ff = (displayBc > 0) ? sd / displayBc : null;

  return DetailsTableData(
    weaponName: weapon.name,
    caliber: formatter.diameter(weapon.caliber),
    twist: formatter.twist(weapon.twist),
    dragModel: switch (ammo.dragType) {
      DragType.g1 => 'G1',
      DragType.g7 => 'G7',
      DragType.custom => 'CUSTOM',
    },
    bc: displayBc > 0
        ? displayBc.toStringAsFixed(FC.ballisticCoefficient.accuracy)
        : null,
    zeroMv: formatter.velocity(zeroVelocity),
    currentMv: formatter.velocity(curVelocity),
    zeroDist: formatter.distance(ammo.zeroDistance),
    bulletLen: formatter.length(ammo.length),
    bulletDiam: formatter.diameter(ammo.caliber),
    bulletWeight: formatter.weight(ammo.weight),
    formFactor: ff?.toStringAsFixed(3),
    sectionalDensity: sd.toStringAsFixed(3),
    gyroStability: sg.toStringAsFixed(2),
    temperature: formatter.temperature(conditions.temperature),
    humidity: formatter.humidity(conditions.humidity),
    pressure: formatter.pressure(conditions.pressure),
    windSpeed: formatter.windSpeed(conditions.windSpeed),
    windDir: formatter.windDirection(conditions.windDirection),
  );
}

// ── Provider ─────────────────────────────────────────────────────────────────

final detailsTableMvProvider = Provider<DetailsTableData?>((ref) {
  final ctx = ref.watch(shotContextProvider).value;
  final units = ref.watch(unitSettingsProvider);
  final formatter = ref.watch(unitFormatterProvider);

  if (ctx == null || !ctx.profile.isReadyForCalculation) return null;

  return _buildDetails(ctx.profile, ctx.conditions, units, formatter);
});
