import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// defaultTargetPlatform on web reflects the host OS's user agent (e.g.
// TargetPlatform.linux in Chrome on a Linux machine) — without the kIsWeb
// guard this was true in a browser too, which crashed window_manager
// (a desktop-only plugin with no web implementation) on first launch there.
bool get isDesktop =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS);
