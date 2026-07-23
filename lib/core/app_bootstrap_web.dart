// Web counterpart to app_bootstrap_io.dart's conditional import in
// main.dart. `dart_bclibc`'s FFI init (`BcLibC.open()`) has no web
// equivalent needed here — web uses the wasm engine instead, loaded lazily
// on first `AsyncCalculator` call (`ballistics_service_impl_web.dart`).
//
// Persistence: `path_provider`'s `getApplicationSupportDirectory()` has no
// web implementation (throws `UnsupportedError` at runtime), so `ebc_db`'s
// file-based stores can't be opened here. `IndexedDbMsgStore` (see
// docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md Phase 9) is the real
// persistence layer instead — same "md5+ebcpbuf" wire format `MsgStore`
// always used, just backed by a browser key/value store (IndexedDB)
// instead of a filesystem path. Replaces the earlier "seed into memory,
// never persist" spike shortcut.
//
// ignore_for_file: implementation_imports
// `IndexedDbMsgStore` isn't exported from `ebc_db.dart`'s main barrel (it
// imports `dart:js_interop`, unavailable on the VM target `dart test`/
// `flutter test` run on) — this deep import into `ebc_db`'s `lib/src` is
// deliberate, same reasoning `dart_bclibc_flutter`'s `async_calculator.dart`
// already uses for its own equivalent deep import: `ebc_db` and
// `ebalistyka` are versioned and developed together in this one repo.

import 'package:ebc_db/ebc_db.dart';
import 'package:ebc_db/src/persistence/indexed_db_msg_store.dart';
import 'package:flutter/widgets.dart';

Future<void> initNativeLibrary() async {}

class AppBootstrapResult {
  const AppBootstrapResult({required this.stores, required this.wrapRoot});
  final OpenedEbcStores stores;
  final Widget Function(Widget child) wrapRoot;
}

Future<AppBootstrapResult> bootstrapApp({
  required SettingsData Function() seedSettings,
  required List<Profile> Function() seedProfiles,
}) async {
  final settingsStore = IndexedDbMsgStore<SettingsData>(
    'settings',
    encode: SettingsFile.encode,
    decode: SettingsFile.decode,
  );
  final profilesStore = IndexedDbMsgStore<ProfilesData>(
    'profiles',
    encode: ProfilesFile.encode,
    decode: ProfilesFile.decode,
  );

  final hadSettings = await settingsStore.readBytes() != null;
  final hadProfiles = await profilesStore.readBytes() != null;
  var settingsWasSeeded = false;
  var profilesWasSeeded = false;

  final settings = await settingsStore.load(
    orElseSeed: () {
      settingsWasSeeded = true;
      return seedSettings();
    },
  );
  final profilesData = await profilesStore.load(
    orElseSeed: () {
      profilesWasSeeded = true;
      return ProfilesData(profiles: seedProfiles());
    },
  );

  // Same reasoning as the io bootstrap (ebc_stores.dart): persist
  // freshly-seeded data immediately, otherwise a user who reloads the tab
  // before touching anything re-seeds (a new random profile uuid) on every
  // subsequent load, since load() never writes on its own.
  if (settingsWasSeeded) await settingsStore.save(settings);
  if (profilesWasSeeded) await profilesStore.save(profilesData);

  final dataWasReset =
      (hadSettings && settingsWasSeeded) ||
      (hadProfiles && profilesWasSeeded);

  final stores = OpenedEbcStores(
    settingsStore: settingsStore,
    settings: settings,
    profilesStore: profilesStore,
    profiles: profilesData.profiles,
    dataWasReset: dataWasReset,
  );

  // No legacy ObjectBox data can exist in a browser — the migration gate
  // never applies on web.
  return AppBootstrapResult(stores: stores, wrapRoot: (child) => child);
}
