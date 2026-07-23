import 'package:dart_bclibc_flutter/unit.dart';
import 'package:ebc_db/ebc_db.dart';

enum FocalPlane { ffp, sfp, lwir }

extension SightExtension on Sight {
  // ── Enum ─────────────────────────────────────────────────────────────────────

  FocalPlane get focalPlane => FocalPlane.values.firstWhere(
    (e) => e.name == focalPlaneValue,
    orElse: () => FocalPlane.ffp,
  );
  set focalPlane(FocalPlane v) => focalPlaneValue = v.name;

  bool get isFFP => focalPlane == FocalPlane.ffp;

  // ── Physical unit getters/setters ────────────────────────────────────────────

  Distance get sightHeight => Distance.inch(sightHeightInch);
  set sightHeight(Distance v) => sightHeightInch = v.in_(Unit.inch);

  Distance get horizontalOffset => Distance.inch(sightHorizontalOffsetInch);
  set horizontalOffset(Distance v) =>
      sightHorizontalOffsetInch = v.in_(Unit.inch);

  double? get calibratedMag =>
      hasCalibratedMagnification() ? calibratedMagnification : null;
  set calibratedMag(double? value) {
    if (value == null) {
      clearCalibratedMagnification();
    } else {
      calibratedMagnification = value;
    }
  }

  // ── Click units ──────────────────────────────────────────────────────────────

  Unit get verticalClickUnitValue => Unit.values.firstWhere(
    (u) => u.name == verticalClickUnit,
    orElse: () => Unit.mil,
  );
  set verticalClickUnitValue(Unit v) => verticalClickUnit = v.name;

  Unit get horizontalClickUnitValue => Unit.values.firstWhere(
    (u) => u.name == horizontalClickUnit,
    orElse: () => Unit.mil,
  );
  set horizontalClickUnitValue(Unit v) => horizontalClickUnit = v.name;
}
