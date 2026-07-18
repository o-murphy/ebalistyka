import 'package:dart_bclibc/unit.dart';
import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/core/extensions/weapon_extensions.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/widgets.dart' hide Velocity;
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

SettingsData seedSettings() {
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final resolvedLocale = AppLocalizations.supportedLocales.firstWhere(
    (l) => l.languageCode == systemLocale.languageCode,
    orElse: () => const Locale('en'),
  );

  return SettingsData()
    ..generalSettings = (GeneralSettings()
      ..languageCode = resolvedLocale.languageCode
      ..homeShowMil = true
      ..homeShowMoa = true
      ..homeShowCmPer100m = true
      ..homeShowInClicks = true
      ..homeChartDistanceStep = 10.0
      ..homeTableDistanceStep = 10.0)
    ..unitSettings = UnitSettings()
    ..tablesSettings = (TablesSettings()
      ..distanceEndMeter = 1000.0
      ..distanceStepMeter = 100.0
      ..showZeros = true
      ..showSubsonicTransition = true
      ..showMil = true
      ..showMoa = true
      ..showCmPer100m = true
      ..showInClicks = true)
    ..reticleSettings = ReticleSettings()
    ..convertorsState = ConvertorsState()
    ..shootingConditions = (ShootingConditions()
      ..temperatureC = 15.0
      ..pressureHPa = 1013.25
      ..powderTemperatureC = 15.0
      ..humidityFrac = 0.5
      ..distanceMeter = 450.0);
}

List<Profile> seedProfiles() {
  final sight = Sight()
    ..name = 'Nightforce ATACR 7-35x56 F1 ZeroS 0.1 MIL DigIllum PTL'
    ..vendor = 'Nightforce'
    ..sightHeight = Distance.inch(1.575)
    ..minMagnification = 7
    ..maxMagnification = 35
    ..focalPlane = FocalPlane.ffp
    ..verticalClick = 0.1
    ..horizontalClick = 0.1
    ..verticalClickUnitValue = Unit.mil
    ..horizontalClickUnitValue = Unit.mil;

  final ammo = Ammo()
    ..name = 'Hornady 285GR ELD-M'
    ..vendor = 'Hornady'
    ..dragType = DragType.g7
    ..weight = Weight.grain(285.0)
    ..caliber = Distance.inch(0.338)
    ..length = Distance.inch(1.746)
    ..bcG7 = 0.397
    ..bcG1 = 0.791
    ..mv = Velocity.mps(827.0)
    ..mvTemperature = Temperature.celsius(15.0)
    ..powderSensitivity = Ratio.fraction(0.0144)
    ..zeroDistance = Distance.meter(100.0);

  final weapon = Weapon()
    ..name = 'Cadex Defence Kraken CDX-MC'
    ..vendor = 'Cadex'
    ..caliber = Distance.inch(0.338)
    ..caliberName = '338 Lapua Magnum'
    ..twist = Distance.inch(9.5)
    ..barrelLength = Distance.inch(26.0);

  final profile = Profile()
    ..uuid = _uuid.v4()
    ..name = weapon.name
    ..weapon = weapon
    ..ammo = ammo
    ..sight = sight;

  return [profile];
}
