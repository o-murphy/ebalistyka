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
- App hangs on close — **confirmed resolved by the project owner**: no
  longer reproduces, after several attempted fixes across other work.
  Exact fixing commit not tracked here — nothing in the diff history
  names it directly (searched via `git log -p --all -S"App hangs on
  close"`, which only shows the line being added, never removed or
  referenced again), so whichever change fixed it did so as a side effect
  of something else, not a dedicated fix commit.

(The centralized reject-invalid-writes gate that 8.3impl.md also flagged
as missing was later added — `sanitizeProfile`/`sanitizeSettingsData` in
`packages/ebc_db/lib/src/{profiles,settings}_ops.dart`, per
`docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`'s "Centralized reject/repair
gate — done." That part is closed, not carried into this record.)
