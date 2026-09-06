# Field constraints / web UX follow-ups

**Status:** In progress

Carried over from `docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`
(pre-existing, unchanged) — this record tracks only what's still open
there:

- Navigating to the profiles list isn't discoverable — deferred
- In-app help docs (`assets/markdown/{en,uk}/*.md`) are stale
- `UpdateListener` (`update_sheet.dart:54-71`) has no `kIsWeb` guard
- `getApplicationSupportDirectory()` throws on web in several more places
- Collection auto-update becomes a different shape on web, not just
  disabled
- `.a7p`/`.ebcp` import and export are unimplemented on web, not just
  stubbed
- Final task: deploy to GitHub Pages, once the items above land
