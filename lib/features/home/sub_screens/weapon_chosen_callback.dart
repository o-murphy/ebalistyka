import 'package:ebc_db/ebc_db.dart';
import 'package:material_ui/material_ui.dart';

/// Passed (via the route's `extra`) to the weapon wizard / weapon collection
/// when they are opened to start a new profile. Called once a weapon is
/// created or picked, with the screen's own [context] so a dialog opens above
/// it; returns true when the flow is complete and the screen may close, false
/// to stay on the screen (e.g. the profile-name dialog was cancelled).
typedef WeaponChosenCallback =
    Future<bool> Function(BuildContext context, Weapon weapon);
