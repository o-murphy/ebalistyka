# ebalistyka_db — DEPRECATED

**This package is no longer used.** It was the app's original ObjectBox-based
data layer; it has been fully superseded by
[`packages/ebc_db`](../ebc_db/README.md) (protobuf-backed, no closed-source
native dependency — see `docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md` for
the full rationale).

As of this notice:

- The root app (`pubspec.yaml`) no longer depends on this package.
- No code under `lib/` references it — including the legacy-data migration
  in `lib/ob_migrate/` (Phase 5 of the doc above), which deliberately reads
  old installs' ObjectBox stores via `ob_dump_reader_flutter` (raw
  LMDB/FlatBuffers) instead, precisely so it never needs this package or
  its closed-source `objectbox-c` native dependency.
- It's kept on disk for now only as a historical reference, not because
  anything still needs it.

It will be deleted entirely once Phase 6 of that document runs (see its
checklist for exactly what that entails). Do not add new code here or take
a new dependency on it.
