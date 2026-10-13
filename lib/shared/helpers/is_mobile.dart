import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// Same reasoning as is_desktop.dart: on web defaultTargetPlatform reflects the
// host OS (Chrome on Android reports TargetPlatform.android), and dart:io's
// Platform.* throws there — so web is excluded here, in one place, instead of
// at every call site.

/// Native Android or iOS (never web).
bool get isMobile =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

/// Native Android only (never web).
bool get isAndroid =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
