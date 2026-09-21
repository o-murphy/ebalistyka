# Profile reordering vs. "index 0 = active" convention

**Status:** Proposed

`docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md` drafted and rejected an
explicit `Settings.active_profile_uuid` pointer in favor of staying
list-position-based (active profile = index 0). `docs/backlogs/8.3.md`
built `activeProfileOf`/`setActiveProfileOf` on that convention and
flagged the same open point: if the Profiles screen ever gets manual
display-order reordering independent of "which one is active," that needs
its own UI convention (e.g. active always pinned to index 0, manual
reordering only applies to `profiles[1:]`) — undecided, needed before any
reordering UI is wired up.
