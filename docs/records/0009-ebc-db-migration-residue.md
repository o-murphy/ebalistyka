# ebc_db migration residue — app-close hang & Tables spinner root cause

**Status:** Implemented — resolved since this record was written (per
project owner, 2026-09-06); kept for the history of what the bug was and
where it was flagged.

Surfaced in `docs/backlogs/8.3impl.md` ("Still open, not addressed by this
pass") during the Riverpod/`ebc_db` integration and never picked back up
since — no later doc or commit references either one:

- App hangs on close — reported, not investigated.
- Tables screen's stuck-loading-spinner trigger was never isolated; a
  generation-counter guard added at the time makes it defensive-safe, but
  the actual original cause of the hang is still unconfirmed.

(The centralized reject-invalid-writes gate that 8.3impl.md also flagged
as missing was later added — `sanitizeProfile`/`sanitizeSettingsData` in
`packages/ebc_db/lib/src/{profiles,settings}_ops.dart`, per
`docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`'s "Centralized reject/repair
gate — done." That part is closed, not carried into this record.)
