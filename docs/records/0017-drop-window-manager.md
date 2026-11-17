# Drop the window_manager dependency — native window setup

**Status:** Implemented (2026-11-17, not yet verified on Windows)

`window_manager` 0.6.0 was used in one place, `lib/main.dart`, on desktop only:
title, `TitleBarStyle.normal`, initial size 375×812, minimum size 320×600,
`isMaximizable = false`, centring, show/focus. It also raised the running
window when a second launch hit the single-instance guard (`_raiseWindow`).
The package pulled in `nativeapi` and its friends, and its native parts are
the only reason the desktop targets depended on a third-party plugin for
plain window chrome. `archerbc2_flutter` already runs without it: its Linux
runner sets the title and default size itself.

## Decision

- **Linux** (`linux/runner/my_application.cc`): the runner sets the title,
  the default size 375×812, the minimum size 320×600 (`gtk_window_set_geometry_hints`)
  and centres the window (`GTK_WIN_POS_CENTER`). The GTK header bar is off, so
  the window uses the system title bar as `window_manager` did; a header bar
  would add ~50 px of height.
- **Raise on second launch**: Dart calls `ebalistyka/window` → `raise`, which the
  runner answers with `gtk_window_deiconify` + `gtk_window_present`. On platforms
  without a handler the call is ignored (`MissingPluginException`).
- **Windows** (`windows/runner/main.cpp`): title `eBalistyka` and initial size
  375×812, matching Linux. Minimum size and the raise call are **not**
  implemented there yet.
- **macOS**: unchanged; the default window from the xib is kept.
- `window_manager` and its transitive `nativeapi*` packages are removed from
  `pubspec.yaml` / `pubspec.lock`.

## Consequences

- Maximize is no longer blocked: the old `isMaximizable = false` had no
  equivalent in the GTK runner, which keeps the GTK default.
- Windows and macOS lose the minimum window size and the raise on a second
  launch until they get native handlers. A second launch exits quietly with the
  running window left where it is.
- Verified on Linux X11: the window is 375×812, the same as the CI build of
  PR #133 (`window_manager`). Wayland runs without error. The Windows build
  under Wine is still to be checked.
- Display scaling: on X11 with a 1.25 KDE scale both builds ignore it (GTK3
  does not apply fractional scale to the window), so this change does not affect it.

Follows [0014] (dependency footprint).
