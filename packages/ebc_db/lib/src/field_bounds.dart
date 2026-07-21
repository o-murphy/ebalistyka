/// Numeric bounds for one persisted field role.
///
/// Carries no unit information — a [FieldBounds] only knows the valid
/// numeric range for a wire field, not what physical unit that range is
/// expressed in. The wire unit for each role is documented in the
/// corresponding schema field's `description` and is the app layer's
/// responsibility to know (see `lib/core/models/field_constraints.dart`'s
/// `FC`, which pairs these bounds with a `dart_bclibc.Unit`).
class FieldBounds {
  const FieldBounds({required this.minRaw, required this.maxRaw});

  final double minRaw;
  final double maxRaw;

  double clamp(double raw) => raw.clamp(minRaw, maxRaw);
}
