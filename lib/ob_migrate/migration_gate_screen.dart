import 'dart:async';
import 'dart:io';

import 'package:ebalistyka/core/providers/db_provider.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'legacy_migrator.dart';
import 'orphaned_export.dart';

/// Marker file (inside the same directory as `data.mdb`) written once a
/// migration actually succeeds — read by [hasUnmigratedLegacyData]
/// (`ob_migrate.dart`) so a completed migration doesn't re-prompt on every
/// subsequent launch just because `data.mdb` is still on disk (it's never
/// deleted, per docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 5).
/// Declining does NOT write this — the gate reprompts every launch until
/// the user migrates or manually removes `data.mdb`.
const migrationDoneMarkerName = '.ob_migration_done';

enum _Stage { confirm, migrating, orphaned, error }

/// Shown before [child] (the real app) when a not-yet-migrated legacy
/// ObjectBox store is detected. Resolves to [child] once the user declines,
/// migration succeeds (with any orphaned-data warning acknowledged), or the
/// user gives up after a failure.
class MigrationGate extends ConsumerStatefulWidget {
  const MigrationGate({
    required this.objectboxDir,
    required this.child,
    super.key,
  });

  final String objectboxDir;
  final Widget child;

  @override
  ConsumerState<MigrationGate> createState() => _MigrationGateState();
}

class _MigrationGateState extends ConsumerState<MigrationGate> {
  _Stage _stage = _Stage.confirm;
  bool _resolved = false;
  bool _confirmDialogScheduled = false;
  LegacyMigrationResult? _result;
  String? _error;

  // [context] here must be a BuildContext *below* the MaterialApp built in
  // build() below (so AppLocalizations.of/showDialog can find a
  // Localizations/Navigator ancestor) — never `this.context`/`State.context`,
  // which sits *above* that MaterialApp. Callers pass the Builder-scoped
  // context from _buildBody's call site.
  Future<void> _confirm(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.legacyMigrationConfirmTitle,
      content: l10n.legacyMigrationConfirmContent,
      confirmLabel: l10n.legacyMigrationConfirmAction,
      cancelLabel: l10n.legacyMigrationDeclineAction,
    );
    if (!context.mounted) return;
    if (!confirmed) {
      setState(() => _resolved = true);
      return;
    }
    await _migrate(context);
  }

  Future<void> _migrate(BuildContext context) async {
    setState(() {
      _stage = _Stage.migrating;
      _error = null;
    });
    try {
      final result = await migrateLegacyData(widget.objectboxDir);
      if (!mounted) return;

      ref.read(profilesProvider.notifier).update((_) => result.profiles);
      ref.read(settingsDataProvider.notifier).update((_) => result.settings);
      await File(
        '${widget.objectboxDir}/$migrationDoneMarkerName',
      ).writeAsBytes(const []);

      final hasOrphans =
          result.orphanedWeapons.isNotEmpty ||
          result.orphanedAmmo.isNotEmpty ||
          result.orphanedSights.isNotEmpty;
      if (!hasOrphans) {
        setState(() => _resolved = true);
        return;
      }
      setState(() {
        _result = result;
        _stage = _Stage.orphaned;
      });
    } catch (e) {
      debugPrint('Legacy migration failed: $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _stage = _Stage.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_resolved) return widget.child;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              // Builder gives a context that's a descendant of the
              // MaterialApp/Localizations above — `context` from this
              // outer build() is not (it's the gate's own element, which
              // sits above the MaterialApp it returns).
              child: Builder(
                builder: (innerContext) {
                  if (_stage == _Stage.confirm && !_confirmDialogScheduled) {
                    _confirmDialogScheduled = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) unawaited(_confirm(innerContext));
                    });
                  }
                  return _buildBody(innerContext);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_stage) {
      case _Stage.confirm:
        return const SizedBox.shrink(); // confirm dialog handles this stage
      case _Stage.migrating:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.legacyMigrationInProgress),
          ],
        );
      case _Stage.orphaned:
        final result = _result!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.legacyOrphanedDataTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.legacyOrphanedDataContent(
                result.orphanedWeapons.length,
                result.orphanedAmmo.length,
                result.orphanedSights.length,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () async {
                try {
                  await shareOrphanedDataJson(
                    weapons: result.orphanedWeapons,
                    ammo: result.orphanedAmmo,
                    sights: result.orphanedSights,
                  );
                } catch (e) {
                  debugPrint('Orphaned-data export failed: $e');
                }
              },
              child: Text(l10n.legacyExportOrphanedDataAction),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => setState(() => _resolved = true),
              child: Text(l10n.legacyContinueAction),
            ),
          ],
        );
      case _Stage.error:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.legacyMigrationFailedTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(_error ?? '', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _migrate(context),
              child: Text(l10n.legacyMigrationRetryAction),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _resolved = true),
              child: Text(l10n.legacyMigrationDeclineAction),
            ),
          ],
        );
    }
  }
}
