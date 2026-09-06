# ebc_db migration residue — app-close hang & Tables spinner root cause

**Status:** Implemented — see verification note below (2026-09-06).

Surfaced in `docs/backlogs/8.3impl.md` ("Still open, not addressed by this
pass") during the Riverpod/`ebc_db` integration:

- Tables screen's stuck-loading-spinner trigger — **confirmed resolved**,
  found in commit `f4828d6` ("update: backlog, mark already solved issues
  as done", 2026-07-23). Root cause turned out to be a `bclibc`/wasm-level
  bug (concurrent `AsyncCalculator` calls hanging on web), fixed upstream;
  `docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md` has the checkbox marked
  `[x]` with the full writeup. The app-side `_serialized()` queue
  workaround is left in place as a harmless belt-and-suspenders.
- App hangs on close — **no commit or doc evidence of a fix found.**
  Searched all tracked history (`git log -p --all -S"App hangs on
  close"`) — the line was only ever added (8.3impl.md, then copied here),
  never removed or referenced again anywhere. Marked Implemented per
  project owner's confirmation, but noting this specifically wasn't
  independently verifiable the way the spinner fix was — worth a
  double-check that this is the same bug being recalled and not conflated
  with the (confirmed) spinner fix.

(The centralized reject-invalid-writes gate that 8.3impl.md also flagged
as missing was later added — `sanitizeProfile`/`sanitizeSettingsData` in
`packages/ebc_db/lib/src/{profiles,settings}_ops.dart`, per
`docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`'s "Centralized reject/repair
gate — done." That part is closed, not carried into this record.)
