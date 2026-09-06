# Field constraints / web UX follow-ups

**Status:** In progress

Carried over from `docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`
(pre-existing, unchanged) — this record tracks only what's still open
there:

- Navigating to the profiles list isn't discoverable — deferred
- Two screens show profile actions (`ProfilesScreen`/`my_profiles_screen.dart`
  and `ProfilesListScreen`/`profiles_list_screen.dart`) — whether they
  should merge, stay two with distinct purposes, or something else is
  still not decided (card visual style itself was already reworked and
  shipped)
- Array-length-mismatch validation: done for `Ammo`'s `multi_bc_table_g1`/
  `_g7` pairs; still open for `custom_drag_table_mach`/`_cd` and
  `powder_sensitivity_tc`/`_v_mps`
- In-app help docs (`assets/markdown/{en,uk}/*.md`) are stale
- `UpdateListener` (`update_sheet.dart:54-71`) has no `kIsWeb` guard
- `getApplicationSupportDirectory()` throws on web in several more places
- Collection auto-update becomes a different shape on web, not just
  disabled
- `.a7p`/`.ebcp` import and export are unimplemented on web, not just
  stubbed
- Final task: deploy to GitHub Pages, once the items above land
