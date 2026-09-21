# Field constraints / web UX follow-ups

**Status:** In progress

Carried over from `docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`
(pre-existing, unchanged) — this record tracks only what's still open
there. Checked against current code (2026-09-21).

## Dropped / resolved

- Array-length-mismatch validation for `custom_drag_table`/
  `powder_sensitivity_table` — **resolved.** Current
  `packages/ebc_db/schema/profiles.schema.json` restructured both the same
  way as `multi_bc_table_g1`/`_g7` (repeated row-object instead of
  parallel arrays — length mismatch is structurally impossible).

## Open — web platform

Order matters: 1 before 2, 2 before 3.

1. **`UpdateListener` (`update_sheet.dart`) has no `kIsWeb` guard.**
   `update_checker.dart:46`'s early return covers only
   `checkVersionState()`, **not** `updateCheckerProvider`, which
   `UpdateListener.build()` listens to. Today the native update sheet
   can't appear on web only because `updateCheckerProvider` throws inside
   `getApplicationSupportDirectory()` and swallows it — an accident, not a
   guard. Add `if (kIsWeb) return;` to the `ref.listen` callback (keep the
   collection check in `initState()` unconditional). Must land before
   item 2, otherwise fixing storage resurrects the sheet on web.
2. **`getApplicationSupportDirectory()` throws on web.** Call sites:
   `update_checker.dart` (lines 61, 233, 264, 371, 395, 419) and
   `builtin_collection_provider.dart:16`. Direction: `shared_preferences`
   for the four small scalars (`.version`, `last_update_check`,
   `last_collection_sha`, `last_collection_check`). The package is **not
   yet in `pubspec.yaml`**.
3. **Collection auto-update on web is a different shape, not a storage
   swap.** `collection.json` is 5+ MB — too big for `localStorage`; reuse
   `IndexedDbMsgStore` (new key for JSON + SHA). SHA-diffing logic
   unchanged. Depends on item 2 (same call sites).
4. **`.a7p`/`.ebcp` import/export unimplemented on web.**
   `a7p_service.dart`/`ebcp_service.dart` still `import 'dart:io'` and
   call `Platform.isAndroid`/`isIOS` unguarded (no `kIsWeb` anywhere in
   either file), and export writes a `File`. Needs the
   `_io.dart`/`_web.dart` conditional-import split; web export is a
   download trigger, import uses `PlatformFile.bytes` (no path).
5. **Audit remaining `dart:io`/filesystem assumptions** before calling
   web "supported", not just "boots".
6. **Final task: deploy to GitHub Pages** (`flutter build web --release`
   with the local-CanvasKit `flutter_bootstrap.js`), once the above land.

## Open — Profiles UX (deferred)

- Navigating to the profiles list isn't discoverable.
- Two screens show profile actions (`ProfilesScreen`/
  `my_profiles_screen.dart` and `ProfilesListScreen`/
  `profiles_list_screen.dart`) — merge, keep two with distinct purposes,
  or something else is undecided (card visual style already shipped).
- In-app help docs (`assets/markdown/{en,uk}/*.md`) are stale; redo them
  after the two items above are settled.
