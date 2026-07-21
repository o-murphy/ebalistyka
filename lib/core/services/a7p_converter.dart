import 'package:a7p/a7p.dart' as proto;
import 'package:ebc_db/ebc_db.dart';

// ── Multipliers from the a7p specification ────────────────────────────────────
// sc_height   : mm   × 1
// r_twist     : inch × 100
// c_muzzle_velocity : mps  × 10
// c_t_coeff   : %/15°C × 1000
// c_zero_air_pressure : hPa × 10
// c_zero_air_humidity : % × 1   (0–100)
// b_diameter  : inch × 1000
// b_weight    : grain × 10
// b_length    : inch × 1000
// distances   : m × 100
// coef_rows.bc_cd (G1/G7) : bc × 10000
// coef_rows.mv    (G1/G7) : mps × 10
// coef_rows.bc_cd (CUSTOM): Cd × 10000
// coef_rows.mv    (CUSTOM): mach × 10000

const _kInchToMm = 25.4;

enum A7pRange { subsonic, low, medium, long, ultra }

/// Bridges the a7p protobuf `proto.Payload` (from `package:a7p`, which only
/// speaks the wire format — it has no notion of this app's domain model)
/// and this app's own `ebc_db.Profile`/`Weapon`/`Ammo`/`Sight`/`Zero`.
///
/// Ported to `ebc_db` types directly (previously bridged through
/// `ebalistyka_db`'s now-removed `ProfileExport`/`WeaponExport`/etc. DTOs —
/// see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 3.5). Fields a7p
/// has no concept of (look angle, altitude, latitude, azimuth, coriolis,
/// barrel length, calibrated magnification, ...) are left **unset** on
/// import rather than defaulted to 0 — several of those are optional/
/// nullable in `Profile`'s schema specifically so "not provided" can be
/// represented, and `sanitizeProfile` (the centralized clamp gate) still
/// clamps every field that *is* set into its valid range on save.
abstract final class A7pConverter {
  // ── proto → Profile (import) ─────────────────────────────────────────────────

  static Profile fromPayload(proto.Payload payload, {bool validate = true}) {
    if (validate) proto.A7pValidator.validate(payload);
    return _fromProfile(payload.profile);
  }

  static Profile _fromProfile(proto.Profile p) {
    final weapon = Weapon()
      ..name = p.profileName
      ..caliberInch = p.bDiameter / 1000.0
      ..caliberName = p.caliber
      ..twistInch =
          (p.twistDir == proto.TwistDir.LEFT ? -1.0 : 1.0) * (p.rTwist / 100.0);
    // barrelLengthInch, zeroElevationRad: a7p has neither (the latter is a
    // cached derived value anyway) — left unset.

    return Profile()
      ..name = p.profileName
      ..weapon = weapon
      ..ammo = _ammoFromProfile(p)
      ..sight = _sightFromProfile(p);
  }

  static Ammo _ammoFromProfile(proto.Profile p) {
    final zeroMeter = p.distances.isNotEmpty
        ? p.distances[p.cZeroDistanceIdx.clamp(0, p.distances.length - 1)] /
              100.0
        : 100.0;

    final ammo = Ammo()
      ..name = p.cartridgeName
      ..projectileName = p.bulletName
      ..caliberInch = p.bDiameter / 1000.0
      ..weightGrain = p.bWeight / 10.0
      ..lengthInch = p.bLength / 1000.0
      ..muzzleVelocityMps = p.cMuzzleVelocity / 10.0
      ..muzzleVelocityTemperatureC = p.cZeroTemperature.toDouble()
      ..usePowderSensitivity = p.cTCoeff >= 0
      ..powderSensitivityFrac = (p.cTCoeff / 1000.0) / 100.0;

    switch (p.bcType) {
      case proto.GType.G1:
        ammo.dragTypeValue = 'g1';
        if (p.coefRows.isNotEmpty) {
          ammo.bcG1 = p.coefRows.first.bcCd / 10000.0;
          if (p.coefRows.length > 1) {
            ammo.useMultiBcG1 = true;
            ammo.multiBcTableG1.addAll(
              p.coefRows.map(
                (r) => MultiBcPoint(vMps: r.mv / 10.0, bc: r.bcCd / 10000.0),
              ),
            );
          }
        }
      case proto.GType.G7:
        ammo.dragTypeValue = 'g7';
        if (p.coefRows.isNotEmpty) {
          ammo.bcG7 = p.coefRows.first.bcCd / 10000.0;
          if (p.coefRows.length > 1) {
            ammo.useMultiBcG7 = true;
            ammo.multiBcTableG7.addAll(
              p.coefRows.map(
                (r) => MultiBcPoint(vMps: r.mv / 10.0, bc: r.bcCd / 10000.0),
              ),
            );
          }
        }
      case proto.GType.CUSTOM:
        ammo.dragTypeValue = 'custom';
        final sorted = List.of(p.coefRows)
          ..sort((a, b) => a.mv.compareTo(b.mv));
        ammo.customDragTableMach.addAll(sorted.map((r) => r.mv / 10000.0));
        ammo.customDragTableCd.addAll(sorted.map((r) => r.bcCd / 10000.0));
      default:
        ammo.dragTypeValue = 'g1';
    }

    ammo.zero = Zero()
      ..distanceMeter = zeroMeter
      ..temperatureC = p.cZeroAirTemperature.toDouble()
      ..pressureHPa = p.cZeroAirPressure / 10.0
      ..humidityFrac = p.cZeroAirHumidity / 100.0
      ..useDiffPowderTemperature = p.cZeroPTemperature != p.cZeroAirTemperature
      ..useCoriolis = false
      ..powderTemperatureC = p.cZeroPTemperature.toDouble()
      ..offsetX = 0.0
      ..offsetY = 0.0
      ..offsetXUnit = 'mil'
      ..offsetYUnit = 'mil';
    // lookAngleRad/altitudeMeter/latitudeDeg/azimuthDeg: a7p has none of
    // these concepts — left at Zero's own defaults (0.0).

    return ammo;
  }

  static Sight _sightFromProfile(proto.Profile p) => Sight()
    ..name = p.profileName
    ..focalPlaneValue = 'ffp'
    ..sightHeightInch = p.scHeight / _kInchToMm
    ..sightHorizontalOffsetInch = 0.0
    ..verticalClick = 0.1
    ..horizontalClick = 0.1
    ..verticalClickUnit = 'mil'
    ..horizontalClickUnit = 'mil'
    ..minMagnification = 0.0
    ..maxMagnification = 0.0;
  // reticleImage/calibratedMagnification: a7p has neither — left unset
  // (calibratedMagnification is optional/nullable specifically for this).

  // ── Profile → proto (export) ──────────────────────────────────────────────────

  static int _findClosestDistanceIndex(List<int> distances, int target) {
    if (distances.isEmpty) return 0;

    int closestIndex = 0;
    int minDiff = (distances[0] - target).abs();

    for (int i = 1; i < distances.length; i++) {
      final diff = (distances[i] - target).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestIndex = i;
      }
    }

    return closestIndex;
  }

  static proto.Payload toPayload(Profile profile, [A7pRange? range]) {
    final ammo = profile.ammo;
    final sight = profile.sight;
    final weapon = profile.weapon;

    final distancesTable = switch (range) {
      A7pRange.subsonic => subsonicRangeTable,
      A7pRange.low => lowRangeTable,
      A7pRange.medium => mediumRangeTable,
      A7pRange.long => longRangeTable,
      A7pRange.ultra => ultraLongRangeTable,
      _ => mediumRangeTable,
    };
    final zeroDistanceMeter = ammo.zero.distanceMeter.toInt();
    final zeroDistanceIdx = _findClosestDistanceIndex(
      distancesTable,
      zeroDistanceMeter,
    );
    final distances = distancesTable.map((el) => el * 100);

    final profileName = profile.name.substring(
      0,
      profile.name.length.clamp(0, 50),
    );
    final shortTop = profileName.substring(0, profileName.length.clamp(0, 8));
    final shortBot = profileName.length > 8
        ? profileName.substring(8, profileName.length.clamp(8, 16))
        : '';

    final scHeight = (sight.sightHeightInch * _kInchToMm).round();
    final rTwist = (weapon.twistInch.abs() * 100).round().clamp(0, 10000);
    final twistDir = weapon.twistInch < 0
        ? proto.TwistDir.LEFT
        : proto.TwistDir.RIGHT;

    final mv = (ammo.hasMuzzleVelocityMps() ? ammo.muzzleVelocityMps : 300.0) *
            10;
    final muzzleVelocity = mv.round().clamp(10, 30000);
    final zeroTemp = ammo.muzzleVelocityTemperatureC.round().clamp(-100, 100);
    final tCoeff = ((ammo.powderSensitivityFrac * 100) * 1000)
        .round()
        .clamp(0, 5000);
    final caliberInch = ammo.hasCaliberInch()
        ? ammo.caliberInch
        : (weapon.hasCaliberInch() ? weapon.caliberInch : 0.001);
    final bDiameter = (caliberInch * 1000).round().clamp(1, 50000);
    final bWeight = ((ammo.hasWeightGrain() ? ammo.weightGrain : 100.0) * 10)
        .round()
        .clamp(10, 65535);
    final bLength = ((ammo.hasLengthInch() ? ammo.lengthInch : 0.1) * 1000)
        .round()
        .clamp(1, 200000);

    final zero = ammo.zero;
    final zeroAirTemp = zero.temperatureC.round().clamp(-100, 100);
    final zeroAirPres = (zero.pressureHPa * 10).round().clamp(3000, 15000);
    final zeroHumidity = (zero.humidityFrac * 100).round().clamp(0, 100);
    final zeroPowderTemp = zero.powderTemperatureC.round().clamp(-100, 100);

    final coefRows = _buildCoefRows(ammo);
    final bcType = _bcType(ammo.dragTypeValue);

    final protoProfile = proto.Profile()
      ..profileName = profileName
      ..cartridgeName = (ammo.name.isNotEmpty ? ammo.name : profile.name)
          .substring(
            0,
            (ammo.name.isNotEmpty ? ammo.name : profile.name).length.clamp(
              0,
              50,
            ),
          )
      ..bulletName =
          (ammo.projectileName.isNotEmpty
                  ? ammo.projectileName
                  : (ammo.name.isNotEmpty ? ammo.name : profile.name))
              .substring(
                0,
                (ammo.projectileName.isNotEmpty
                        ? ammo.projectileName
                        : (ammo.name.isNotEmpty ? ammo.name : profile.name))
                    .length
                    .clamp(0, 50),
              )
      ..shortNameTop = shortTop
      ..shortNameBot = shortBot
      ..caliber = weapon.caliberName.substring(
        0,
        weapon.caliberName.length.clamp(0, 50),
      )
      ..scHeight = scHeight.clamp(-5000, 5000)
      ..rTwist = rTwist
      ..twistDir = twistDir
      ..cMuzzleVelocity = muzzleVelocity
      ..cZeroTemperature = zeroTemp
      ..cTCoeff = tCoeff
      ..bDiameter = bDiameter
      ..bWeight = bWeight
      ..bLength = bLength
      ..bcType = bcType
      ..cZeroDistanceIdx = zeroDistanceIdx
      ..cZeroAirTemperature = zeroAirTemp
      ..cZeroAirPressure = zeroAirPres
      ..cZeroAirHumidity = zeroHumidity
      ..cZeroWPitch = 0
      ..cZeroPTemperature = zeroPowderTemp
      ..zeroX = 0
      ..zeroY = 0
      ..distances.addAll(distances)
      ..coefRows.addAll(coefRows)
      ..switches.addAll(_defaultSwitches());

    return proto.Payload()..profile = protoProfile;
  }

  static List<proto.CoefRow> _buildCoefRows(Ammo ammo) {
    switch (ammo.dragTypeValue) {
      case 'g7':
        if (ammo.useMultiBcG7 && ammo.multiBcTableG7.isNotEmpty) {
          return ammo.multiBcTableG7
              .map(
                (p) => proto.CoefRow()
                  ..mv = (p.vMps * 10).round()
                  ..bcCd = (p.bc * 10000).round(),
              )
              .toList();
        }
        return [
          proto.CoefRow()
            ..mv = 0
            ..bcCd = (ammo.bcG7 * 10000).round(),
        ];
      case 'custom':
        if (ammo.customDragTableMach.isNotEmpty &&
            ammo.customDragTableCd.isNotEmpty) {
          final rows = List.generate(
            ammo.customDragTableMach.length,
            (i) => proto.CoefRow()
              ..mv = (ammo.customDragTableMach[i] * 10000).round()
              ..bcCd = (ammo.customDragTableCd[i] * 10000).round(),
          );
          rows.sort((a, b) => a.mv.compareTo(b.mv));
          return rows;
        }
        return [
          proto.CoefRow()
            ..mv = 0
            ..bcCd = 0,
        ];
      default: // g1
        if (ammo.useMultiBcG1 && ammo.multiBcTableG1.isNotEmpty) {
          return ammo.multiBcTableG1
              .map(
                (p) => proto.CoefRow()
                  ..mv = (p.vMps * 10).round()
                  ..bcCd = (p.bc * 10000).round(),
              )
              .toList();
        }
        return [
          proto.CoefRow()
            ..mv = 0
            ..bcCd = (ammo.bcG1 * 10000).round(),
        ];
    }
  }

  static List<proto.SwPos> _defaultSwitches() => List.generate(
    4,
    (_) => proto.SwPos()
      ..cIdx = 0
      ..distanceFrom = proto.DType.INDEX
      ..distance = 0
      ..reticleIdx = 0
      ..zoom = 1,
  );

  static proto.GType _bcType(String dt) => switch (dt) {
    'g7' => proto.GType.G7,
    'custom' => proto.GType.CUSTOM,
    _ => proto.GType.G1,
  };
}

const List<int> subsonicRangeTable = [
  // 25-400
  25, 50, 75, 100, 110, 120, 130, 140, 150, 155, 160, 165, 170, 175, 180, 185,
  190, 195, 200, 205, 210, 215, 220, 225, 230, 235, 240, 245, 250, 255, 260,
  265, 270, 275, 280, 285, 290, 295, 300, 305, 310, 315, 320, 325, 330, 335,
  340, 345, 350, 355, 360, 365, 370, 375, 380, 385, 390, 395, 400,
];
const List<int> lowRangeTable = [
  // 100-700
  100, 150, 200, 225, 250, 275, 300, 320, 340, 360, 380, 400, 410, 420, 430,
  440, 450, 460, 470, 480, 490, 500, 505, 510, 515, 520, 525, 530, 535, 540,
  545, 550, 555, 560, 565, 570, 575, 580, 585, 590, 595, 600, 605, 610, 615,
  620, 625, 630, 635, 640, 645, 650, 655, 660, 665, 670, 675, 680, 685, 690,
  695, 700,
];
const List<int> mediumRangeTable = [
  // 100 - 1000
  100, 200, 250, 300, 325, 350, 375, 400, 420, 440, 460, 480, 500, 520, 540,
  560, 580, 600, 610, 620, 630, 640, 650, 660, 670, 680, 690, 700, 710, 720,
  730, 740, 750, 760, 770, 780, 790, 800, 805, 810, 815, 820, 825, 830, 835,
  840, 845, 850, 855, 860, 865, 870, 875, 880, 885, 890, 895, 900, 905, 910,
  915, 920, 925, 930, 935, 940, 945, 950, 955, 960, 965, 970, 975, 980, 985,
  990, 995, 1000,
];
const List<int> longRangeTable = [
  // 100 - 1700
  100, 200, 250, 300, 350, 400, 420, 440, 460, 480, 500, 520, 540, 560, 580,
  600, 610, 620, 630, 640, 650, 660, 670, 680, 690, 700, 710, 720, 730, 740,
  750, 760, 770, 780, 790, 800, 810, 820, 830, 840, 850, 860, 870, 880, 890,
  900, 910, 920, 930, 940, 950, 960, 970, 980, 990, 1000, 1005, 1010, 1015,
  1020, 1025, 1030, 1035, 1040, 1045, 1050, 1055, 1060, 1065, 1070, 1075,
  1080, 1085, 1090, 1095, 1100, 1105, 1110, 1115, 1120, 1125, 1130, 1135,
  1140, 1145, 1150, 1155, 1160, 1165, 1170, 1175, 1180, 1185, 1190, 1195,
  1200, 1205, 1210, 1215, 1220, 1225, 1230, 1235, 1240, 1245, 1250, 1255,
  1260, 1265, 1270, 1275, 1280, 1285, 1290, 1295, 1300, 1305, 1310, 1315,
  1320, 1325, 1330, 1335, 1340, 1345, 1350, 1355, 1360, 1365, 1370, 1375,
  1380, 1385, 1390, 1395, 1400, 1405, 1410, 1415, 1420, 1425, 1430, 1435,
  1440, 1445, 1450, 1455, 1460, 1465, 1470, 1475, 1480, 1485, 1490, 1495,
  1500, 1505, 1510, 1515, 1520, 1525, 1530, 1535, 1540, 1545, 1550, 1555,
  1560, 1565, 1570, 1575, 1580, 1585, 1590, 1595, 1600, 1605, 1610, 1615,
  1620, 1625, 1630, 1635, 1640, 1645, 1650, 1655, 1660, 1665, 1670, 1675,
  1680, 1685, 1690, 1695, 1700,
];
const List<int> ultraLongRangeTable = [
  100, 200, 250, 300, 350, 400, 450, 500, 520, 540, 560, 580, 600, 620, 640,
  660, 680, 700, 720, 740, 760, 780, 800, 820, 840, 860, 880, 900, 920, 940,
  960, 980, 1000, 1010, 1020, 1030, 1040, 1050, 1060, 1070, 1080, 1090, 1100,
  1110, 1120, 1130, 1140, 1150, 1160, 1170, 1180, 1190, 1200, 1210, 1220,
  1230, 1240, 1250, 1260, 1270, 1280, 1290, 1300, 1310, 1320, 1330, 1340,
  1350, 1360, 1370, 1380, 1390, 1400, 1410, 1420, 1430, 1440, 1450, 1460,
  1470, 1480, 1490, 1500, 1510, 1520, 1530, 1540, 1550, 1560, 1570, 1580,
  1590, 1600, 1610, 1620, 1630, 1640, 1650, 1660, 1670, 1680, 1690, 1700,
  1705, 1710, 1715, 1720, 1725, 1730, 1735, 1740, 1745, 1750, 1755, 1760,
  1765, 1770, 1775, 1780, 1785, 1790, 1795, 1800, 1805, 1810, 1815, 1820,
  1825, 1830, 1835, 1840, 1845, 1850, 1855, 1860, 1865, 1870, 1875, 1880,
  1885, 1890, 1895, 1900, 1905, 1910, 1915, 1920, 1925, 1930, 1935, 1940,
  1945, 1950, 1955, 1960, 1965, 1970, 1975, 1980, 1985, 1990, 1995, 2000,
  2005, 2010, 2015, 2020, 2025, 2030, 2035, 2040, 2045, 2050, 2055, 2060,
  2065, 2070, 2075, 2080, 2085, 2090, 2095, 2100, 2105, 2110, 2115, 2120,
  2125, 2130, 2135, 2140, 2145, 2150, 2155, 2160, 2165, 2170, 2175, 2180,
  2185,
];
