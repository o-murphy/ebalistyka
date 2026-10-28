import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/core/models/collection_item.dart';
import 'package:ebalistyka/core/providers/filter_providers.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_item_tile.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_picker_screen.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_sight_tile_body.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/filter_sheet.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/help_dialog.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SightCollectionScreen extends ConsumerWidget {
  const SightCollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(sightCollectionFilterProvider);

    return CollectionPickerScreen<Sight>(
      title: l10n.sightCollectionScreenTitle,
      helpId: HelpData.sightCollectionScreen,
      itemsOf: (collection) => collection.sights,
      isFilterActive: filter.isActive,
      matches: (s) =>
          (filter.vendors.isEmpty || filter.vendors.contains(s.vendor)) &&
          (filter.focalPlanes.isEmpty ||
              filter.focalPlanes.contains(s.focalPlane)),
      openFilter: (ctx, all) => showSightFilterSheet(ctx, allItems: all),
      tileFor: (sight) => CollectionItemTile(
        key: ValueKey(sight.name),
        body: CollectionSightTileBody(sight: sight),
        item: SightCollectionItem(ref: sight),
        searchText: [sight.name, sight.vendor].join(' '),
        onSelect: () => context.pop(sight.deepCopy()),
      ),
    );
  }
}
