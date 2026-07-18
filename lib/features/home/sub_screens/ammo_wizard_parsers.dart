List<({double vMps, double bc})>? decodeBcTable(
  List<double>? vMps,
  List<double>? bcs,
) {
  if (vMps == null || bcs == null || vMps.isEmpty) return null;
  return List.generate(vMps.length, (i) => (vMps: vMps[i], bc: bcs[i]));
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
