import 'package:ebalistyka/core/collection/collection_cache.dart';
import 'package:ebalistyka/core/collection/collection_cache_io.dart'
    if (dart.library.js_interop) 'package:ebalistyka/core/collection/collection_cache_web.dart';
import 'package:ebalistyka/core/collection/collection_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';

/// The platform's collection cache (file on native, IndexedDB on web).
final collectionCacheProvider = Provider<CollectionCache>(
  (ref) => createCollectionCache(),
);

/// Loads the active collection: cached download if present, bundled asset otherwise.
/// Invalidate this provider after a successful collection update to reload.
final builtinCollectionProvider = FutureProvider<BuiltinCollection>((
  ref,
) async {
  try {
    final json = await ref.read(collectionCacheProvider).read();
    if (json != null) return CollectionParser.parse(json);
  } catch (e) {
    debugPrint('Failed to load cached collection, falling back to asset: $e');
  }
  final bundled = await rootBundle.loadString('assets/json/collection.json');
  return CollectionParser.parse(bundled);
});
