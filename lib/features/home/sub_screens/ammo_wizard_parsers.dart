import 'package:ebc_db/ebc_db.dart';

List<({double vMps, double bc})>? decodeBcTable(List<MultiBcPoint>? points) {
  if (points == null || points.isEmpty) return null;
  return points.map((p) => (vMps: p.vMps, bc: p.bc)).toList();
}

List<({double mach, double cd})>? decodeCustomDragTable(
  List<double>? mach,
  List<double>? cd,
) {
  if (mach == null || cd == null || mach.isEmpty) return null;
  return List.generate(mach.length, (i) => (mach: mach[i], cd: cd[i]));
}

List<({double tempC, double vMps})>? decodePowderSensTable(
  List<double>? tempC,
  List<double>? vMps,
) {
  if (tempC == null || vMps == null || tempC.isEmpty) return null;
  return List.generate(tempC.length, (i) => (tempC: tempC[i], vMps: vMps[i]));
}
