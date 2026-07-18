import 'package:uuid/uuid.dart';

import 'proto/profiles.pb.dart';

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
