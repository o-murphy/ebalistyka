import 'package:ebc_db/ebc_db.dart';

List<({double vMps, double bc})>? decodeBcTable(List<MultiBcPoint>? points) {
  if (points == null || points.isEmpty) return null;
  return points.map((p) => (vMps: p.vMps, bc: p.bc)).toList();
}

List<({double mach, double cd})>? decodeCustomDragTable(
  List<CustomDragPoint>? points,
) {
  if (points == null || points.isEmpty) return null;
  return points.map((p) => (mach: p.mach, cd: p.cd)).toList();
}

List<({double tempC, double vMps})>? decodePowderSensTable(
  List<PowderSensitivityPoint>? points,
) {
  if (points == null || points.isEmpty) return null;
  return points.map((p) => (tempC: p.tc, vMps: p.vMps)).toList();
}
