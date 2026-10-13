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

## Alternative solution (not decided, not implemented)

Forbid multiple *instances* of the app, but allow multiple *windows inside
one instance*. All windows then share one isolate: one `ProviderContainer`,
one `MsgStore` per file, so there is a single writer and no cross-process
notification or file lock is needed — the in-process provider state is the
broadcast. Different windows can still have different open profiles if the
active profile is a per-window uuid held in memory (same as item 3 of the
solution above).

- **Desktop:** needs (a) single-instance enforcement (lock file / named
  mutex / local socket) where a second launch forwards "open new window" to
  the running instance and exits, and (b) Flutter multi-window. The SDK
  (3.47.7) ships the windowing API (`RegularWindowController`,
  `_window_{linux,macos,win32}.dart`) behind the `enable-windowing` feature
  flag — still experimental; stability on all three desktop targets and its
  interaction with the current `main.dart` bootstrap are unchecked.
- **Web:** does not help — every tab/window is its own JS context with its
  own memory, so this only works there as "forbid": hold a
  `navigator.locks` lock for the tab's lifetime (or a `BroadcastChannel`
  ping) and show "already open in another tab" in later tabs. Multiple
  profiles in different tabs would not be possible on web with this option.
- **Mobile:** not applicable (single instance already).

Trade-off vs. the first solution: much simpler storage story on desktop (no
read-modify-write/lock/watcher), but depends on an experimental SDK feature
and gives up multi-tab on web.

## Considered and not preferred: SharedWorker (web)

A `SharedWorker` per origin could own the `IndexedDbMsgStore`, serialize
writes and broadcast "changed" to all tab ports. Not preferred: it needs a
separate worker entrypoint compiled and shipped beside the Flutter web
build; tabs still hold their own in-memory copies, so ops would have to be
serializable commands or optimistic-concurrency (`baseRev`) writes — the
same work as the first solution; a worker-owned state would turn the
synchronous providers into async proxies; browser support has nuances
(Chrome Android historically lacked it — re-verify). `navigator.locks` +
`BroadcastChannel` already give serialization + notification without any of
that.

## Alternative solution: one window, one instance, in-app split (not decided)

Single window, single instance, and an in-app split of the UI into **two
identical interface panes** — 1 or 2 profiles, never more. Everything stays
in one isolate / one `ProviderContainer` / one `MsgStore` per file, so
there is no cross-process or cross-tab coordination at all.

- Works on every platform including web and tablets; no experimental
  multi-window SDK feature, no worker, no file locks/watchers.
- Active profile becomes per-pane (uuid held in memory per pane), e.g. via
  `ProviderScope` overrides of the active-profile-derived providers (today
  they are global singletons — `activeProfileProvider`, `AppState`), plus a
  separate `Navigator`/route stack per pane (wizards and sub-screens are
  pushed on the single router today).
- Still need a cheap "forbid second instance/tab" guard so two *processes*
  can't clobber the same files: single-instance lock on desktop,
  `navigator.locks` held for the tab's lifetime on web ("already open in
  another tab"). Mobile: already single instance.
- Open design questions: which state is per-pane vs shared (settings —
  shared; conditions/wind/target distance — per-pane or shared?); the
  `_serialized()` calculation queue and recalc cost with two panes; layout
  on narrow screens (split only when wide enough, otherwise single pane or
  a pane switcher).
- Trade-off: covers "compare/work with two profiles at once" but not
  "two independent OS windows/tabs".
