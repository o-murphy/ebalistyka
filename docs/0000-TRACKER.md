# Tracker

This is the live index of project state, replacing `docs/backlogs/MasterProject.md`
§7 (Open Questions) and §9 (Implementation Phases) as the thing that gets
edited when state changes. "In progress / Proposed" means *not closed*,
whatever a linked doc's own status says. A row is the linked record's own
title, verbatim, plus a short note of what's actually still open — not a
re-summary of the whole doc.

`docs/backlogs/*.md` are not being rewritten, split, or renumbered — each
existing file is one closed historical record here, referenced by its
current filename. Going forward, new decisions get logged here directly:
small ones as a tracker row with an inline note, larger ones as a new
`docs/records/NNNN-slug.md` (see `docs/records/README.md` for the
convention) with its own row here.

## In progress / Proposed

- [ ] [7.BETA_UX] Beta Features — clicks display (Home/Tables/Reticle),
      `ammo.zeroOffset`, filter panel (Weapon/Ammo/Sight), Notepad, Help
      Overlay, Tools Screen, legal links, entity images, Android/macOS/iOS/
      Windows builds & signing, auto-update, DB resilience — see
      `docs/backlogs/7.BETA_UX.md`
- [ ] [9.FIELD_CONSTRAINTS_UX_WEB] remaining follow-ups — profiles-list
      discoverability, stale in-app help docs, missing `kIsWeb` guards,
      web collection auto-update shape, `.a7p`/`.ebcp` import/export on
      web, final GitHub Pages deploy — see
      `docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`
- [ ] ObjectBox → protobuf storage cutover still mid-flight —
      `scripts/verify-bundle.sh`'s ObjectBox bundle check is commented out
      pending merge to main (see its `FIXME`); migrated `ConvertorsState`
      decoding as empty from a real legacy `data.mdb` is unconfirmed as
      expected vs. a bug — see docs/backlogs/8.5impl.md ("Open finding,
      not yet resolved")
- [ ] [5.RETICLES_AND_IMAGES] wizard placeholders (Sight/Ammo) still SVG
      stubs; remaining reticle IDs not yet generated via `reticle_gen` —
      see `docs/backlogs/5.RETICLES_AND_IMAGES.md`
- [ ] Phase 12 — Home Note / Help / More buttons: all three still stubs
- [ ] Open question — localization scope beyond UK+EN: currently UK+EN
      only, revisit if demand appears
- [ ] Open question — Weapon/Sight/Ammo `image` field format (file /
      base64 / asset): TBD, Beta scope
- [ ] Windows msix auto-update blocked by self-signed cert — needs a
      trusted CA

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
      Architecture (superseded architecture-wise by the protobuf migration
      below; kept for history, not for its storage design)
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
      migration (see the open finding above)

## Rejected

(none yet)

## Reference (not records)

- `docs/backlogs/BallisticsConventions.md` — living conventions reference,
  not a decision log
- `docs/backlogs/MasterProject.md` — retired as the live index; kept for
  its phase-by-phase historical narrative (§9) and its now-superseded Open
  Questions (§7), both folded into this tracker above
