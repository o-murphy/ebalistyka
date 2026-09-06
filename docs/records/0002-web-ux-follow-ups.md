# Field constraints / web UX follow-ups

**Status:** In progress

Carried over from `docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`
(pre-existing, unchanged) — this record tracks only what's still open
there. Checked against current code (2026-09-06):

- Array-length-mismatch validation for `custom_drag_table`/
  `powder_sensitivity_table` — **dropped, resolved.** Current
  `packages/ebc_db/schema/profiles.schema.json` shows both were
  restructured the same way as `multi_bc_table_g1`/`_g7` (repeated
  row-object instead of parallel arrays — "length mismatch is now
  structurally impossible"). All four pairs are done, not two of four.
- `.a7p`/`.ebcp` import and export on web — **partially done, not
  closed.** `a7p_service.dart`/`ebcp_service.dart` now guard the save-path
  branch with `!kIsWeb`, but both still unconditionally `import 'dart:io'`
  and call `Platform.isAndroid` at top level — the `_io.dart`/`_web.dart`
  conditional-import split the doc says is needed hasn't landed.
- `UpdateListener` (`update_sheet.dart`) itself still has no `kIsWeb`
  guard — but `update_checker.dart:46` already returns
  `NewVersionState.none` on web unconditionally, so in practice the
  sheet can never fire there today. Low-risk as long as that early return
  stays in place; the doc's literal complaint (guard missing from
  `UpdateListener` itself) is still technically true.

- Navigating to the profiles list isn't discoverable — deferred
- Two screens show profile actions (`ProfilesScreen`/`my_profiles_screen.dart`
  and `ProfilesListScreen`/`profiles_list_screen.dart`) — whether they
  should merge, stay two with distinct purposes, or something else is
  still not decided (card visual style itself was already reworked and
  shipped)
- In-app help docs (`assets/markdown/{en,uk}/*.md`) are stale
- `UpdateListener` (`update_sheet.dart:54-71`) has no `kIsWeb` guard
- `getApplicationSupportDirectory()` throws on web in several more places
- Collection auto-update becomes a different shape on web, not just
  disabled
- `.a7p`/`.ebcp` import and export are unimplemented on web, not just
  stubbed
- Final task: deploy to GitHub Pages, once the items above land
