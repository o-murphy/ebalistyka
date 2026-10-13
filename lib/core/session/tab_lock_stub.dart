import 'dart:ui' show VoidCallback;

/// Native platforms have a single instance; nothing to coordinate.
Future<void> acquire({required VoidCallback onLost}) async {}

void reload() => throw UnsupportedError('reload is web-only');
