import 'package:ebalistyka/core/models/collection_item.dart';
import 'package:ebalistyka/core/providers/filter_providers.dart';
import 'package:ebalistyka/features/home/sub_screens/weapon_chosen_callback.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_item_tile.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_picker_screen.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_weapon_tile_body.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/filter_sheet.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/help_dialog.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WeaponCollectionScreen extends ConsumerWidget {
  const WeaponCollectionScreen({this.onChosen, super.key});

  /// Set when the collection starts a new profile: runs after a weapon is
  /// picked and can keep the screen open (see [WeaponChosenCallback]).
  final WeaponChosenCallback? onChosen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(weaponCollectionFilterProvider(null));

    return CollectionPickerScreen<Weapon>(
      title: l10n.weaponCollectionScreenTitle,
      helpId: HelpData.weaponCollectionScreen,
      itemsOf: (collection) => collection.weapons,
      isFilterActive: filter.isActive,
      matches: (w) =>
          filter.vendors.isEmpty || filter.vendors.contains(w.vendor),
      openFilter: (ctx, all) => showWeaponFilterSheet(ctx, allItems: all),
      tileFor: (weapon) => CollectionItemTile(
        key: ValueKey(weapon.name),
        body: CollectionWeaponTileBody(weapon: weapon),
        item: WeaponCollectionItem(ref: weapon),
        searchText: [weapon.name, weapon.vendor].join(' '),
        onSelect: () async {
          final copy = weapon.deepCopy();
          if (onChosen != null && !await onChosen!(context, copy)) return;
          if (context.mounted) context.pop<Weapon>(copy);
        },
      ),
    );
  }
}
