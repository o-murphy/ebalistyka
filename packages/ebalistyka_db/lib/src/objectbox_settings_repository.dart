import 'package:ebalistyka_db/objectbox.g.dart';
import 'package:ebalistyka_db/src/entities.dart';
import 'package:ebalistyka_db/src/export/conditions_export.dart';
import 'package:ebalistyka_db/src/export/general_settings_export.dart';
import 'package:ebalistyka_db/src/export/reticle_settings_export.dart';
import 'package:ebalistyka_db/src/export/tables_settings_export.dart';
import 'package:ebalistyka_db/src/export/unit_settings_export.dart';
import 'package:ebalistyka_db/src/repository.dart';

class ObjectBoxSettingsRepository implements ISettingsRepository {
  final Store _store;
  ObjectBoxSettingsRepository(this._store);

  Owner? _cachedOwner(int ownerId) => _store.box<Owner>().get(ownerId);

  // ── GeneralSettings ───────────────────────────────────────────────────────────

  @override
  Future<GeneralSettings> loadOrCreateGeneralSettings(int ownerId) async {
    final existing = _store
        .box<GeneralSettings>()
        .query(GeneralSettings_.owner.equals(ownerId))
        .build()
        .findFirst();
    if (existing != null) return existing;
    final s = GeneralSettings()..owner.target = _cachedOwner(ownerId);
    _store.box<GeneralSettings>().put(s);
    return s;
  }

  @override
  Stream<void> watchGeneralSettings(int ownerId) => _store
      .box<GeneralSettings>()
      .query(GeneralSettings_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Future<void> saveGeneralSettings(GeneralSettings s, int ownerId) async {
    s.owner.target ??= _cachedOwner(ownerId);
    _store.box<GeneralSettings>().put(s);
  }

  @override
  Future<void> restoreGeneralSettings(
      GeneralSettingsExport export, int ownerId) async {
    final current = await loadOrCreateGeneralSettings(ownerId);
    final updated = export.toEntity()
      ..id = current.id
      ..owner.target = _cachedOwner(ownerId);
    _store.box<GeneralSettings>().put(updated);
  }

  // ── UnitSettings ──────────────────────────────────────────────────────────────

  @override
  Future<UnitSettings> loadOrCreateUnitSettings(int ownerId) async {
    final existing = _store
        .box<UnitSettings>()
        .query(UnitSettings_.owner.equals(ownerId))
        .build()
        .findFirst();
    if (existing != null) return existing;
    final s = UnitSettings()..owner.target = _cachedOwner(ownerId);
    _store.box<UnitSettings>().put(s);
    return s;
  }

  @override
  Stream<void> watchUnitSettings(int ownerId) => _store
      .box<UnitSettings>()
      .query(UnitSettings_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Future<void> saveUnitSettings(UnitSettings s, int ownerId) async {
    s.owner.target ??= _cachedOwner(ownerId);
    _store.box<UnitSettings>().put(s);
  }

  @override
  Future<void> restoreUnitSettings(UnitSettingsExport export, int ownerId) async {
    final current = await loadOrCreateUnitSettings(ownerId);
    final updated = export.toEntity()
      ..id = current.id
      ..owner.target = _cachedOwner(ownerId);
    _store.box<UnitSettings>().put(updated);
  }

  // ── TablesSettings ────────────────────────────────────────────────────────────

  @override
  Future<TablesSettings> loadOrCreateTablesSettings(int ownerId) async {
    final existing = _store
        .box<TablesSettings>()
        .query(TablesSettings_.owner.equals(ownerId))
        .build()
        .findFirst();
    if (existing != null) return existing;
    final s = TablesSettings()..owner.target = _cachedOwner(ownerId);
    _store.box<TablesSettings>().put(s);
    return s;
  }

  @override
  Stream<void> watchTablesSettings(int ownerId) => _store
      .box<TablesSettings>()
      .query(TablesSettings_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Future<void> saveTablesSettings(TablesSettings s, int ownerId) async {
    s.owner.target ??= _cachedOwner(ownerId);
    _store.box<TablesSettings>().put(s);
  }

  @override
  Future<void> restoreTablesSettings(
      TablesSettingsExport export, int ownerId) async {
    final current = await loadOrCreateTablesSettings(ownerId);
    final updated = export.toEntity()
      ..id = current.id
      ..owner.target = _cachedOwner(ownerId);
    _store.box<TablesSettings>().put(updated);
  }

  // ── ReticleSettings ───────────────────────────────────────────────────────────

  @override
  Future<ReticleSettings> loadOrCreateReticleSettings(int ownerId) async {
    final existing = _store
        .box<ReticleSettings>()
        .query(ReticleSettings_.owner.equals(ownerId))
        .build()
        .findFirst();
    if (existing != null) return existing;
    final s = ReticleSettings()..owner.target = _cachedOwner(ownerId);
    _store.box<ReticleSettings>().put(s);
    return s;
  }

  @override
  Stream<void> watchReticleSettings(int ownerId) => _store
      .box<ReticleSettings>()
      .query(ReticleSettings_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Future<void> saveReticleSettings(ReticleSettings s, int ownerId) async {
    s.owner.target ??= _cachedOwner(ownerId);
    _store.box<ReticleSettings>().put(s);
  }

  // ── ShootingConditions ────────────────────────────────────────────────────────

  @override
  Future<ShootingConditions> loadOrCreateShootingConditions(
      int ownerId) async {
    final existing = _store
        .box<ShootingConditions>()
        .query(ShootingConditions_.owner.equals(ownerId))
        .build()
        .findFirst();
    if (existing != null) return existing;
    final s = ShootingConditions()
      ..owner.target = _cachedOwner(ownerId)
      ..humidityFrac = 0.5
      ..distanceMeter = 450.0;
    _store.box<ShootingConditions>().put(s);
    return s;
  }

  @override
  Stream<void> watchShootingConditions(int ownerId) => _store
      .box<ShootingConditions>()
      .query(ShootingConditions_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Future<void> saveShootingConditions(
      ShootingConditions s, int ownerId) async {
    s.owner.target ??= _cachedOwner(ownerId);
    _store.box<ShootingConditions>().put(s);
  }

  @override
  Future<void> restoreShootingConditions(
      ConditionsExport export, int ownerId) async {
    final current = await loadOrCreateShootingConditions(ownerId);
    final updated = export.toEntity()
      ..id = current.id
      ..owner.target = _cachedOwner(ownerId);
    _store.box<ShootingConditions>().put(updated);
  }

  // ── ConvertorsState ───────────────────────────────────────────────────────────

  @override
  Future<ConvertorsState> loadOrCreateConvertorsState(int ownerId) async {
    final existing = _store
        .box<ConvertorsState>()
        .query(ConvertorsState_.owner.equals(ownerId))
        .build()
        .findFirst();
    if (existing != null) return existing;
    final s = ConvertorsState()..owner.target = _cachedOwner(ownerId);
    _store.box<ConvertorsState>().put(s);
    return s;
  }

  @override
  Stream<void> watchConvertorsState(int ownerId) => _store
      .box<ConvertorsState>()
      .query(ConvertorsState_.owner.equals(ownerId))
      .watch(triggerImmediately: false)
      .map((_) => null);

  @override
  Future<void> saveConvertorsState(ConvertorsState s, int ownerId) async {
    s.owner.target ??= _cachedOwner(ownerId);
    _store.box<ConvertorsState>().put(s);
  }
}
