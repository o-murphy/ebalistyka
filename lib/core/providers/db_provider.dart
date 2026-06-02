import 'package:ebalistyka_db/ebalistyka_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the open ObjectBox [Store]. Only used when kStorageBackend == objectBox.
/// Must be overridden before [runApp] when using ObjectBox.
final dbProvider = Provider<Store>((ref) {
  throw UnimplementedError('dbProvider must be overridden with an open Store');
});

/// Set to [true] when the store was corrupted on startup and had to be reset.
final dbWasResetProvider = Provider<bool>((_) => false);

/// Repository for main app data (weapons, ammo, sights, profiles, owner).
/// Must be overridden before [runApp].
final appRepositoryProvider = Provider<IAppRepository>((ref) {
  throw UnimplementedError('appRepositoryProvider must be overridden');
});

/// Repository for all settings entities.
/// Must be overridden before [runApp].
final settingsRepositoryProvider = Provider<ISettingsRepository>((ref) {
  throw UnimplementedError('settingsRepositoryProvider must be overridden');
});

/// The singleton local [Owner] (token = "local").
/// Must be overridden before [runApp] — initialised in main() after repo setup.
final ownerProvider = Provider<Owner>((ref) {
  throw UnimplementedError('ownerProvider must be overridden');
});

/// Convenience provider — the local owner's int id.
final ownerIdProvider = Provider<int>((ref) => ref.watch(ownerProvider).id);
