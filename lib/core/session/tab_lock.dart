import 'package:ebalistyka/core/session/tab_lock_stub.dart'
    if (dart.library.js_interop) 'package:ebalistyka/core/session/tab_lock_web.dart'
    as impl;
import 'package:flutter/foundation.dart';

/// Single-active-session guard for web.
///
/// The persisted data (IndexedDB) is shared by every tab/window of the same
/// browser profile, and each one keeps its own in-memory copy and writes the
/// *whole* file — two live tabs would silently overwrite each other (see
/// docs/records/0011). So only one tab works at a time, WhatsApp-Web style:
/// a newly opened tab takes over, the previous one is blocked with a "use
/// here" action (which reloads the page, so it re-reads current data and
/// takes the session back).
///
/// Built on `navigator.locks`: each page holds one exclusive lock for its
/// lifetime and steals it on load; the page that gets robbed is told so by
/// its pending request rejecting. The browser releases the lock when the page
/// goes away, so a closed/crashed tab never leaves it stuck.
///
/// Native platforms: no-op, never blocked.

/// `true` once another tab/window has taken this session over.
final ValueNotifier<bool> tabBlocked = ValueNotifier<bool>(false);

/// Takes the session for this page (stealing it from another tab if needed).
/// [onLost] is called once if another page takes it from us later.
Future<void> acquireTabLock({required VoidCallback onLost}) =>
    impl.acquire(onLost: onLost);

/// Reloads the page — what "use here" does.
void reloadApp() => impl.reload();
