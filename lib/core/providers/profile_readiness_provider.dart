import 'package:ebalistyka/core/extensions/profile_extensions.dart';
import 'package:ebalistyka/core/providers/shot_context_provider.dart';
import 'package:ebalistyka/shared/widgets/empty_state.dart';
import 'package:riverpod/riverpod.dart';

/// Single source of truth for "is the active profile ready for a
/// ballistics calculation, and if not, why".
///
/// `null` means ready. Otherwise the specific missing/incomplete piece
/// (weapon/ammo/sight), in the same priority order screens ask the user
/// to fill things in — see [missingProfileDataType].
///
/// Cheap and synchronous: reads whatever [shotContextProvider] currently
/// knows, it never runs a ballistics calculation itself. Anything that
/// only needs to gate an entry point (disable a button/tab, as
/// `_ScaffoldWithNav` does for the Tables tab) should watch this directly
/// instead of pulling in a specific screen's own heavier view-model —
/// each screen still reacts to a non-null value its own way (an empty
/// state placeholder, a disabled button, etc.), only the "is it ready"
/// signal itself is centralized.
final profileReadinessProvider = Provider<EmptyStateType?>((ref) {
  final ctx = ref.watch(shotContextProvider).value;
  if (ctx == null) return EmptyStateType.noProfile;
  final profile = ctx.profile;
  return profile.isReadyForCalculation
      ? null
      : missingProfileDataType(profile);
});
