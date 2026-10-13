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

## Scope (clarified)

Applies to every concurrent instance, not only browser tabs: multiple
browser tabs/windows on web, and multiple app windows/processes on desktop.
Just making the active profile per-instance isn't enough — there's
currently no way for one window to learn that another changed the DB, and
`MsgStore` persists the *whole* file, so a plain notification wouldn't stop
last-writer-wins from silently dropping the other window's edits.

Direction: notify windows about changes (rather than forbidding multiple
windows), so different windows/tabs can have different profiles open at the
same time.

## Potential solution (not decided, not implemented)

1. **Read-modify-write under a short-lived lock.** All mutations are already
   pure functions over the state (e.g. `_updateProfiles((profiles) => ...)`).
   Make a write: acquire lock → re-read the file → apply the function →
   write → release → notify. Lock on web: `navigator.locks.request(...)`
   held for one write only (not the tab's lifetime); on desktop:
   `RandomAccessFile.lock()` on a separate `.lock` file next to the data.
   Edits to different profiles then merge; on the same profile the last
   write wins.
2. **Change notification.** Add `Stream<void> externalChanges` to
   `MsgStore`; providers re-read and update on it. Transport per platform,
   one interface: web `BroadcastChannel('ebc_db')` with `{file, rev,
   senderId}`; desktop `Directory.watch()` on the data directory filtered
   by file name (watch the directory — the write is tmp-file + rename).
   Own writes are filtered out by `senderId`/`rev`. Mobile: not needed.
3. **Per-instance active profile.** Active = a uuid held in memory per
   window, not `profiles[0]`. Index 0 on disk stays as "last activated",
   used only as the default for a newly opened window. If another window
   deletes this window's active profile, fall back to `profiles[0]`. This
   also settles [0010] in the "active by uuid" direction.
4. **Settings** are shared by all windows through the same mechanism
   (changing units in one window updates all) — intended, no separate
   handling.

Fallback if the desktop watcher proves unreliable: single-instance lock on
desktop only, leaving multi-tab on web.

Open caveats: a wizard open on a profile that another window changed keeps
its draft and saves through the same read-modify-write op (last write wins
on that profile, optionally with a warning); hard to test without two
processes — most of the logic can be covered with two `MsgStore`s over a
shared in-memory backend.

Suggested order: (1) read-modify-write + lock, (2) `externalChanges` on web,
(3) per-instance active profile, (4) desktop watcher.
