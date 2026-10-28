import 'package:ebalistyka/core/models/collection_item.dart';
import 'package:ebalistyka/core/providers/filter_providers.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_ammo_tile_body.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_item_tile.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_picker_screen.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/filter_sheet.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/help_dialog.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AmmoCollectionScreen extends ConsumerWidget {
  const AmmoCollectionScreen({
    required this.filterBullet,
    this.caliberInch,
    super.key,
  });

  final bool filterBullet;

  /// When provided, only ammo matching this caliber is shown.
  final double? caliberInch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final defaultCaliberInch = caliberInch != null && caliberInch! > 0
        ? caliberInch
        : null;
    final filter = ref.watch(ammoCollectionFilterProvider(defaultCaliberInch));

    return CollectionPickerScreen<Ammo>(
      title: filterBullet
          ? l10n.bulletCollectionScreenTitle
          : l10n.cartridgeCollectionScreenTitle,
      helpId: HelpData.ammoCollectionScreen,
      itemsOf: (collection) =>
          filterBullet ? collection.bullets : collection.cartridges,
      isFilterActive: filter.isActive,
      matches: (a) =>
          (filter.calibers.isEmpty ||
              filter.calibers.contains(a.caliberInch)) &&
          (filter.vendors.isEmpty || filter.vendors.contains(a.vendor)) &&
          (filter.minWeightGrain == null ||
              a.weightGrain >= filter.minWeightGrain!) &&
          (filter.maxWeightGrain == null ||
              a.weightGrain <= filter.maxWeightGrain!),
      openFilter: (ctx, all) => showAmmoCollectionFilterSheet(
        ctx,
        allItems: all,
        defaultCaliberInch: defaultCaliberInch,
      ),
      tileFor: (ammo) => CollectionItemTile(
        key: ValueKey(ammo.name),
        body: CollectionAmmoTileBody(ammo: ammo),
        item: CartridgeCollectionItem(ref: ammo),
        searchText: [ammo.name, ammo.vendor, ammo.projectileName].join(' '),
        onSelect: () => context.pop<Ammo>(ammo.deepCopy()),
      ),
    );
  }
}
