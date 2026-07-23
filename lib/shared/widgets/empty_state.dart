import 'package:ebalistyka/core/extensions/ammo_extensions.dart';
import 'package:ebalistyka/core/extensions/profile_extensions.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/icons_definitions.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';

/// Which specific piece of [profile] is missing/incomplete, in the priority
/// order the app asks the user to fill things in (weapon always exists
/// first, then ammo, then sight — see `selectAmmoSightHint`). Only call
/// this when `!profile.isReadyForCalculation` — it doesn't itself check
/// readiness, just explains why it's false.
EmptyStateType missingProfileDataType(Profile profile) {
  if (!profile.isWeaponSelected) return EmptyStateType.incompleteWeapon;
  if (!profile.ammo.isReadyForCalculation) {
    return EmptyStateType.incompleteAmmo;
  }
  return EmptyStateType.noSight;
}

enum EmptyStateType {
  noProfile,
  noAmmo,
  noSight,
  incompleteAmmo,
  incompleteWeapon,
  error,
  noData,
}

extension EmptyStateTypeProps on EmptyStateType {
  IconData get icon => switch (this) {
    EmptyStateType.noProfile => Icons.military_tech_outlined,
    EmptyStateType.noAmmo => IconDef.ammo,
    EmptyStateType.noSight => IconDef.sight,
    EmptyStateType.incompleteAmmo => IconDef.ammo,
    EmptyStateType.incompleteWeapon => IconDef.weapon,
    EmptyStateType.error => Icons.error_outline,
    EmptyStateType.noData => Icons.inbox_outlined,
  };

  String defaultMessage(AppLocalizations l10n) => switch (this) {
    EmptyStateType.noProfile => l10n.emptyStateNoProfile,
    EmptyStateType.noAmmo => l10n.emptyStateNoAmmo,
    EmptyStateType.noSight => l10n.emptyStateNoSight,
    EmptyStateType.incompleteAmmo => l10n.emptyStateIncompleteAmmo,
    EmptyStateType.incompleteWeapon => l10n.emptyStateIncompleteWeapon,
    EmptyStateType.error => l10n.emptyStateError,
    EmptyStateType.noData => l10n.emptyStateNoData,
  };
}

class EmptyStatePlaceholder extends StatelessWidget {
  final EmptyStateType type;
  final String? message;

  const EmptyStatePlaceholder({
    super.key,
    this.type = EmptyStateType.noData,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (cs, tt) = (theme.colorScheme, theme.textTheme);
    final color = type == EmptyStateType.error ? cs.error : cs.outline;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 40, color: color.withAlpha(127)),
          const SizedBox(height: 12),
          Text(
            message ?? type.defaultMessage(l10n),
            style: tt.bodyMedium?.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
