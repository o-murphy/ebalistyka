import 'package:ebalistyka/core/extensions/weapon_extensions.dart';
import 'package:ebalistyka/core/providers/formatter_provider.dart';
import 'package:ebalistyka/shared/constants/null_string.dart';
import 'package:ebalistyka/shared/icons_definitions.dart';
import 'package:ebalistyka/shared/widgets/weapon_svg_view.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileListTileBody extends ConsumerWidget {
  const ProfileListTileBody({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(unitFormatterProvider);
    final weapon = profile.weapon;
    final ammo = profile.ammo;
    final sight = profile.sight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(child: WeaponSvgView(imageId: weapon.image)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InfoRow(
                      icon: IconDef.weapon,
                      value: weapon.name.isNotEmpty ? weapon.name : nullStr,
                    ),
                    const SizedBox(height: 4),
                    _InfoRow(
                      icon: IconDef.caliber,
                      value: formatter.diameter(weapon.caliber),
                    ),
                    const SizedBox(height: 4),
                    _InfoRow(
                      icon: IconDef.ammo,
                      value: ammo.name.isNotEmpty ? ammo.name : nullStr,
                    ),
                    const SizedBox(height: 4),
                    _InfoRow(
                      icon: IconDef.sight,
                      value: sight.name.isNotEmpty ? sight.name : nullStr,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 16, child: Icon(icon, size: 14)),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
