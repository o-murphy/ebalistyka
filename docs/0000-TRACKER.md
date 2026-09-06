# Tracker

This is the live index of project state, replacing `docs/backlogs/MasterProject.md`
§7 (Open Questions) and §9 (Implementation Phases) as the thing that gets
edited when state changes. "In progress / Proposed" means *not closed*,
whatever a linked doc's own status says. A row is the linked record's own
title, verbatim, plus a short note of what's actually still open — not a
re-summary of the whole doc.

`docs/backlogs/*.md` are everything already on `main` up to this point —
not rewritten, split, or renumbered. Each such file is one closed
historical record here, referenced by its current filename. Anything
actually open right now gets a real numbered record in `docs/records/`
instead (see `docs/records/README.md` for the convention); going forward,
that's also where new decisions get logged as they're made.

## In progress / Proposed

- [ ] [0001] Beta UX — remaining work
- [ ] [0002] Field constraints / web UX follow-ups
- [ ] [0003] ObjectBox → protobuf storage cutover — finish line
- [ ] [0004] Reticles — wizard placeholders & remaining SVG generation
- [ ] [0005] Home Note / Help / More buttons
- [ ] [0006] Open question — localization scope beyond UK+EN
- [ ] [0007] Open question — Weapon/Sight/Ammo `image` field format
- [ ] [0008] Windows msix auto-update blocked by self-signed cert
- [ ] [0009] ebc_db migration residue — app-close hang & Tables spinner
      root cause
- [ ] [0010] Profile reordering vs. "index 0 = active" convention
- [ ] [0011] Web IndexedDB backend — cross-tab write coordination
      undesigned

## Implemented

- [x] Phases 1–5 — Foundation: domain models, storage, providers,
      navigation (no standalone doc)
- [x] Phases 6–11, A7P — Home/Conditions/Tables/Convertors/Settings
      screens, Weapon/Ammo/Sight wizards + collection screens, `.a7p`
      import/export (no standalone doc)
- [x] [1.REFACTORING_PLAN] eBalistyka — Refactoring Plan
- [x] [RECALC_REFACTORING] RecalcCoordinator Removal & ViewModel Listener
      Refactoring
- [x] [2.REFACTORING_PLAN_2] REFACTORING_PLAN_2.md — Post-Refactoring
      Improvements
- [x] [3.OBJECTBOX_MIGRATION] ObjectBox Migration Plan — Simplified
      Architecture (superseded architecture-wise by the protobuf migration,
      [0003]; kept for history, not for its storage design)
- [x] [4.PROFILES_CRUD_PLAN] Profiles CRUD & Selection Architecture
- [x] [7.1.Code_Quality] Code Quality — Optimization & Restructuring
- [x] [7.2.Localization] Localization — Remaining Work
- [x] [6.ALPHA_UX] Alpha UX — TODO
- [x] [8.PROTOBUF_STORAGE_MIGRATION] Protobuf Storage Migration — Replace
      ObjectBox with Two Embedded Protobuf Files
- [x] [8.3] Phase 3 — Riverpod integration (`ebc_db` wired into the
      running app)
- [x] [8.3impl] Phase 3 — Riverpod integration + Profiles screen split
- [x] [8.5impl] Phase 5: Legacy ObjectBox → `profiles.ebcp`/`settings.ebcp`
      migration (see the open finding tracked in [0003])

## Rejected

(none yet)

## Reference (not records)

- `docs/backlogs/BallisticsConventions.md` — living conventions reference,
  not a decision log
- `docs/backlogs/MasterProject.md` — retired as the live index; kept for
  its phase-by-phase historical narrative (§9) and its now-superseded Open
  Questions (§7), both folded into this tracker above
