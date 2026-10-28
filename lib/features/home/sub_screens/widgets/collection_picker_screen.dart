import 'dart:async';

import 'package:ebalistyka/core/collection/collection_parser.dart';
import 'package:ebalistyka/core/providers/builtin_collection_provider.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_body.dart';
import 'package:ebalistyka/features/home/sub_screens/widgets/collection_item_tile.dart';
import 'package:ebalistyka/shared/icons_definitions.dart';
import 'package:ebalistyka/shared/widgets/base_screen.dart';
import 'package:ebalistyka/shared/widgets/error_display.dart';
import 'package:ebalistyka/shared/widgets/help_dialog.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared frame of the weapon / sight / ammo collection screens: app bar with
/// the filter button (badge while a filter is active) and help, loading and
/// error states, and the filtered, searchable list of tiles. The screens
/// supply what differs — the items, the filter and the tile.
class CollectionPickerScreen<T> extends ConsumerWidget {
  const CollectionPickerScreen({
    required this.title,
    required this.helpId,
    required this.itemsOf,
    required this.isFilterActive,
    required this.matches,
    required this.openFilter,
    required this.tileFor,
    super.key,
  });

  final String title;
  final String helpId;

  /// The list of [T] this screen browses, taken from the loaded collection.
  final List<T> Function(BuiltinCollection collection) itemsOf;

  final bool isFilterActive;

  /// Whether [T] passes the current filter.
  final bool Function(T item) matches;

  /// Opens the filter sheet over all items (not only the matching ones).
  final Future<void> Function(BuildContext context, List<T> all) openFilter;

  final CollectionItemTile Function(T item) tileFor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(builtinCollectionProvider);

    return BaseScreen(
      title: title,
      isSubscreen: true,
      actions: [
        Builder(
          builder: (ctx) => IconButton(
            onPressed: () {
              final collection = collectionAsync.value;
              final all = collection == null ? <T>[] : itemsOf(collection);
              unawaited(openFilter(ctx, all));
            },
            icon: Badge(
              isLabelVisible: isFilterActive,
              child: const Icon(IconDef.filter),
            ),
          ),
        ),
        HelpAction(helpId),
      ],
      body: collectionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(error: error),
        data: (collection) => BaseCollectionBody(
          tiles: itemsOf(collection).where(matches).map(tileFor).toList(),
        ),
      ),
    );
  }
}
