import 'dart:io';

import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/widgets.dart';

/// Web placeholder for app_bootstrap_io.dart's conditional import in
/// main.dart. Two things the native path relies on have no web story yet
/// (see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 9):
///
/// - `dart_bclibc`'s FFI init (`BcLibC.open()`) — web uses the wasm engine
///   instead, loaded lazily on first `AsyncCalculator` call
///   (`ballistics_service_impl_web.dart`), so there's nothing to do here.
/// - `path_provider`'s `getApplicationSupportDirectory()` — no web
///   implementation exists at all (throws `UnsupportedError` at runtime),
///   so `ebc_db`'s on-disk stores can't be opened. State is seeded straight
///   into memory instead; `MsgStore.load()`/`.save()` are never called, so
///   nothing here reaches the unavailable filesystem. The two `File`
///   instances below are throwaway — `MsgStore`'s constructor doesn't touch
///   disk, only `load()`/`save()` do — but writes triggered later by actual
///   user edits (`ProfilesNotifier.update()` etc.) will still throw; that's
///   an open gap this spike doesn't close, not something masked here.
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
  final settings = seedSettings();
  final profiles = seedProfiles();

  final stores = OpenedEbcStores(
    settingsStore: MsgStore<SettingsData>(
      File('settings.ebcp'),
      encode: SettingsFile.encode,
      decode: SettingsFile.decode,
    ),
    settings: settings,
    profilesStore: MsgStore<ProfilesData>(
      File('profiles.ebcp'),
      encode: ProfilesFile.encode,
      decode: ProfilesFile.decode,
    ),
    profiles: profiles,
    dataWasReset: false,
  );

  // No legacy ObjectBox data can exist in a browser — the migration gate
  // never applies on web.
  return AppBootstrapResult(stores: stores, wrapRoot: (child) => child);
}
