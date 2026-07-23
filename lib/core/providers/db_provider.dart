import 'dart:async';

import 'package:ebc_db/ebc_db.dart';
import 'package:riverpod/riverpod.dart';

/// Holds the [MsgStore] for `settings.ebcp`.
///
/// Must be overridden before [runApp]:
/// ```dart
/// runApp(ProviderScope(
///   overrides: [settingsStoreProvider.overrideWithValue(store)],
///   child: MyApp(),
/// ));
/// ```
final settingsStoreProvider = Provider<MsgStore<SettingsData>>((ref) {
  throw UnimplementedError(
    'settingsStoreProvider must be overridden with an open MsgStore',
  );
});

/// Holds the [MsgStore] for `profiles.ebcp`.
final profilesStoreProvider = Provider<MsgStore<ProfilesData>>((ref) {
  throw UnimplementedError(
    'profilesStoreProvider must be overridden with an open MsgStore',
  );
});

/// Set to `true` when either `settings.ebcp` or `profiles.ebcp` existed on
/// disk but failed to decode and had to be reseeded.
final dataWasResetProvider = Provider<bool>((_) => false);

class SettingsDataNotifier extends Notifier<SettingsData> {
  SettingsDataNotifier(this._initial);
  final SettingsData _initial;

  @override
  SettingsData build() => sanitizeSettingsData(_initial);

  SettingsData update(SettingsData Function(SettingsData current) mutate) {
    // sanitizeSettingsData is the one gate every write goes through — see
    // docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7 ("no
    // centralized reject invalid writes gate"). Callers no longer need to
    // clamp their own field before calling update().
    final next = sanitizeSettingsData(mutate(state));
    state = next;
    unawaited(ref.read(settingsStoreProvider).save(next));
    return next;
  }
}

class ProfilesNotifier extends Notifier<List<Profile>> {
  ProfilesNotifier(this._initial);
  final List<Profile> _initial;

  @override
  List<Profile> build() => _initial.map(sanitizeProfile).toList();

  List<Profile> update(List<Profile> Function(List<Profile> current) mutate) {
    // sanitizeProfile is the one gate every write goes through — see
    // docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7 ("no
    // centralized reject invalid writes gate"). Callers no longer need to
    // clamp their own field before calling update().
    final next = mutate(state).map(sanitizeProfile).toList();
    state = next;
    unawaited(
      ref
          .read(profilesStoreProvider)
          .save(ProfilesData(profiles: next)),
    );
    return next;
  }
}

/// Must be overridden before [runApp] with the already-loaded [SettingsData].
final settingsDataProvider =
    NotifierProvider<SettingsDataNotifier, SettingsData>(() {
      throw UnimplementedError(
        'settingsDataProvider must be overridden with an already-loaded SettingsData',
      );
    });

/// Must be overridden before [runApp] with the already-loaded profile list.
final profilesProvider = NotifierProvider<ProfilesNotifier, List<Profile>>(() {
  throw UnimplementedError(
    'profilesProvider must be overridden with an already-loaded profile list',
  );
});

/// `profiles[0]` — see `packages/ebc_db`'s `activeProfileOf`.
final activeProfileProvider = Provider<Profile?>(
  (ref) => activeProfileOf(ref.watch(profilesProvider)),
);
