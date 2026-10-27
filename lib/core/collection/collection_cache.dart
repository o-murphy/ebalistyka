/// Persistent cache of the last downloaded `collection.json` (a multi-MB blob
/// — see `update_checker.dart`'s `checkForCollectionUpdate`). Native keeps it
/// as a file in the app-support directory; web keeps it in IndexedDB, the
/// same store `ebc_db` already uses for profiles/settings (`localStorage`
/// is too small and synchronous for this size).
///
/// The built-in asset is the fallback when the cache is empty — see
/// `builtinCollectionProvider`.
abstract interface class CollectionCache {
  /// The cached JSON, or `null` if nothing has been downloaded yet.
  Future<String?> read();

  /// Replaces the cached JSON.
  Future<void> write(String json);
}
