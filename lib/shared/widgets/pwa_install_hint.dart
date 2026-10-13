import 'dart:async';

import 'package:ebalistyka/core/session/pwa_install.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _shownKey = 'pwa_install_hint_shown';

/// Offers to install the app as a PWA — once, as a dismissible snackbar, the
/// first time the browser makes the offer (see [pwaInstallAvailable] for when
/// that is). A permanent entry lives in Settings.
class PwaInstallHint extends StatefulWidget {
  const PwaInstallHint({required this.child, super.key});

  final Widget child;

  @override
  State<PwaInstallHint> createState() => _PwaInstallHintState();
}

class _PwaInstallHintState extends State<PwaInstallHint> {
  @override
  void initState() {
    super.initState();
    pwaInstallAvailable.addListener(_onChanged);
    _onChanged(); // the offer may already be pending
  }

  @override
  void dispose() {
    pwaInstallAvailable.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (pwaInstallAvailable.value) unawaited(_showOnce());
  }

  Future<void> _showOnce() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_shownKey) ?? false) return;
      await prefs.setBool(_shownKey, true);
    } catch (e) {
      debugPrint('PWA install hint: prefs unavailable: $e');
      return;
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.pwaInstallHint),
        duration: const Duration(seconds: 12),
        action: SnackBarAction(
          label: l10n.pwaInstallHintAction,
          onPressed: () => unawaited(promptPwaInstall()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
