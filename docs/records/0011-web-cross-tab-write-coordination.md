# Web IndexedDB backend — cross-tab write coordination

**Status:** Implemented — web (single active tab + fencing epoch) and desktop (single app instance); the multi-window/multi-profile alternatives are deferred until users ask

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

## Implemented for web: single active session (2026-10-13)

Chosen for web instead of the read-modify-write + notification design
above: only one tab/window of a browser profile works at a time,
WhatsApp-Web style.

- `lib/core/session/tab_lock.dart` (+ `_web`/`_stub`): each page holds an
  exclusive `navigator.locks` lock (`ebalistyka:active-session`) for its
  lifetime and **steals** it on load, before reading the stores. The page
  that gets robbed learns of it through its pending request rejecting
  (`AbortError`). The browser releases the lock when the page goes away.
- On loss, `MsgStore.writesBlocked` is set on the settings/profiles stores
  (writes — including a pending debounced one — are dropped) and
  `tabBlocked` flips, which makes `TabBlockedGate` (in `MaterialApp.builder`)
  cover the app with "Opened in another window" + **Use here**.
- **Use here** reloads the page, which re-reads the persisted data and
  steals the session back; the other tab is then blocked in turn.
- No-op on native (never blocked); desktop single-instance is separate and
  still open. `navigator.locks` missing (insecure context) → no coordination.

Verified in Chrome 155 with two tabs: opening B blocks A; B's persisted
change is visible after A takes over; taps on the blocked tab's underlying
UI are ignored and not persisted; "Use here" in A blocks B. Unit tests:
`packages/ebc_db/test/msg_store_blocked_test.dart`,
`test/shared/widgets/tab_blocked_gate_test.dart`.

### Follow-up (2026-10-13): fencing token, persistent storage, PWA

- **Fencing epoch** closes the "write already in flight at the takeover"
  window: `IndexedDbWriteFence.claim()` bumps a monotonic `__session_epoch`
  key at startup; every fenced write checks it and does the `put` inside
  the same IndexedDB transaction, aborting (and calling `onStale`, which
  blocks the UI) if it is no longer ours. Independent of `navigator.locks`.
  Tests: `packages/ebc_db/test/indexed_db_fence_test.dart`
  (`dart test -p chrome`).
- **`navigator.storage.persist()`** is requested on startup
  (`core/session/browser_storage*.dart`) so the browser doesn't evict
  IndexedDB under storage pressure. Best-effort — Chromium decides by
  heuristics (a fresh localhost profile gets `false`; installed PWAs and
  engaged sites get `true`), Firefox prompts.
- **PWA install offer**, desktop browsers only (phones excluded on
  purpose): `beforeinstallprompt` is captured, a one-time dismissible
  snackbar + a Settings tile offer to install. `manifest.json`/`index.html`
  still carried `test_app`/"A new Flutter project" defaults — fixed
  (name, description, theme colour, `orientation: any`).
- Backup reminders were considered and rejected as too intrusive.

Still not covered: two different profiles in two tabs at once (use the
in-app split alternative above if that's wanted); Safari/Firefox not
exercised; nothing can prevent the user from clearing site data
themselves.

## Alternative: adaptive multi-window workspace (not decided)

Proposed (2026-10-13), extending the in-app split above:

- **Small screens / phones:** unchanged — one profile, one window.
- **Large desktop displays:** several windows of one process.
- **Browsers and mobile/tablets on large screens:** the app acts as a
  virtual window manager — several windows *inside* one window.

Assessment:

- Common core, three hosts: a *workspace* parameterised by `profileUuid`
  (its own navigator stack and scoped providers) can be hosted as (a)
  the single full-screen workspace of today, (b) in-app panes, (c) OS
  windows on desktop. Build the core once.
- "Separate threads" on desktop: Flutter multi-window shares a single
  isolate by default, which is the point — one `ProviderContainer`, one
  `MsgStore` per file, no state synchronisation. Separate isolates would
  mean separate heaps and message passing with a single owner of the
  storage, for little gain (ballistics already runs in `Isolate.run`).
  Prefer one isolate, several views.
- Free-floating windows (drag/resize/z-order/focus/touch) are costly for
  little benefit; tiling 1–2 (max 3) panes gives the same value. Earlier
  stated need: never more than two profiles.
- Cost: `activeProfileProvider`/`AppState` are global and need scoping
  per workspace; `appRouter` is a single global router; decide which
  conditions (wind, target distance) are per-workspace vs. shared
  (settings are shared); on web the `_serialized()` calculation queue
  makes N panes contend for one wasm engine; dialogs/snackbars/help must
  attach to the workspace that raised them; desktop still needs
  single-instance enforcement.
- Suggested order: (1) workspace core with scoped providers, (2) in-app
  panes 1–2 (web, desktop, tablet), (3) OS windows on desktop once the
  `enable-windowing` SDK feature is stable. None of this blocks the web
  beta — the tab lock already protects the data.

## Update (2026-10-16): desktop — single instance; multi-window deferred

Decision (owner): on desktop, forbid a second app process rather than build
cross-process change notification. A second launch no longer opens a window:
it asks the running instance to come to the front and exits. The multi-window
mode ("Potential solution" above and the in-process "Alternative solution")
is deferred until users ask for it.

Implemented in `lib/core/session/single_instance*.dart`, called from `main()`:
- the first instance takes an exclusive `File.lock` on `instance.lock` in the
  app-support directory (the OS drops it when the process ends, however it
  ends, so a crash leaves nothing stale) and listens on a loopback socket
  (port written to `instance.port`);
- a later launch fails to get the lock, connects to that port, sends an
  activation message and exits; the first instance restores/shows/focuses its
  window (`window_manager`);
- if the lock can't be used at all (no data dir, file system without locking)
  the app runs unguarded, as before; if the lock is held but the running
  instance doesn't answer within ~2 s the new process exits anyway, because
  two writers is the thing being prevented.

Checked with two real `dart` processes on Linux: second one sees the lock,
the first receives the activation, and after the first exits a new launch
becomes the primary. The window raising itself (`window_manager` on Linux,
Windows, macOS) and Flatpak/Snap sandboxes were **not** exercised here.
`flutter test` covers only the activation channel; lock exclusivity is
per-process (fcntl) so it can't be tested in-process.
