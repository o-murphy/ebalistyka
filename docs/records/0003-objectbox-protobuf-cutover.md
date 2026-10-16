# ObjectBox → protobuf storage cutover — finish line

**Status:** Implemented

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

## Update (2026-10-16): both loose ends closed

- The commented-out ObjectBox block (and its FIXME) is deleted from
  `scripts/verify-bundle.sh`.
- `ConvertorsState`: the all-zero decode was not a decode bug — a legacy
  `data.mdb` with no `ConvertorsState` row (never created until a converter
  screen is opened) fell back to a bare `ConvertorsState()`, which is all
  zero/empty; fresh installs (`seedSettings`) and the provider fallback had
  the same problem. All three now use `defaultConvertorsState()`
  (`packages/ebc_db/lib/src/ops/settings_ops.dart`), which carries the old
  entity defaults documented in `settings.schema.json` (length/weight/
  torque 100, pressure 1013, temperature 68 °F, angles 100 m / 1 mil,
  velocity 300 m/s, target 8 in / 1 mil, ...). A row that *does* exist in
  legacy data is still mapped as-is.

## Update (2026-10-16, later): migration test with a real fixture

`data.mdb`/`lock.mdb` from the old app (the `packages/ebalistyka_db/sample/`
files deleted in `bfe6f40`, found in the full git history) are now
`test/ob_migrate/fixtures/`, and `test/ob_migrate/legacy_migrator_test.dart`
runs `migrateLegacyData` on them (needs liblmdb: `make build-lmdb`, now a
dependency of `make test`). The fixture holds one profile and has **no**
`ConvertorsState` (entity 2) and **no** `TablesSettings` (entity 7) row.

That exposed the same bug as `ConvertorsState` in a second place: a missing
`TablesSettings` migrated as a bare `TablesSettings()` — distance end/step 0
and every column flag off, i.e. an empty Tables screen. Missing
`TablesSettings`, `GeneralSettings` and `ShootingConditions` rows now fall
back to `seedSettings()` (what a fresh install gets), like `ConvertorsState`
does via `defaultConvertorsState()`. The new tests fail on the old code
(`distanceEndMeter` 0.0 instead of 1000.0).
