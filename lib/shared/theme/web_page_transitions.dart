import 'package:flutter/foundation.dart' show TargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';

/// Page transitions that leave the back gesture to the browser.
///
/// On iOS/macOS Flutter's default is the Cupertino transition, which brings
/// its own left-edge "swipe back" — and Safari has one of its own (it runs
/// `history.back()`). On web both fire for the same swipe: Flutter pops the
/// route while the browser walks history, so the two disagree about where
/// the user is, and the animations overlap. On those platforms (the host OS
/// as seen by the browser — every iOS browser is WebKit) the app uses no
/// transition and no gesture, so the browser is the single owner of "back".
///
/// Everywhere else this is the stock theme.
PageTransitionsTheme webPageTransitionsTheme() {
  if (!kIsWeb) return const PageTransitionsTheme();
  return const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: _NoTransitionsBuilder(),
      TargetPlatform.macOS: _NoTransitionsBuilder(),
    },
  );
}

class _NoTransitionsBuilder extends PageTransitionsBuilder {
  const _NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}
