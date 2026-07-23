import 'package:ebc_db/ebc_db.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// ── AppState ──────────────────────────────────────────────────────────────────

class AppState {
  final List<Profile> profiles;

  const AppState({required this.profiles});

  factory AppState.empty() => const AppState(profiles: []);

  Profile? get activeProfile => activeProfileOf(profiles);
  List<Weapon> get weapons => profiles.map((p) => p.weapon).toList();
  List<Ammo> get ammo => profiles.map((p) => p.ammo).toList();
  List<Sight> get sights => profiles.map((p) => p.sight).toList();
}

// ── AppStateNotifier ──────────────────────────────────────────────────────────

class AppStateNotifier extends AsyncNotifier<AppState> {
  @override
  AppState build() {
    final profiles = ref.watch(profilesProvider);
    debugPrint('AppStateNotifier: ${profiles.length} profiles');
    return AppState(profiles: profiles);
  }

  void _updateProfiles(
    List<Profile> Function(List<Profile> current) mutate,
  ) {
    ref.read(profilesProvider.notifier).update(mutate);
  }

  Profile? _find(String uuid) =>
      state.value?.profiles.where((p) => p.uuid == uuid).firstOrNull;

  // ── Active profile ────────────────────────────────────────────────────────────

  Future<void> setActiveProfile(String uuid) async {
    _updateProfiles((profiles) => setActiveProfileOf(profiles, uuid));
  }

  // ── Profile field replacement ────────────────────────────────────────────────

  Future<void> setProfileWeapon(String uuid, Weapon value) async {
    _updateProfiles(
      (profiles) => [
        for (final p in profiles)
          if (p.uuid == uuid) (p.deepCopy()..weapon = value) else p,
      ],
    );
  }

  Future<void> setProfileAmmo(String uuid, Ammo value) async {
    _updateProfiles(
      (profiles) => [
        for (final p in profiles)
          if (p.uuid == uuid) (p.deepCopy()..ammo = value) else p,
      ],
    );
  }

  Future<void> setProfileSight(String uuid, Sight value) async {
    _updateProfiles(
      (profiles) => [
        for (final p in profiles)
          if (p.uuid == uuid) (p.deepCopy()..sight = value) else p,
      ],
    );
  }

  // ── Profile CRUD ──────────────────────────────────────────────────────────────

  Future<String> createProfile(String name, Weapon weapon) async {
    final profile = Profile()
      ..uuid = _uuid.v4()
      ..name = name
      ..weapon = weapon
      ..ammo = Ammo()
      ..sight = Sight();
    _updateProfiles((profiles) => [...profiles, profile]);
    return profile.uuid;
  }

  Future<String?> duplicateProfile(String uuid, String newName) async {
    final original = _find(uuid);
    if (original == null) return null;

    final copy = copyWithFreshUuid(original)..name = newName;
    _updateProfiles((profiles) => [...profiles, copy]);
    return copy.uuid;
  }

  Future<void> renameProfile(String uuid, String name) async {
    _updateProfiles(
      (profiles) => [
        for (final p in profiles)
          if (p.uuid == uuid) (p.deepCopy()..name = name) else p,
      ],
    );
  }

  Future<void> deleteProfile(String uuid) async {
    _updateProfiles(
      (profiles) => profiles.where((p) => p.uuid != uuid).toList(),
    );
    // profilesProvider notifying is enough — activeProfileProvider re-derives
    // from whatever is now at index 0, no separate "was active" bookkeeping.
  }

  // ── Import ────────────────────────────────────────────────────────────────────

  /// Adds [imported] as a new profile. Always mints a fresh `uuid` — an
  /// incoming profile's own `uuid` (if it has one at all) is never trusted,
  /// same invariant `duplicateProfile`/export/import all share (see
  /// docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 3.5 Sketch).
  Future<String> importProfile(Profile imported) async {
    final profile = copyWithFreshUuid(imported);
    _updateProfiles((profiles) => [...profiles, profile]);
    return profile.uuid;
  }

  /// Adds every profile in [imported] as new profiles, each with a fresh
  /// `uuid`, in **one** state update/disk write — not a loop of
  /// [importProfile] calls. A loop fires one overlapping, unawaited
  /// `MsgStore.save()` per iteration (see `ProfilesNotifier.update()`),
  /// which used to race on `profiles.ebcp.tmp`; batching sidesteps that and
  /// is the only write for the whole import regardless of profile count.
  Future<void> importProfiles(List<Profile> imported) async {
    final fresh = imported.map(copyWithFreshUuid).toList();
    _updateProfiles((profiles) => [...profiles, ...fresh]);
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

final appStateProvider = AsyncNotifierProvider<AppStateNotifier, AppState>(
  AppStateNotifier.new,
);
