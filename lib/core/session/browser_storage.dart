import 'package:ebalistyka/core/session/browser_storage_stub.dart'
    if (dart.library.js_interop) 'package:ebalistyka/core/session/browser_storage_web.dart'
    as impl;

/// Asks the browser to treat this origin's storage as persistent
/// (`navigator.storage.persist()`), so IndexedDB isn't evicted under storage
/// pressure. Best-effort: Chromium grants it by heuristics (engagement,
/// installed PWA), Firefox asks the user. Returns whether storage is now
/// persistent; always `true` on native (files).
Future<bool> requestPersistentStorage() => impl.requestPersistentStorage();
