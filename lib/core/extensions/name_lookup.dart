import 'package:bclibc/unit.dart';

/// The value of [values] called [name], or [fallback] when [name] is empty or
/// unknown — units and enums are stored as their names in the proto messages.
T enumByName<T extends Enum>(List<T> values, String name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

Unit unitNamed(String name, Unit fallback) =>
    enumByName(Unit.values, name, fallback);
