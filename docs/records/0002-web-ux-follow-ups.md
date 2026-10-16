# Field constraints / web UX follow-ups

**Status:** In progress

Carried over from `docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md`
(pre-existing, unchanged) — this record tracks only what's still open
there. Checked against current code (2026-09-21).

## Dropped / resolved

- Array-length-mismatch validation for `custom_drag_table`/
  `powder_sensitivity_table` — **resolved.** Current
  `packages/ebc_db/schema/profiles.schema.json` restructured both the same
  way as `multi_bc_table_g1`/`_g7` (repeated row-object instead of
  parallel arrays — length mismatch is structurally impossible).

## Open — web platform

> **Status 2026-10-13: all six items below are done — see the update at the
> bottom.** The text is kept as the original analysis.

Order matters: 1 before 2, 2 before 3.

1. **`UpdateListener` (`update_sheet.dart`) has no `kIsWeb` guard.**
   `update_checker.dart:46`'s early return covers only
   `checkVersionState()`, **not** `updateCheckerProvider`, which
   `UpdateListener.build()` listens to. Today the native update sheet
   can't appear on web only because `updateCheckerProvider` throws inside
   `getApplicationSupportDirectory()` and swallows it — an accident, not a
   guard. Add `if (kIsWeb) return;` to the `ref.listen` callback (keep the
   collection check in `initState()` unconditional). Must land before
   item 2, otherwise fixing storage resurrects the sheet on web.
2. **`getApplicationSupportDirectory()` throws on web.** Call sites:
   `update_checker.dart` (lines 61, 233, 264, 371, 395, 419) and
   `builtin_collection_provider.dart:16`. Direction: `shared_preferences`
   for the four small scalars (`.version`, `last_update_check`,
   `last_collection_sha`, `last_collection_check`). The package is **not
   yet in `pubspec.yaml`**.
3. **Collection auto-update on web is a different shape, not a storage
   swap.** `collection.json` is 5+ MB — too big for `localStorage`; reuse
   `IndexedDbMsgStore` (new key for JSON + SHA). SHA-diffing logic
   unchanged. Depends on item 2 (same call sites).
4. **`.a7p`/`.ebcp` import/export unimplemented on web.**
   `a7p_service.dart`/`ebcp_service.dart` still `import 'dart:io'` and
   call `Platform.isAndroid`/`isIOS` unguarded (no `kIsWeb` anywhere in
   either file), and export writes a `File`. Needs the
   `_io.dart`/`_web.dart` conditional-import split; web export is a
   download trigger, import uses `PlatformFile.bytes` (no path).
5. **Audit remaining `dart:io`/filesystem assumptions** before calling
   web "supported", not just "boots".
6. **Final task: deploy to GitHub Pages** (`flutter build web --release`
   with the local-CanvasKit `flutter_bootstrap.js`), once the above land.

## Open — Profiles UX (deferred)

- Navigating to the profiles list isn't discoverable.
- Two screens show profile actions (`ProfilesScreen`/
  `my_profiles_screen.dart` and `ProfilesListScreen`/
  `profiles_list_screen.dart`) — merge, keep two with distinct purposes,
  or something else is undecided (card visual style already shipped).
- In-app help docs (`assets/markdown/{en,uk}/*.md`) are stale; redo them
  after the two items above are settled.

## Update (2026-10-13): web status, beta deployed

Open list above, current state:

| # | Item | State |
|---|---|---|
| 1 | `kIsWeb` guard in `UpdateListener` | done |
| 2 | `getApplicationSupportDirectory()` scalars | done (`shared_preferences`) |
| 3 | collection auto-update | done — `CollectionCache` (file on native, IndexedDB on web), cache first then bundled asset, background refresh; the SHA is the last commit that touched `collection.json` (not branch HEAD), so unrelated commits don't re-download 5.9 MB |
| 4 | `.a7p`/`.ebcp` import/export | done — `isMobile`/`isAndroid` helpers (false on web); export is a browser download, import reads picked bytes; backup and the HTML table report (opens in a new tab) too |
| 5 | audit of `dart:io` | done for reachable paths: remaining `dart:io` imports are native-only or behind `kIsWeb` (`ob_migrate` can never run on web — there was never an ObjectBox there); exercised in Chrome: Home, Tables, Settings, Profiles flows |
| 6 | deploy to GitHub Pages | **done manually**, https://ebalistyka.o-murphy.net/ |

Added on the way (not on the original list):

- single active tab/window with a fencing epoch — [0011];
- `navigator.storage.persist()` request and a desktop-only PWA install
  offer (one-time snackbar + Settings tile); `manifest.json`/`index.html`
  no longer carry `test_app` template defaults;
- `web/CNAME` (`ebalistyka.o-murphy.net`).

Deploy tooling, **manual only — no auto-deploy workflow yet**:

- `scripts/build-web.sh` (`make build-web`): release build; base href
  `/` when `web/CNAME` exists, else `/ebalistyka/` (or `BASE_HREF=`); adds
  `.nojekyll` and a `404.html` safety net; sanity-checks the bundle.
- `scripts/deploy-web.sh` (`make deploy-web`): force-pushes `build/web` as
  a single commit to `gh-pages` of `origin` (or `REMOTE=`), after
  confirmation; refuses a CNAME/base-href mismatch.
- DNS: `CNAME ebalistyka → o-murphy.github.io` (done); Pages source
  `gh-pages` / root; HTTPS enforced.

Verified on the deployed site (Chrome, HTTPS): boots, calculations, local
CanvasKit/bclibc wasm, `navigator.locks` present, second tab blocks the
first. Reported working by the owner (2026-10-13) on **iOS: Safari, Chrome
and Firefox** — all three are WebKit under the hood on iOS, so that is one
engine, not three. **Not verified:** real PWA install dialog, `persist()`
outcome in a normal profile, desktop Safari, desktop Firefox (Gecko),
Android browsers.

iOS specifics worth knowing: there is no `beforeinstallprompt` there, so
the desktop-only install offer never shows (phones are excluded on
purpose); installing is manual via Share → Add to Home Screen. WebKit's
storage policy (script-writable storage of a site that isn't installed
can be cleared after ~7 days of no interaction) makes backups matter more
for iOS users than for desktop Chromium — worth a line in the web help
topic ([0012]).

Still open on web:

- Profiles UX (deferred, see above) and the help docs — [0012].
- An auto-deploy workflow (`gh-pages` on push/tag) when wanted.
- Bundle is ~59 MB on disk, mostly unused CanvasKit variants; a client
  downloads only what it uses (~5 MB wasm + ~4.6 MB `main.dart.js` +
  assets). Pruning is optional for Pages.
- `viewport` meta has `user-scalable=no`/`maximum-scale=1` (template
  default) — an accessibility trade-off worth a conscious decision.
- Tab-lock/PWA/persist behave differently over plain HTTP (not a secure
  context): no `navigator.locks`, no install — fine on the HTTPS site.

## Update (2026-10-16)

- Profiles UX (discoverability, two screens) — **resolved** by the owner:
  already done through the tabs on the Profiles screen. This unblocks
  [0012]'s `profilesScreen` rewrite.

## Update (2026-10-16): fonts bundled

Roboto (Regular/Italic/Medium/Bold, from the Flutter SDK's `material_fonts`,
Apache-2.0) and Noto Sans Symbols (arrows, diameter sign; OFL-1.1) now live
in `assets/fonts/` and are declared in `pubspec.yaml`; both themes in
`main.dart` set `fontFamily: 'Roboto'` with `NotoSansSymbols` as fallback.
Checked on a release web build in headless Chromium: all fonts load from the
app's own `assets/`, no request to `fonts.gstatic.com` (the only external
requests left are the GitHub API/raw calls of the collection and release
checks). Cost: ~0.9 MB of assets. Fixed fonts replace the per-platform
default, so text metrics on Android/desktop also change slightly to match
Roboto.
