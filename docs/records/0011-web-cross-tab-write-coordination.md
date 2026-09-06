# Web IndexedDB backend — cross-tab write coordination undesigned

**Status:** Proposed

`docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md` flagged that the desktop
storage design assumes single-writer-per-file (`File.lock()`), and that
the web backend needs an equivalent — a `BroadcastChannel`-based
leader-election between tabs, or an exclusive `navigator.locks` (Web Locks
API) hold for the tab's lifetime — before shipping without it. As of the
`ebc_db` web IndexedDB backend landing, no such mechanism exists yet and
neither side has been designed. Two or more tabs open against the same
profile/settings data can race today.
