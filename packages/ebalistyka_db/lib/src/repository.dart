import 'package:ebalistyka_db/src/entities.dart';
import 'package:ebalistyka_db/src/export/ammo_export.dart';
import 'package:ebalistyka_db/src/export/profile_export.dart';
import 'package:ebalistyka_db/src/export/sight_export.dart';
import 'package:ebalistyka_db/src/export/conditions_export.dart';
import 'package:ebalistyka_db/src/export/general_settings_export.dart';
import 'package:ebalistyka_db/src/export/unit_settings_export.dart';
import 'package:ebalistyka_db/src/export/tables_settings_export.dart';

abstract interface class IAppRepository {
  Future<Owner> ensureOwner(String token);

  Stream<void> watchOwner(int ownerId);
  Stream<void> watchWeapons(int ownerId);
  Stream<void> watchAmmo(int ownerId);
  Stream<void> watchSights(int ownerId);
  Stream<void> watchProfiles(int ownerId);

  Future<List<Weapon>> loadWeapons(int ownerId);
  Future<List<Ammo>> loadAmmo(int ownerId);
  Future<List<Sight>> loadSights(int ownerId);
  Future<List<Profile>> loadProfiles(int ownerId);

  Future<int> getActiveProfileId(int ownerId);
  Future<void> setActiveProfileId(int ownerId, int profileId);

  Future<bool> needsSeed(int ownerId);

  // Ammo
  Future<int> saveAmmo(Ammo ammo, int ownerId);
  Future<int> duplicateAmmo(int id, String newName, int ownerId);
  Future<void> deleteAmmo(int id);
  Future<int> importAmmo(AmmoExport export, int ownerId);
  Future<Ammo?> getAmmo(int id);

  // Weapon
  Future<int> saveWeapon(Weapon weapon, int ownerId);
  Future<Weapon?> getWeapon(int id);

  // Sight
  Future<int> saveSight(Sight sight, int ownerId);
  Future<int> duplicateSight(int id, String newName, int ownerId);
  Future<void> deleteSight(int id);
  Future<int> importSight(SightExport export, int ownerId);

  // Profile
  Future<void> setProfileAmmo(int profileId, int ammoId);
  Future<void> setProfileSight(int profileId, int sightId);
  Future<int> saveProfile(Profile profile, int ownerId);
  Future<int> createProfile(String name, Weapon weapon, int ownerId);
  Future<int> duplicateProfile(int id, String newName, int ownerId);
  Future<int> importProfile(ProfileExport export, int ownerId);
  Future<void> deleteProfile(int id, int ownerId);
  Future<Profile?> getProfile(int id);
}

abstract interface class ISettingsRepository {
  Future<GeneralSettings> loadOrCreateGeneralSettings(int ownerId);
  Stream<void> watchGeneralSettings(int ownerId);
  Future<void> saveGeneralSettings(GeneralSettings s, int ownerId);
  Future<void> restoreGeneralSettings(GeneralSettingsExport export, int ownerId);

  Future<UnitSettings> loadOrCreateUnitSettings(int ownerId);
  Stream<void> watchUnitSettings(int ownerId);
  Future<void> saveUnitSettings(UnitSettings s, int ownerId);
  Future<void> restoreUnitSettings(UnitSettingsExport export, int ownerId);

  Future<TablesSettings> loadOrCreateTablesSettings(int ownerId);
  Stream<void> watchTablesSettings(int ownerId);
  Future<void> saveTablesSettings(TablesSettings s, int ownerId);
  Future<void> restoreTablesSettings(TablesSettingsExport export, int ownerId);

  Future<ReticleSettings> loadOrCreateReticleSettings(int ownerId);
  Stream<void> watchReticleSettings(int ownerId);
  Future<void> saveReticleSettings(ReticleSettings s, int ownerId);

  Future<ShootingConditions> loadOrCreateShootingConditions(int ownerId);
  Stream<void> watchShootingConditions(int ownerId);
  Future<void> saveShootingConditions(ShootingConditions s, int ownerId);
  Future<void> restoreShootingConditions(ConditionsExport export, int ownerId);

  Future<ConvertorsState> loadOrCreateConvertorsState(int ownerId);
  Stream<void> watchConvertorsState(int ownerId);
  Future<void> saveConvertorsState(ConvertorsState s, int ownerId);
}
