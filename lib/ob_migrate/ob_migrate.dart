import 'dart:io';

import 'migration_gate_screen.dart';

export 'migration_gate_screen.dart' show MigrationGate;

/// True if [appSupportDir] holds an old ObjectBox store (`data.mdb`) that
/// hasn't been migrated yet — the one thing `main.dart` needs to know to
/// decide whether to show [MigrationGate] before the real app. See
/// docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 5.
Future<bool> hasUnmigratedLegacyData(String appSupportDir) async {
  final dataFile = File('$appSupportDir/data.mdb');
  final marker = File('$appSupportDir/$migrationDoneMarkerName');
  return await dataFile.exists() && !await marker.exists();
}
