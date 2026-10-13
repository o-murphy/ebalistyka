import 'package:ebalistyka/core/session/tab_lock.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Covers the app with a "paused — opened in another window" screen while
/// [tabBlocked] is set. See `core/session/tab_lock.dart`.
///
/// [blocked] and [onUseHere] default to the real session state; tests inject
/// their own.
class TabBlockedGate extends StatelessWidget {
  const TabBlockedGate({
    required this.child,
    this.blocked,
    this.onUseHere = reloadApp,
    super.key,
  });

  final Widget child;
  final ValueListenable<bool>? blocked;
  final VoidCallback onUseHere;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: blocked ?? tabBlocked,
      child: child,
      builder: (context, isBlocked, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Keep the (stale) app alive underneath but unreachable.
            ExcludeFocus(
              excluding: isBlocked,
              child: IgnorePointer(ignoring: isBlocked, child: child),
            ),
            if (isBlocked) _BlockedScreen(onUseHere: onUseHere),
          ],
        );
      },
    );
  }
}

class _BlockedScreen extends StatelessWidget {
  const _BlockedScreen({required this.onUseHere});

  final VoidCallback onUseHere;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tab_unselected, size: 56, color: cs.primary),
                const SizedBox(height: 16),
                Text(
                  l10n.tabBlockedTitle,
                  style: tt.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tabBlockedMessage,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onUseHere,
                  child: Text(l10n.tabBlockedAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
