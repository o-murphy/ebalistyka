import 'dart:io';

import '../proto/profiles.pb.dart';
import '../proto/settings.pb.dart';
import 'file_msg_store.dart';
import 'msg_store.dart';
import 'profiles_file.dart';
import 'settings_file.dart';

/// Both `.ebcp` stores, already loaded — see docs/backlogs/
/// 8.PROTOBUF_STORAGE_MIGRATION.md's "On-Disk Layout" section for why
/// there are always exactly these two files, independently seeded/
/// persisted.
class OpenedEbcStores {
  const OpenedEbcStores({
    required this.settingsStore,
    required this.settings,
    required this.profilesStore,
    required this.profiles,
    required this.dataWasReset,
  });

  final MsgStore<SettingsData> settingsStore;
  final SettingsData settings;
  final MsgStore<ProfilesData> profilesStore;
  final List<Profile> profiles;

  /// `true` if either file existed on disk but failed to decode and had
  /// to be reseeded — each file tracked independently, so a corrupt
  /// `profiles.ebcp` is never blamed on `settings.ebcp` or vice versa.
  final bool dataWasReset;
}

/// Opens `settings.ebcp`/`profiles.ebcp` under [directory], seeding
/// whichever one is missing/corrupt via [seedSettings]/[seedProfiles].
/// The two files/messages are fully independent — see Core Design in
/// docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md — so this only bundles
/// "open both, the app's usual way" for the caller; it isn't a shared
/// envelope.
Future<OpenedEbcStores> openEbcDbStores(
  String directory, {
  required SettingsData Function() seedSettings,
  required List<Profile> Function() seedProfiles,
}) async {
  final settingsFile = File('$directory/settings.ebcp');
  final profilesFile = File('$directory/profiles.ebcp');
  final settingsStore = FileMsgStore<SettingsData>(
    settingsFile,
    encode: SettingsFile.encode,
    decode: SettingsFile.decode,
  );
  final profilesStore = FileMsgStore<ProfilesData>(
    profilesFile,
    encode: ProfilesFile.encode,
    decode: ProfilesFile.decode,
  );

  final hadSettingsFile = await settingsFile.exists();
  final hadProfilesFile = await profilesFile.exists();
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

  // Persist freshly-seeded data immediately — otherwise a user who closes
  // the app before touching anything would re-seed (a new random profile
  // uuid) on every subsequent launch, since load() never writes on its own.
  if (settingsWasSeeded) await settingsStore.save(settings);
  if (profilesWasSeeded) await profilesStore.save(profilesData);

  final dataWasReset =
      (hadSettingsFile && settingsWasSeeded) ||
      (hadProfilesFile && profilesWasSeeded);

  return OpenedEbcStores(
    settingsStore: settingsStore,
    settings: settings,
    profilesStore: profilesStore,
    profiles: profilesData.profiles,
    dataWasReset: dataWasReset,
  );
}
