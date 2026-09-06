# ObjectBox → protobuf storage cutover — finish line

**Status:** In progress

Follow-on to `docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md` and
`docs/backlogs/8.5impl.md` (pre-existing, unchanged), both otherwise
closed. Two loose ends before ObjectBox can be fully retired:

- `scripts/verify-bundle.sh`'s ObjectBox bundle check (`libobjectbox*.so`
  presence) is commented out with a `FIXME: ... REMOVE THIS SECTION AFTER
  SUCCESSFULL MERGE TO THE MAIN BRANCH` — the removal needs to be made
  permanent once the branch that dropped the ObjectBox dependency merges.
- Migrated `ConvertorsState` decodes as all-zero/empty from a real legacy
  `data.mdb` instead of the old entity's non-zero defaults. Plausible
  explanation (the old app only created that row lazily, on first use of
  a converter screen) is not yet confirmed against real user data — see
  8.5impl.md's "Open finding, not yet resolved" for the full writeup.
