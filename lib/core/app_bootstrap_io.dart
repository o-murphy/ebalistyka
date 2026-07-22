import 'dart:io';

import 'package:dart_bclibc/ffi/bclibc_ffi.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../ob_migrate/ob_migrate.dart';

Future<void> initNativeLibrary() async {
  try {
    BcLibC.open();
  } catch (e) {
    stderr.writeln('Fatal: native library unavailable: $e');
    exit(1);
  }
}

class AppBootstrapResult {
  const AppBootstrapResult({required this.stores, required this.wrapRoot});
  final OpenedEbcStores stores;
  final Widget Function(Widget child) wrapRoot;
}

Future<AppBootstrapResult> bootstrapApp({
  required SettingsData Function() seedSettings,
  required List<Profile> Function() seedProfiles,
}) async {
  final appSupport = await getApplicationSupportDirectory();
  final stores = await openEbcDbStores(
    appSupport.path,
    seedSettings: seedSettings,
    seedProfiles: seedProfiles,
  );
  debugPrint('DB path: ${appSupport.path}');

  final showGate = await hasUnmigratedLegacyData(appSupport.path);
  return AppBootstrapResult(
    stores: stores,
    wrapRoot: (child) => showGate
        ? MigrationGate(objectboxDir: appSupport.path, child: child)
        : child,
  );
}
