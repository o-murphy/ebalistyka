import 'package:ebalistyka/core/session/pwa_install_stub.dart'
    if (dart.library.js_interop) 'package:ebalistyka/core/session/pwa_install_web.dart'
    as impl;
import 'package:flutter/foundation.dart';

/// `true` while the browser offers to install the app as a PWA.
///
/// Only ever true on *desktop* browsers that fire `beforeinstallprompt`
/// (Chromium: Chrome/Edge) and when the app isn't already running installed.
/// Phones are deliberately excluded. Installing matters mostly because an
/// installed PWA gets persistent storage (the browser won't evict the data).
final ValueNotifier<bool> pwaInstallAvailable = ValueNotifier<bool>(false);

/// Starts listening for the browser's install offer. Call early at startup —
/// `beforeinstallprompt` can fire before the first frame.
void initPwaInstall() =>
    impl.init(setAvailable: (v) => pwaInstallAvailable.value = v);

/// Shows the browser's install dialog (no-op if no offer is pending).
Future<void> promptPwaInstall() async {
  await impl.prompt();
  pwaInstallAvailable.value = false;
}
