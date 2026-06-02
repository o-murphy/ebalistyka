import 'dart:async';
import 'package:bclibc_ffi/unit.dart';
import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/core/extensions/weapon_extensions.dart';
import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod/riverpod.dart';

// ── AppState ──────────────────────────────────────────────────────────────────

class AppState {
  final List<Weapon> weapons;
  final List<Ammo> ammo;
  final List<Sight> sights;
  final List<Profile> profiles;
  final Profile? activeProfile;

  const AppState({
    required this.weapons,
    required this.ammo,
    required this.sights,
    required this.profiles,
    this.activeProfile,
  });

  factory AppState.empty() =>
      const AppState(weapons: [], ammo: [], sights: [], profiles: []);

  AppState copyWith({
    List<Weapon>? weapons,
    List<Ammo>? ammo,
    List<Sight>? sights,
    List<Profile>? profiles,
    Profile? activeProfile,
    bool clearActiveProfile = false,
  }) => AppState(
    weapons: weapons ?? this.weapons,
    ammo: ammo ?? this.ammo,
    sights: sights ?? this.sights,
    profiles: profiles ?? this.profiles,
    activeProfile: clearActiveProfile
        ? null
        : (activeProfile ?? this.activeProfile),
  );
}

// ── AppStateNotifier ──────────────────────────────────────────────────────────

class AppStateNotifier extends AsyncNotifier<AppState> {
  IAppRepository get _repo => ref.read(appRepositoryProvider);
  Owner get _owner => ref.read(ownerProvider);
  int get _ownerId => ref.read(ownerIdProvider);

  @override
  Future<AppState> build() async {
    final ownerId = _ownerId;

    void reload() {
      _load().then((s) => state = AsyncData(s));
    }

    final subs = [
      _repo.watchOwner(ownerId).listen((_) => reload()),
      _repo.watchWeapons(ownerId).listen((_) => reload()),
      _repo.watchAmmo(ownerId).listen((_) => reload()),
      _repo.watchSights(ownerId).listen((_) => reload()),
      _repo.watchProfiles(ownerId).listen((_) => reload()),
    ];
    ref.onDispose(() {
      for (final s in subs) {
        unawaited(s.cancel());
      }
    });

    return _load();
  }

  Future<AppState> _load() async {
    final ownerId = _ownerId;

    var weapons = await _repo.loadWeapons(ownerId);
    var ammo = await _repo.loadAmmo(ownerId);
    var sights = await _repo.loadSights(ownerId);
    var profiles = await _repo.loadProfiles(ownerId);

    if (await _repo.needsSeed(ownerId)) {
      debugPrint('AppStateNotifier: seeding initial data...');
      await _seed(ownerId);
      weapons = await _repo.loadWeapons(ownerId);
      ammo = await _repo.loadAmmo(ownerId);
      sights = await _repo.loadSights(ownerId);
      profiles = await _repo.loadProfiles(ownerId);
    }

    final activeId = await _repo.getActiveProfileId(ownerId);
    final activeProfile = activeId != 0
        ? profiles.where((p) => p.id == activeId).firstOrNull
        : (profiles.isNotEmpty ? profiles.first : null);

    debugPrint(
      'AppStateNotifier: ${weapons.length} weapons, ${ammo.length} ammo, '
      '${sights.length} sights, ${profiles.length} profiles',
    );

    return AppState(
      weapons: weapons,
      ammo: ammo,
      sights: sights,
      profiles: profiles,
      activeProfile: activeProfile,
    );
  }

  Future<void> _seed(int ownerId) async {
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
    final sightId = await _repo.saveSight(sight, ownerId);
    sight.id = sightId;

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
    final ammoId = await _repo.saveAmmo(ammo, ownerId);
    ammo.id = ammoId;

    final weapon = Weapon()
      ..name = 'Cadex Defence Kraken CDX-MC'
      ..vendor = 'Cadex'
      ..caliber = Distance.inch(0.338)
      ..caliberName = '338 Lapua Magnum'
      ..twist = Distance.inch(9.5)
      ..barrelLength = Distance.inch(26.0);
    final weaponId = await _repo.saveWeapon(weapon, ownerId);
    weapon.id = weaponId;

    final profile = Profile()
      ..name = weapon.name
      ..weapon.target = weapon
      ..sight.target = sight
      ..ammo.target = ammo;
    await _repo.saveProfile(profile, ownerId);
  }

  // ── Active profile ─────────────────────────────────────────────────────────

  Future<void> setActiveProfile(Profile profile) async {
    await _repo.setActiveProfileId(_ownerId, profile.id);
  }

  // ── Ammo CRUD ──────────────────────────────────────────────────────────────

  Future<void> saveAmmo(Ammo ammo) async {
    await _repo.saveAmmo(ammo, _ownerId);
  }

  Future<int> duplicateAmmo(int id, String newName) async {
    return _repo.duplicateAmmo(id, newName, _ownerId);
  }

  Future<void> deleteAmmo(int id) async {
    await _repo.deleteAmmo(id);
  }

  // ── Weapon CRUD ────────────────────────────────────────────────────────────

  Future<void> saveWeapon(Weapon weapon) async {
    await _repo.saveWeapon(weapon, _ownerId);
  }

  // ── Sight CRUD ─────────────────────────────────────────────────────────────

  Future<int> duplicateSight(int id, String newName) async {
    return _repo.duplicateSight(id, newName, _ownerId);
  }

  Future<void> saveSight(Sight sight) async {
    await _repo.saveSight(sight, _ownerId);
  }

  Future<void> deleteSight(int id) async {
    await _repo.deleteSight(id);
  }

  // ── Profile CRUD ───────────────────────────────────────────────────────────

  Future<void> setProfileAmmo(String profileId, int ammoId) async {
    final id = int.tryParse(profileId);
    if (id == null) return;
    await _repo.setProfileAmmo(id, ammoId);
  }

  Future<void> setProfileSight(String profileId, int sightId) async {
    final id = int.tryParse(profileId);
    if (id == null) return;
    await _repo.setProfileSight(id, sightId);
  }

  Future<int> createProfile(String name, Weapon weapon) async {
    return _repo.createProfile(name, weapon, _ownerId);
  }

  Future<int> duplicateProfile(int id, String newName) async {
    return _repo.duplicateProfile(id, newName, _ownerId);
  }

  Future<void> saveProfile(Profile profile) async {
    await _repo.saveProfile(profile, _ownerId);
  }

  Future<int> importProfile(ProfileExport export) async {
    return _repo.importProfile(export, _ownerId);
  }

  Future<int> importAmmo(AmmoExport export) async {
    return _repo.importAmmo(export, _ownerId);
  }

  Future<int> importSight(SightExport export) async {
    return _repo.importSight(export, _ownerId);
  }

  Future<void> deleteProfile(int id) async {
    final wasActive = state.value?.activeProfile?.id == id;
    await _repo.deleteProfile(id, _ownerId);
    if (wasActive) {
      await _repo.setActiveProfileId(_ownerId, 0);
    }
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

final appStateProvider = AsyncNotifierProvider<AppStateNotifier, AppState>(
  AppStateNotifier.new,
);
