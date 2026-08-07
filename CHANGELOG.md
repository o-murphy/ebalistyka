# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

---


## Unreleased
[![GitHub release][GitHubCompareBadge]][Unreleased]

### Changed
- **`dart_bclibc_flutter` bumped `^0.2.0-beta.3` → `^0.2.0`** — first stable release (`dart_bclibc` follows transitively as its dependency).
- **`ProfilesListScreen` cards redesigned** to match the built-in collection cards' visual style — `ProfileListTileBody` now shows 4 icon+value rows (weapon, caliber, ammo, sight) instead of the old bare 2-line weapon/ammo text stack with no icons and no sight at all.
- **Removed dead `importAmmo`/`importSight` stubs** (`AppStateNotifier`) — unconditionally-throwing methods with no UI entry point calling them anywhere in the app. Deleted along with the now-unused `ImportNotAvailableException`; standalone (outside-a-profile) ammo/sight import/export stays a deferred idea, not a half-built feature.
- **Duplicate-profile naming** — every "Duplicate profile" entry point (`ProfilesScreen`, `ProfilesListScreen`, and the new hotswap duplicate-first flow below) now prefixes the copy's name with `[COPY]` instead of the old localized "Copy of"/"Копія" prefix (the `copyOf` string is now dead and has been removed from both ARB files).
- **Action sheet subtitle color** — now uses `colorScheme.tertiary` instead of `onSurfaceVariant`, matching the rest of the app's warning/attention styling (button hints, the non-destructive `showConfirmDialog` button).
- **`ProfileControlTile`** (My Profile screen) — the profile's name is now shown above the card; previously it wasn't displayed anywhere on this screen. `ProfilesScreen`'s Weapon/Ammo/Sight detail sections are now hidden entirely for whichever component hasn't been set on the profile, instead of rendering an empty/placeholder section.
- **Home screen** — the button that opens the profiles screen now shows the profile's name even when the profile is incomplete (missing ammo/sight); it previously fell back to a placeholder dash in that state.
- **`ProfilesListScreen`'s "Edit" action** — relabeled to "Edit Profile Name", matching what it actually does (rename) instead of the generic "Edit" label, which implied opening the full profile editor.
- **`dart_bclibc_flutter` bumped to `0.2.0-beta.3`; app no longer imports `dart_bclibc` directly anywhere.** The analyzer flagged every direct `package:dart_bclibc/unit.dart` (73 imports, ~60 files) and `package:dart_bclibc/ffi/bclibc_ffi.dart` (`app_bootstrap_io.dart`) import as an undeclared dependency — expected pub behavior, since a direct import always needs its own direct dependency entry regardless of what a transitive dependency (`dart_bclibc_flutter`) re-exports. Fixed by adding a top-level `unit.dart` to the `dart_bclibc_flutter` facade (renamed from an unused `units.dart`, matching `dart_bclibc`'s own naming so the fix was a plain package-name swap) and switching every remaining direct import over to it/`bclibc.dart`, instead of declaring `dart_bclibc` as a second direct dependency. `flutter analyze` clean; see `docs/backlogs/9.FIELD_CONSTRAINTS_UX_WEB.md` (Phase 9) for the full writeup.
- **Storage engine — ObjectBox replaced with two embedded protobuf files.** `packages/ebalistyka_db` (ObjectBox entities, `ToOne<Owner>` relations, `Query.watch()` streams) is replaced by the new `packages/ebc_db` package: persisted state is now `settings.ebcp`/`profiles.ebcp`, two independent "md5+ebcpbuf" protobuf files (`SettingsData`/`ProfilesData`) written atomically (tmp+flush+rename+`.bak`) to `<applicationSupportDirectory>`, with no relational ids or `Owner` singleton. `Profile` is now 1 weapon : 1 ammo : 1 sight (no nested lists), addressed by a client-generated `uuid`; the active profile is `profiles[0]`. Riverpod providers (`settingsDataProvider`/`profilesProvider`/`activeProfileProvider`) replace every ObjectBox-stream-backed provider. Existing installs are migrated automatically on first launch after upgrade via a new `MigrationGate` (`lib/ob_migrate/`), which reads the old ObjectBox store with [`ob_dump_reader_flutter`](https://github.com/o-murphy/ob-dump) (no `objectbox` dependency needed to read it back out) and writes the new files; the old `data.mdb`/`lock.mdb` are left on disk untouched. See `docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md` for the full design/execution log.
- **flutpak** - refs updated to v0.8.3
- **flutter sdk** - upgraded to `3.44.9`
- **A7P format dependency** — replaced `packages/a7p` (local path package) with [`a7p ^1.2.3`](https://pub.dev/packages/a7p) from pub.dev. `A7pConverter`/`A7pRange` (the proto ↔ `ProfileExport` conversion, plus the distance-range tables — app-specific, and not part of the standalone `a7p` package) now live in `lib/core/services/a7p_converter.dart`.
- **Ballistic engine dependency** — replaced `packages/bclibc_ffi` (local git-submodule-based FFI package) with [`dart_bclibc ^0.1.1`](https://pub.dev/packages/dart_bclibc) from pub.dev. The `external/bclibc` submodule and `packages/bclibc_ffi` local package have been removed; the native shared library is now built and bundled by `dart_bclibc`'s own CMake rules.
- **`linux/CMakeLists.txt`**, **`windows/CMakeLists.txt`** — removed manual `install(TARGETS bclibc_ffi …)` / `add_dependencies` blocks that are now handled inside `dart_bclibc`'s platform CMakeLists.
- **`flutpak.yaml`** — removed `modules: [flatpak/modules/bclibc.yml]` and `disable-submodules: true` (no longer needed; `dart_bclibc` bundles bclibc source via the pub.dev archive).
- **`Makefile`** — `build-bclibc` target now runs `dart run dart_bclibc:build_native`; the `ffigen` target has been removed (bindings are generated upstream in `dart_bclibc`).
- **`lib/main.dart`** — `BcLibC.open()` is now called before `WidgetsFlutterBinding.ensureInitialized()`. If the shared library fails to load the process exits immediately with `Fatal: native library unavailable: …` on stderr (exit code 1) instead of surfacing the error in the UI only when the first calculation runs.
- **`scripts/verify-bundle.sh`** — enhanced native library checks:
  - Linux: broken-symlink detection + `file -L` ELF validation for `libbclibc_ffi.so`
  - Windows: MZ PE-header check via `od` for `bclibc_ffi.dll`

### Added
- **Web persistence via IndexedDB.** `packages/ebc_db`'s `MsgStore<T>` split into an abstract base (debounce, write-serialization, encode/decode) plus two backends: `FileMsgStore` (the existing `dart:io` atomic tmp+flush+rename+`.bak` writer, desktop/mobile) and a new `IndexedDbMsgStore` (web, built on `package:web`, not exported from `ebc_db`'s main barrel). `app_bootstrap_web.dart` now actually persists `settings.ebcp`/`profiles.ebcp` on web instead of the earlier "seed into memory, never save" spike shortcut — a page reload no longer silently discards every edit.
- **Downloads page.** `web/download/index.html` — a static landing page listing every native install method (Linux AppImage/Snap/Flatpak/deb/rpm/AUR, Windows winget/MSIX, Android Play/APK/universal) with copy-to-clipboard commands, a platform-autodetect tab bar, and simple-icons-font brand icons. Ships inside the Flutter web build itself (`flutter build web` copies it to `build/web/download/`) rather than needing a separate hosting target. On web, Settings' "Check for updates" tile is replaced with **"Download the app"**, linking there instead — the native update-checker flow doesn't apply inside a browser tab.
- **Centralized profile-readiness signal** — new `profileReadinessProvider` (`lib/core/providers/profile_readiness_provider.dart`), a cheap `null`-means-ready provider built on the same `missingProfileDataType` helper every screen's empty state already used. Home's "info" button and the Tables bottom-nav tab are now disabled when the profile isn't ready (instead of only letting the destination screen show its own empty state after navigating there), and tapping either shows a toast with the same message the empty-state placeholder would.
- **Weapon hotswap action** on the My Profile screen — mirrors the existing ammo/sight create-new / from-collection / import-from-file action sheet, wired to a new bottom-left button on `ProfileControlTile` (mirrors the sight button's top-left treatment). After swapping in a new weapon, if the profile's ammo has a different caliber, offers to update the ammo's caliber to match (mirrors `AmmoWizardScreen`'s own caliber-mismatch sheet, triggered from the weapon side this time).
- **Data-loss warning before any hotswap** (weapon/ammo/sight) — replacing a component that already has data now opens an action sheet offering **Replace** (destructive, same profile) or **Duplicate** (one tap, no name prompt, auto-named `[COPY] <name>`; the hotswap then lands on the duplicate, which is made active immediately so the change is visible) instead of silently discarding the old data.
- **Native library smoke tests** in CI across all build formats — verify that the shared library is present, valid, and loads cleanly at startup:
  - `build.yml` (Linux): runs the app binary, checks stderr for `"Fatal: native library"`
  - `build.yml` (Windows): `Start-Process` + stderr check for the same message
  - `build-android.yml`: unzips APK/AAB and checks `libbclibc_ffi.so` ELF for each ABI (`arm64-v8a`, `armeabi-v7a`, `x86_64`)
  - `build-flatpak.yml`: installs bundle via `flatpak install`, checks ELF, runs app under `dbus-run-session`
  - `build-snap.yml`: `unsquashfs` extraction + ELF check

### Fixed
- **A profile/settings could hold out-of-range or zero-default values indefinitely right after cold start.** `ProfilesNotifier`/`SettingsDataNotifier`'s `update()` already clamped every write via `sanitizeProfile`/`sanitizeSettingsData`, but `build()` — the initial load from `profiles.ebcp`/`settings.ebcp` at startup — returned the loaded data as-is. A value saved to disk before that sanitize gate existed (or never touched by an `update()` call since) stayed unclamped in memory until surfaced by something else, e.g. a raw `Zero.pressure_h_pa: 0.0` getting faithfully re-exported via `.ebcp`. `build()` now sanitizes on load too, same gate `update()` uses.
- **Tables' Trajectory tab could get stuck on an infinite loading spinner instead of showing the empty state.** Two compounding bugs: (1) `TrajectoryTable`'s widget treated any `AsyncValue` with no cached `.value` as "still loading", including a genuine `AsyncError`; rewritten as an exhaustive check over both the outer `AsyncValue` and the inner state. (2) The real root cause — a race between `build()`'s hardcoded placeholder return and a `ref.listen(..., fireImmediately: true)` callback that could fire *synchronously inside that same `build()` call*, correctly compute the empty state, and then have it silently overwritten back to the placeholder the moment `build()`'s own Future resolved. Fixed by deferring the write; added a regression test that forces the race and fails if the fix is reverted.
- **`home_vm.dart`/`shot_details_vm.dart` ran their (expensive) ballistics calculation twice on every cold start** — `build()` computed the real result directly while a `fireImmediately` listener on the same underlying provider independently reacted to that provider's very first resolution, a latent instance of the same race above. Caught by a test asserting the fake ballistics service's call count. `home_vm.dart` redesigned so every dependency is `ref.watch`ed directly inside `build()` (Riverpod reruns `build()` itself once on change, instead of a manual listener racing a direct computation); `GeneralSettings` keeps its existing "skip irrelevant changes" optimization via `ref.listen` + `ref.invalidateSelf()` rather than a direct state write. `shot_details_vm.dart` got the smaller fix: its `shotContextProvider` listener was the only one of its three missing the `prev != null` guard the other two already had.
- **Home/Tables/Shot Details silently showed stale or wrong output for a profile missing a weapon or sight, instead of an empty state.** `Profile.isReadyForCalculation` only ever checked the ammo; a missing sight's height defaults to `0` and still "calculates" against that bogus value instead of failing loudly, and a missing weapon was never checked at all. Now requires the weapon and sight to actually be selected too. A new `missingProfileDataType()` helper resolves the *specific* reason (weapon/ammo/sight) so Home, Tables (both tabs), and Shot Details each show the right empty-state message instead of a generic/wrong one, or in Tables' Trajectory tab's case, an indefinite loading spinner (its error handling only wrapped the ballistics call itself, not the earlier readiness checks) or, in the Details tab's case, no empty-state check at all.
- **`EmptyStateType` messages were hardcoded English, not localized**, and had no message for an incomplete weapon (only ammo). Added the missing `incompleteWeapon` case and localized all 6 messages (both languages).
- **Broken "Select cartridge/bullet from collection" routes** — `Routes.cartridgeCollection`/`bulletCollection` pointed at paths nested under `ammo-create`, but the routes themselves were registered as siblings in `router.dart`'s route tree, so tapping either action threw `GoException: no routes for location: ...`. Routes are now correctly nested under `ammo-create`, matching the equivalent `sight-create`/`collection` pattern.
- **Crash on bare `/`** — no route existed for the app's root path, so any navigation that landed on `/` (e.g. loading the web build at its bare domain) threw `GoException: no routes for location: /`. Added a redirect to `Routes.home`.
- **Ammo/bullet collection cards** — card content appeared shifted/misaligned compared to the weapon/sight collection cards. `CollectionAmmoTileBody` used a `Wrap` plus an extra `Expanded` wrapper plus explicit `TextOverflow.visible` that the (working) weapon/sight tile bodies don't use; normalized to the same `Row`-based layout.

### Removed
- `packages/ebalistyka_db/` local package (ObjectBox entities + old ZIP+JSON `.ebcp` DTOs — superseded by `packages/ebc_db`)
- `packages/a7p/` local package (superseded by `a7p` on pub.dev)
- `generate-a7p` Makefile target (protobuf bindings now ship inside the `a7p` package itself)
- `packages/bclibc_ffi/` local package (superseded by `dart_bclibc` on pub.dev)
- `external/bclibc` git submodule and `.gitmodules`
- `flatpak/modules/bclibc.yml` Flatpak module
- `ffigen` Makefile target
- `--recurse-submodules` from all CI `git clone` / `actions/checkout` steps


## v0.1.18 (2026-06-26)

## Changed
- Updated flutpak to version v0.8.2
- Updated bclibc to version v1.1.4\n- Updated Flutter to version 3.44.4


## v0.1.17 (2026-06-05)

### Fixed
- **Sight line look angle** — sight line on the trajectory chart now correctly follows the look angle (`h = d × tan(θ)`); previously always drawn horizontally at h = 0

### Changed
- **Flutter** — default version bumped to 3.44.1 across all workflows and in `flatpak/flutter.version`
- **build-flatpak.yml** - removed checkout step
- `packages/bclibc_ffi` (`calculator.dart`): `Calculator._toBcShotProps()` replaced with thin field mapper `_toBcShot()` — Coriolis trig (`_toCoriolis`: sin/cos lat/az, range/cross offsets) and atmosphere density (`_toAtmo`) removed from Dart; all physics conversion delegated to `BCLIBC_Shot::to_shot_props()` in C++ (Step 3a of bclibc-wrapper-consolidation)
- `packages/bclibc_ffi` (`bclibc_ffi.dart`): added `BcShot` Dart value class, `_FillNativeShot` extension, and `BcLibC.*Shot()` API methods (`findApexShot`, `findMaxRangeShot`, `findZeroAngleShot`, `integrateShot`, `integrateAtShot`)
- `packages/bclibc_ffi` (`bclibc_bindings.g.dart`): added `BCShot` native struct and `BCLIBCFFI_*_shot` lookup bindings (manually updated; regenerate with `dart run ffigen --config ffigen.yaml` after building bclibc)
- `external/bclibc` submodule bumped to `caf42e0` — adds `BCShot` C struct and `BCLIBCFFI_*_shot()` entry points to `bclibc_ffi.h`; `BcShotProps` / `BCLIBCFFI_*` retained for backwards compatibility; `Vacuum` handled correctly (`pressure_hpa == 0` → zero density, no drag)
- Update `update_sheet.dart` and `update_checker.dart`
  - Add `winget` installer detection, and display command to get app update


## v0.1.16 (2026-05-26)

### Changed
- **App repo name** — slug changed from `o-murphy/ebalistyka-app` to `o-murphy/ebalistyka` to unify the app ID across all packaging formats; updated `repoSlug` constant in `lib/shared/constants/app_info.dart` and all workflow / CHANGELOG links
- **Flutter** — default version bumped to 3.44.0 across all workflows
- **flutpak** — bumped to `v0.4.0-rc.2`; generates Flathub-compatible manifest and `generated-sources.json`; icon config in `pubspec.yaml` updated to reference `app/share/icons/` at all sizes (16 → 1024 px)
- **App icons** — regenerated; icon and shared assets (`metainfo`, `desktop`, icons) moved to `app/share/` and reused across all packaging tools (AUR, deb, RPM, AppImage, Flatpak, Snap); Android launcher icons, Android/iOS/macOS/web splash images all regenerated from the new source
- **objectbox** — `objectbox_flutter_libs` bumped to 5.3.2; Flatpak manifest, patch, and flutpak config updated accordingly; CRLF line endings in the 5.3.2 pub.dev archive handled via `strip_trailing_cr: true` (injects a `sed -i 's/\r//'` step before patching)

### Added
- **`app/share/`** — canonical location for FreeDesktop assets shared by all packaging formats:
  - `app/share/applications/io.github.o_murphy.ebalistyka.desktop` (moved from `flatpak/`)
  - `app/share/metainfo/io.github.o_murphy.ebalistyka.metainfo.xml` (moved from `flatpak/` and `aur/`)
  - `app/share/icons/hicolor/{16,32,64,128,256,512,1024}x.../io.github.o_murphy.ebalistyka.png`
- **`scripts/ci-common.sh`** — shared CI helpers: `set_build_metadata`, `set_arch_suffix`, artifact-name derivation; sourced by all build workflows
- **`scripts/copy-icons.sh`** — copies icons from `app/share/icons/` into package staging directories; eliminates duplicate icon copies in `aur/`, `deb/`, etc.
- **`scripts/package-flatpak.sh`** — new Flatpak packaging script exposing reusable shell functions (`install_flatpak_builder`, `lint_flatpak_manifest`, `lint_flatpak_repo`, `export_flatpak_bundle`) and a `local_build` entry point for full local reproduce of the CI pipeline
- **`flatpak/flathub.json`** — Flathub submission metadata
- **`flatpak/patches/flutter/shared.sh.patch`** — Flutter SDK patch applied by `flatpak-builder` at build time
- **`flatpak/.gitignore`** — ignores `flatpak/generated/` and `builddir/`/`repo/` build artifacts

### Removed
- **`scripts/build-android-aab.sh`** — merged into `build-android.sh` (`--target aab|apk`)
- **`scripts/setup-linux-deps.sh`** — no longer needed; deps handled per-workflow
- **`scripts/update-flathub.sh`**, **`scripts/update-sources.sh`** — replaced by `flutpak generate`
- **`flatpak/generated-sources.json`** — now generated at build time by `flutpak generate`; not committed
- **`flatpak/io.github.o_murphy.ebalistyka.metainfo.xml`** — canonical copy moved to `app/share/metainfo/`
- **`aur/ebalistyka.desktop`**, **`aur/icon.png`**, **`aur/io.github.o_murphy.ebalistyka.metainfo.xml`** — assets now sourced from `app/share/`

### Packaging layout
- `aur/`, `deb/`, `rpm/`, `snap/`, `winget/` file trees moved under `packaging/` (e.g. `packaging/aur/PKGBUILD`, `packaging/snap/snapcraft.yaml`, `packaging/winget/*.yaml`)
- All packaging scripts updated to pull icons and metadata from `app/share/` instead of format-specific copies

### CI / Distribution
- **Android** — `build-aab.yml` + `build-apk.yml` merged into `build-android.yml`; target selected via `--target aab|apk` flag in `scripts/build-android.sh`
- **Linux packages** — `build-appimage.yml` renamed to `build-linux-package.yml`; `build-deb.yml` and `build-rpm.yml` folded in as matrix jobs; reduces workflow count and consolidates Linux packaging triggers
- **Flatpak** — reworked CI using `o-murphy/flutpak` composite actions:
  - `generate` job separated from `build` job; manifest + sources uploaded as artifact and shared between matrix `build` jobs
  - `build` job uses `o-murphy/flutpak/.github/actions/build-flatpak@…` composite action (no more inline `--privileged` container); supports amd64 + arm64 matrix on every PR
  - `download-artifact` upgraded `@v4 → @v8`; `upload-artifact` upgraded `@v4 → @v7`
  - Artifact names include arch suffix to avoid collision when triggered via `workflow_call`
  - Flatpak release publishing temporarily disabled until pipeline is fully verified
- **`pin-flatpak-manifest.yml`** — deleted; manifest generation is now fully automated by `flutpak generate`
- **`publish-flathub.yml`** — updated to use `flutpak generate`; no longer commits `generated-sources.json`
- **PR summary** — replaced per-workflow inline summary scripts with a shared `.github/actions/pr-summary` composite action
- **`release.yml`** — reworked to call `build-android.yml`, `build-linux-package.yml`, `build-flatpak.yml`, `build-snap.yml`, `build-portable.yml` as `workflow_call` with consistent `arch`/`tag`/`retention_days` inputs

### Fixed
- **Flatpak — objectbox 5.3.2 patch** — `objectbox_flutter_libs` 5.3.2 ships `linux/CMakeLists.txt` with CRLF line endings; `patch(1)` failed even with `--ignore-whitespace`; fixed by using `strip_trailing_cr: true` in the flutpak config, which strips `\r` via `sed` before applying the patch
- **Flatpak — correct HEAD SHA in PR builds** — use `github.event.pull_request.head.sha` instead of `github.sha` (which points to the synthetic merge commit) so `flutpak generate --commit` pins the actual feature branch tip
- **Flatpak — artifact name collision** — `workflow_call` from `release.yml` now passes `arch` to `build-flatpak.yml`; artifact name includes arch suffix, preventing overwrite when both amd64 and arm64 are built
- **Flatpak local build — `dbus-run-session` conflict** — `_dbus_run` helper skips `dbus-run-session` when `DBUS_SESSION_BUS_ADDRESS` is already set (desktop session), preventing FUSE document-portal mount conflict
- **Flatpak local build — `FLATPAK_USER_DIR` in sandbox** — all `flatpak run org.flatpak.Builder` invocations now pass `--env=FLATPAK_USER_DIR=$HOME/.local/share/flatpak` so `flatpak-builder-lint` inside the sandbox finds the user-installed flathub remote instead of the empty per-app data dir
- **Flatpak local build — `rofiles-fuse` failure** — local `flatpak-builder` invocation uses `--disable-rofiles-fuse`; `flathub-build` wrapper does not support this flag and was replaced with a direct `flatpak run --command=flatpak-builder` call
- **Flatpak local build — non-fatal manifest lint** — manifest lint failure (e.g. flathub user refs not yet populated) prints a warning but does not abort the build; real manifest errors surface at `flatpak-builder` time
- **Flatpak local build — non-fatal repo lint** — repo lint failures (`appstream-external-screenshot-url`, `appstream-screenshots-not-mirrored-in-ostree`) are Flathub CDN requirements irrelevant for local dev builds; made non-fatal with a clear warning


## v0.1.15 (2026-05-19)
[![GitHub release][GitHubReleaseBadge]][v0.1.15]

### CI / Distribution
- **Flatpak** — Reworked CI builds: removed the need for `--privileged` containers, now building directly via `flatpak-builder --sandbox --user`; added amd64 + arm64 matrix builds for every PR
- **Flatpak** — `generated-sources.json` is now automatically generated and committed to `main` on every release tag (for Flathub)
- **Flatpak** — Added OARS rating and metadata required for Flathub submission
- **Snap** — Added amd64 + arm64 matrix builds for PR builds (same approach as Flatpak)
- **Winget** — Added publishing support for Windows Package Manager
- **AUR** — Fixed GPG signing in `publish-aur.yml`
- **CI** — Unified artifact retention period to 2 days; upgraded CI action versions


## v0.1.14 (2026-05-12)
[![GitHub release][GitHubReleaseBadge]][v0.1.14]

### Changed
- **flatpak publish** — publishing to self-hosted repo


## v0.1.13 (2026-05-11)
[![GitHub release][GitHubReleaseBadge]][v0.1.13]

### Changed
- **flatpak runtime** — bumped `org.gnome.Platform` from `49` to `50` (GNOME 49 is not actual for flathub in 2026)
- **file_picker updated** — upgraded to `file_picker@11.0.2`; uses XDG portal (`org.freedesktop.portal.FileChooser`) exclusively on Linux
- **flatpak manifest** — aligned icon filename and finish-args to be compatible with Flathub requirements

### Fixed
- **FilePicker API migration** — replaced broken `FilePicker.platform.*` calls with the static `FilePicker.*` API introduced in `file_picker@11.0.0` (`ebcp_service.dart`, `a7p_service.dart`)

### Removed
- **zenity workarounds** — removed; `file_picker@11.0.x` uses only the XDG portal backend, so zenity is no longer needed


## v0.1.12 (2026-05-07)
[![GitHub release][GitHubReleaseBadge]][v0.1.12]

### Changed
- **Publishng Flow** - publishing to Snapcraft and AUR


## v0.1.11-dev (2026-05-07)
[![GitHub release][GitHubReleaseBadge]][v0.1.11-dev]

## Added
- **Linux deb package** — `.deb` builds for x86_64 and arm64; installs to `/opt/ebalistyka/`; in-app update sheet detects deb install via `EBALISTYKA_INSTALLER=deb`
- **Linux rpm package** — `.rpm` builds for x86_64 and arm64; installs to `/opt/ebalistyka/`; in-app update sheet detects rpm install via `EBALISTYKA_INSTALLER=rpm`
- **Linux AUR package** — `ebalistyka-bin` PKGBUILD for Arch/Manjaro (`yay -S ebalistyka-bin`); installs to `/opt/ebalistyka/`; in-app update sheet detects AUR install via `EBALISTYKA_INSTALLER=aur`


## v0.1.10-dev (2026-05-07)
[![GitHub release][GitHubReleaseBadge]][v0.1.10-dev]

### Added
- **Linux Snap package** — `.snap` builds for x86_64 and arm64; published to Snap Store on release (`stable` / `beta` channel); auto-updates via Snap Store; in-app update sheet links to Snap Store for snap installs
- **Linux Flatpak package** — `.flatpak` builds for x86_64 and arm64; in-app update sheet detects Flatpak sandbox via `FLATPAK_ID`


## v0.1.9-dev (2026-05-06)
[![GitHub release][GitHubReleaseBadge]][v0.1.9-dev]

### Added
- **Android OTA update** — sideload APK updates directly from GitHub Releases without opening the browser
  - Detects the correct ABI-specific APK (`arm64`, `armeabi-v7a`, `x86_64`) via `Abi.current()`; falls back to universal APK, then "View Release" if no APK asset is found
  - Download progress bar and installing state shown in the update bottom sheet
  - Cancel always available — dismissing the sheet cancels the download
- **Help dialogs** - reusable markdown-based help dialogs
  - Added help dialogs for screens: `shot info`, `my profiles`
  - Added help dialogs for collection screens: `ammo`, `weapon` and `sights` collections
  - Added help dialogs for user's data screens: `my ammo`, `my sights` screens
  - Added help dialogs for data table editor screens: `multi bc`, `custom drag` and `powder sensitivity`
  - Added help dialogs for wizard screens: `sight`, `weapon`, `ammo`

### Changed
- **Prerelease updates** — long-press "Check for updates" tile to search for prerelease builds; a warning sheet is shown before proceeding so the user acknowledges the risk
- **Help button icon** - changed help button icon
- **ReticleView refactor** — extracted `_ReticleGeometry`, `_ReticleComposer`, `_ReticleStack` as standalone classes; `showAdjLines` is now non-nullable (`bool`, default `true`); `geometry.targetScale()` used for target scaling
- **Code Quality #15 — naming convention sweep** across 14 screen/widget files:
  - `_buildXxx()` builder methods extracted as standalone `_PascalCase` widget classes (`_ReticleStack`, `_TopBlock`, `_AnglesInfoTile`, `_SideControlFab`, `_AdjustmentsDisplayEmpty`, `_BcText` etc.)
  - `nameCtrl`/`vendorCtrl` → `nameController`/`vendorController` in `WizardFormMixin` and all wizard screens
  - Event handler callbacks renamed to `_onXxx` pattern (`_onDragTableTap`, `_onPowderSensTableTap`, `_onImportFromFile`, `_onAddTap`)
  - `// ── Widgets ──` section separator added to 5 files missing it
  - Hard-coded `'Ammo image'` → `l10n.ammoImage` (new l10n key EN/UK)


## v0.1.8 (2026-05-04)
[![GitHub release][GitHubReleaseBadge]][v0.1.8]

### Fixed
- **Update checker** - Fixed version comparison logic that prevented users from seeing stable updates when a pre‑release existed
  - Now correctly identifies the latest stable version instead of just the newest release by date
  - Pre‑release versions are ignored in release builds (only shown in debug mode)
  - Improved semantic version parsing and comparison
  - Check and save app version to detect first app run and app update events
- **toEbcp** - unhandled error if state is unmounted
- **TrajectoryTablesViewModel._rebuild** - is `ref.mounted` protector
- **Resolve system locale on first start** - fixed resolver and added unittests

### Added
- **APMR-FFP-IR-MIL reticle** - New pattern for ARGOS Sight
- **Localization** - Added `l10n` support for unit symbols across multiple components
  - New ARB key: `columnElevation`
  - `UnitPickerButton` - Now uses `.localizedSymbol` for localized unit display
  - `buildHomeTable` - Unit symbols are properly localized via `.localizedSymbol`
  - `HomeScreen` - `FormattedTableData` displays localized unit symbols
  - `UnitFormatterImpl.time` - Time units now respect the current locale
- **Help dialogs** - reusable markdown based help dialog
  - Added help dalogs for screens: home, conditions, tables, convertors, settings, retilcle view

### Changed
- **UnitPickerButton** - Replaced `InkWell` with `TextButton` for better accessibility and Material Design compliance
- **Updated `_buildHomeTable` tests** - To match new behaviour
- **Adjustment messages helpers** - For HomeScreen ReticlePage and ReticleViewScreen


## v0.1.7 (2026-04-30)
[![GitHub release][GitHubReleaseBadge]][v0.1.7]

### Fixed
- **AmmoWizardScreen Hotfix** - AmmoWizardScreen arguments and it's `state.extra` atributes

### Changed
- **Improved ReticleView Holdovers Highlight** — much more readable holdovers overlays
- **Optimized Reticles generator** — uses `stroke-dasharray` for dashed lines instead of Path's
- **Reticle/Target picker screen layout** — uses grid layout with wrap for high-dpi devices


## v0.1.6 (2026-04-30)
[![GitHub release][GitHubReleaseBadge]][v0.1.6]

### Added

- **Wind indicator — tap-to-set animation** — tapping anywhere on the ring animates the marker along the shorter arc to the tapped position (`easeOutCubic`, 380 ms) then commits; drag continues to follow the finger instantly; double-tap resets to North (0°); uses `Listener.onPointerDown` for zero-latency response (avoids GestureDetector disambiguation delay)
- **`UnitDialogInputField.autofocus` parameter** — exposes autofocus as an optional parameter (default `true`); `UnitHybridPicker` passes `autofocus: isDesktop` so the keyboard does not auto-open on mobile when the hybrid picker dialog is shown
- **`isDesktop` helper** — migrated from `dart:io` `Platform` checks to `defaultTargetPlatform` (no native-platform dependency, works in tests)
- **Quick-action long-press reset** — long-pressing the Wind Speed or Look Angle button in `QuickActionsPanel` resets the value to 0 and shows a snackbar confirmation; `windSpeedWasReset` / `lookAngleWasReset` l10n keys added (EN + UA)
- **Filter panel** — `My Ammo`, `My Weapon`, and `My Sight` screens now have a working filter button; bottom sheet with `ExpansionTile` sections per category; vendor multi-select with item-count badges; caliber multi-select (ammo); focal-plane toggle (sight); weight range via `UnitConstrainedInputField` (ammo min/max); filter badge shows active state; filter state persisted in `AmmoFilterNotifier` / `SightFilterNotifier` / `WeaponFilterNotifier`; same filter panel wired to collection screens

### Fixed

- **Collection update checker** — on startup checks the cached collection SHA against the latest GitHub commit (throttled to once per 24 h); Settings → Collection shows current SHA (7 chars) and a manual "Update collection" button; downloaded collection is cached to disk alongside the ObjectBox files; `builtinCollectionProvider` prefers the cached file, falls back to the bundled asset on load failure
- **Caliber mismatch action sheet** — when selecting or editing ammo whose caliber differs from the active weapon, an action sheet blocks the operation and offers two choices: update ammo caliber to match the weapon, or update the weapon caliber to match the ammo; dismissing without choosing leaves both unchanged and does not apply the ammo
- **Collection update error propagation** — `_fetchLatestCollectionCommit` now throws on non-200 HTTP status instead of silently returning `null` (previously treated as "up to date"); manual check in Settings now shows the actual network error in a snackbar
- **Caliber mismatch not triggered on ammo select** — `onSelect` in `MyAmmoScreen` previously had no caliber check at all; mismatch action sheet is now shown before the ammo is applied
- **Caliber mismatch not triggered on ammo edit** — `onEdit` previously passed the ammo's own caliber as the weapon reference caliber, so the mismatch check always exited early; now correctly passes the weapon's caliber
- **Filter state `copyWith`** — `AmmoFilterState`, `SightFilterState`, and `WeaponFilterState` now expose `copyWith`; notifier mutation methods use it instead of repeating all fields
- **Filter sheet `draftIsDefault` check** — caliber comparison now uses `setEquals` instead of `==` so `Set<double>` equality is correctly detected

### Changed

- **Seed profile data** — default profile updated: weapon → Cadex Defence Kraken CDX-MC (.338 LM, 9.5″ twist, 26″ barrel), ammo → Hornady 285 GR ELD-M (G7 BC 0.397, MV 827 m/s), sight → Nightforce ATACR 7-35×56 F1 (0.1 MIL clicks)


## v0.1.5 (2026-04-29)
[![GitHub release][GitHubReleaseBadge]][v0.1.5]

### Added

- **In-app update checker** — on startup checks GitHub Releases (at most once per 24 h); shows a bottom sheet with "View" button if a newer version is available; manual check available in Settings → About; `INTERNET` permission added to `AndroidManifest.xml`

### Fixed

- **CI — version not passed to `flutter build apk`** — `--build-name` and `--build-number` flags now explicitly passed; `flutter pub get` moved after `pubspec.yaml` version patch in all workflows (`build.yml`, `build-apk.yml`) so Flutter sees the correct version before dependency resolution
- **CI — build number consistency** — `git rev-list --count` changed to `--first-parent` across all workflows to exclude merge commits from feature branches

### Removed

- **`desktop_updater` dependency** — removed; package does not support GitHub Releases artifacts (MSIX / tar.gz / AppImage / APK)

---

## v0.1.4 (2026-04-28)
[![GitHub release][GitHubReleaseBadge]][v0.1.4]

### Fixed

- **Unit symbols — full audit** — all remaining `unit.symbol`/`unit.label` call sites replaced with `localizedSymbol(l10n)`/`localizedLabel(l10n)` across 22+ files; new ARB keys: `unitSecondSym` (`s`/`с`), `sgAbbr` (`Sg`/`ФГС`), `nClicks` (ICU plural: `click`/`clicks`, `клік`/`кліка`/`кліків`)
- **`AdjustmentDisplayPanel`** — click values pluralized via `nClicks(count)`; Sg abbreviation localized
- **`AdjustmentInputWithClicks`** — click suffix pluralizes reactively on keystroke
- **Ukrainian `unitCmPer100mSym`** — `"cm/100m"` → `"см/100м"`
- **Android keyboard overlap** — `resizeToAvoidBottomInset: false` on `_ScaffoldWithNav`; keyboard overlays shell content instead of shrinking it; sub-screens (`BaseScreen`) retain default `true`
- **Desktop window size** — removed erroneous `* devicePixelRatio` multiplication; `window_manager` takes logical pixels, not physical; window now opens at correct `375×812` logical size


## v0.1.3 (2026-04-28)
[![GitHub release][GitHubReleaseBadge]][v0.1.3]

### Added

- **Localization (EN/UA) — full pass** — ARB pipeline; ~375 keys, EN = UK in sync; all screens covered: settings, convertors, conditions, tables, home, shot details, profiles, ammo/weapon/sight wizards, collection tiles, reticle view screen, unit pickers; `Unit.localizedLabel/Symbol(l10n)` extension + 34 `unitXxxSym` ARB keys; `UnitFormatterImpl` takes `AppLocalizations`; all formatted values and unit symbols localized

### Changed

- **Navigation bar labels** — `NavigationBarTheme` with `fontSize: 11` + `TextOverflow.ellipsis` for long localized labels
- **Home screen** — condition indicators, page labels, wind direction display prettified

### Fixed

- **A7P zero offset export** — offset now correctly converted to cm/100m before dividing by click size (previously multiplied)
- **A7P zero offset import** — removed erroneous offset reconstruction; a7p click counts carry no click-size metadata
- **Wheel picker `-0.0`** — `formatDisplayValue` normalises IEEE 754 negative zero before `toStringAsFixed`
- **Built-in collection** — fix sight heights
- **Settings screen** — fix sight height unit picker

### Refactored

- **Code quality — converter generalization** (#7.1 #1–2) — `SimpleConvertorVm` base + `SimpleConvertorScreen`; 5 VMs + 5 screens unified; ~870 LOC removed
- **Code quality — table editor generalization** (#7.1 #3) — `TwoColumnTableEditorScreen` generic widget; multi-BC + powder sens editors unified; ~545 LOC removed
- **Code quality — wizard deduplication** (#7.1 #4) — `WizardActionBar`, `WizardNameField`, `WizardFormMixin`; applied to all 3 wizard screens; ~155 LOC removed
- **Code quality — `home_vm.dart` split** (#7.1 #5) — `home_ui_state.dart` + `home_builders.dart` extracted; notifier reduced to orchestration only
- **Code quality — `ammo_wizard_screen.dart` split** (#7.1 #6) — `ammo_wizard_parsers.dart` + `AmmoWizardNotifier`; 30 `setState` removed; 77 new tests
- **Code quality — `profile_card.dart` split** (#7.1 #7) — `ProfileControlTile`, `ProfileWeaponSection`, `ProfileAmmoSection`, `ProfileSightSection` extracted; 504 → 145 lines
- **Code quality — dialog/snackbar helpers** (#7.1 #8) — `showFeedback()` helper; 4 inline `showSnackBar` calls replaced
- **Code quality — UI constants + dividers** (#7.1 #9) — `ui_dimensions.dart`; `TileDivider`/`SectionDivider` widgets; 47 inline `Divider` calls replaced
- **Code quality — asset picker generalization** (#7.1 #10) — `SvgAssetPickerScreen<T>` generic; pickers as 22-line wrappers
- **Code quality — wizard notifiers** (#7.1 #11) — `WeaponWizardNotifier` + `SightWizardNotifier`; all `setState` removed from both screens
- **Code quality — `AdjustmentsDisplayPanel` disabled state** (#7.1 #12) — `_buildEmpty` implemented; test updated
- **Code quality — standalone widget extraction** (#7.1 #13) — `_BcSection` + `_DragModelSection` replace builder methods in `ammo_wizard_screen.dart`
- **Unit picker** — `UnitPickerTile` and `UnitPickerButton` share reusable `showUnitPicker`


## v0.1.2 (2026-04-26)
[![GitHub release][GitHubReleaseBadge]][v0.1.2]

### Added

#### Android
- Initial Android support — application builds and runs on Android
- CI integration for Android builds, including FFI and submodules
- File import support via `file_picker` with Android fallback (`FileType.any`)
- FileProvider configuration for `share_plus`
- `<queries>` configuration for `file_picker` and `url_launcher` (Android 11+)

#### CI / Build
- Reusable `build-apk.yml` workflow:
  - supports `workflow_call`
  - accepts `build_name`, `build_type`, `retention_days`
  - supports signing via secrets
- `scripts/build-android.sh`:
  - sets app version from CI
  - decodes keystore from `ANDROID_KEYSTORE_BASE64`
  - builds split-per-ABI APKs
  - outputs artifacts to `artifacts/`
- `scripts/generate-android-keystore.sh`:
  - generates JKS keystore
  - creates `android/key.properties`
  - exports base64 + metadata to `certs/`

### Changed

#### Android
- Impeller renderer disabled (`EnableImpeller=false`) due to incorrect SVG circle tessellation (temporary workaround until upstream fix)
- `AndroidManifest.xml` updated:
  - added storage permissions (`READ_EXTERNAL_STORAGE`, `READ_MEDIA_*`)
  - enabled `requestLegacyExternalStorage`
  - added URL visibility queries (`http`, `https`)

#### CI / Build
- `release.yml` now uses reusable `build-apk.yml` instead of inline Android job
- APK files (`*.apk`) are now included as release assets
- `build.gradle.kts`:
  - reads signing config from `android/key.properties`
  - falls back to debug signing if missing
- Reusable `pr-summary.yml` workflow — posts/updates per-platform build result comment on PRs; replaces duplicated inline scripts in `build-apk.yml`, `build-exe.yml`, `build-appimage.yml`
- PR artifact links now use `upload-artifact@v4` direct URL instead of a generic run page link
- Version resolution unified across all workflows via `.github/actions/version`:
  - tag builds → version from tag
  - PR / `workflow_dispatch` → base version from `pubspec.yaml` (no suffix)
- `build-apk.yml`: added `prepare-version` job for direct PR and dispatch triggers (previously fell back to hardcoded `0.1.0-dev`)
- MSIX version revision set to `0` for release tags (`v*.*.*`, `v*.*.*-*`) per Microsoft Store requirement; non-release builds keep `run_number` as revision

#### Reticle gen
- Updated reticles generator

### Fixed

#### UI
- Window scaling now respects system scale on startup
- Fixed `RenderFlex` overflow on Home screen
- Fixed `PageDotsIndicator` overflow (tap target size mismatch)
- `AdjustmentDisplay` now correctly applies zero offsets and adjustments

#### SVG / Rendering
- Fixed SVG circles rendered as polygons:
  - `reticle_gen` now uses `<circle>` instead of arc `<path>`
  - regenerated all reticle and target assets

#### Navigation
- Fixed missing `await` in `HomeScreen → AmmoWizard` route

#### Code Quality
- Enabled `discarded_futures: true`
- Fixed all related lint issues

### Reliability
- Improved database resilience:
  - ObjectBox open failure is now handled
  - corrupted `data.mdb` / `lock.mdb` are deleted automatically
  - store is reinitialized safely
  - user is notified via SnackBar only if data previously existed

### Docs
- README updated:
  - added **Android notes** section
  - documented Impeller workaround
  - documented file import limitations on Android


## v0.1.1 (2026-04-23)
[![GitHub release][GitHubReleaseBadge]][v0.1.1]

### CI / Build
- **Release workflow** — single `release.yml` triggers on `v*.*.*` tags; builds all platforms in parallel, publishes GitHub Release with all assets; manual dispatch supported for dry-run asset listing
- **Reusable `version` action** — `.github/actions/version` extracts semver from tag or returns default; replaces duplicated `prepare-version` logic across all workflows
- **Consistent artifact naming** — all distributables follow `ebalistyka_<platform>_<arch>.<ext>` without version or build number in the filename (predictable URLs for auto-update)
- **Version propagation** — CI writes `version: X.Y.Z+<run_number>` into `pubspec.yaml` before build; app settings and MSIX version stay in sync automatically
- **MSIX signing** — self-signed certificate stored as `CERTIFICATE_BASE64` / `CERTIFICATE_PASSWORD` repo secrets; imported non-interactively before packaging; `install_certificate: false` in pubspec suppresses msix tool prompt
- **MSIX auto-update** — `.appinstaller` generated alongside `.msix`; points to `releases/latest/download/` so Windows checks for updates on each launch
- **Linux AppImage zsync** — `--updateinformation` embedded in AppImage; `.AppImage.zsync` generated via `zsyncmake`; enables AppImageUpdate / zsync2 delta updates from GitHub Releases
- **Portable archives** — Linux bundle → `artifacts/portable/*.tar.gz`; Windows bundle → `artifacts/portable/*.zip`; AppImage → `artifacts/appimage/`; MSIX → `artifacts/msix/`


## v0.1.0+9 (2026-04-23)
[![GitHub release][GitHubReleaseBadge]][v0.1.0+9]

### Fixed
- **Settings notifier** now works immediatelly
- **Adjustment display panel** sizing and placing, text size clamp
- **Conditions screen icon**
- **Reticle view display ratio**

### Changed
- **Max window size** limitations are disabled 

### Features
- **Improve home screen** condition indicators got text labels 
- **Improve home paging** pages got text labels 
- **Display adjustments in current clicks** on home screen, tables screen, html report and reticle view screen


## v0.1.0+8 (2026-04-23)
[![GitHub release][GitHubReleaseBadge]][v0.1.0+8]

### Fixed
- **Hotfix:** corrected twist rate validation — the field now accepts `0` as a valid value.


## v0.1.0+7 (2026-04-22)
[![GitHub release][GitHubReleaseBadge]][v0.1.0+7]

### Architecture
- **Removed `recalc_coordinator`:** widgets now listen directly to ObjectBox streams via providers

### Changed
- **Complete CRUD UI:** users can now create and manage ballistic data
- **A7P as a local package:** serializer moved to `packages/a7p`
  
### Added
- **Reticle generator CLI:** generates compatible reticles and target SVG images
- **App launcher icons and splash screen**

### Features
- **Export / Import:** supports native and `.A7P` formats
- **Reticles screen:** reticle view and adjustment management
- **Unit converters:** fully implemented across all supported dimensions

### Fixed
- **Twist and wind direction handling**

### Docs
- **Backlog:** updated documentation
- **Timeline docs:** updated with time-based versioning


## v0.1.0-alpha (2026-04-12)
[![GitHub release][GitHubReleaseBadge]][v0.1.0-alpha]

Initial alpha release — first functional build of the ballistic trajectory calculator.

### Architecture
- **ObjectBox migration:** full replacement of JSON storage with a reactive ObjectBox database (entities, relations, streams)
- **`bclibc` as a local package:** C++ ballistic solver moved to `packages/bclibc_ffi` (v1.0.3)
- **Reactive providers:** rebuilt on ObjectBox watch streams; DB updates trigger automatic UI refresh
- **Zero key caching:** zeroing phase skipped when inputs remain unchanged
- **Typed extensions:** raw entity fields replaced with type-safe accessors

### Features
- **Profiles screen:** PageView with profile cards; create, rename, duplicate, delete; active profile pinned first
- **Profile card:** weapon / ammo / sight sections with inline editing; `IncompleteBanner` for missing data
- **Weapon wizard:** create/edit weapons with caliber, twist, barrel length; supports presets
- **Sight wizard:** full configuration (FFP/SFP/LWIR, mount parameters, click values, magnification range)
- **Ammo & sight selection:** per-profile selection or creation
- **Built-in collection:** calibers, weapons, cartridges, projectiles, sights (`collection.json`)
- **Unit converters:** implemented — length, weight, pressure, temperature, torque, angular
- **Generic converter field:** reusable real-time dual-input conversion widget
- **Dimension factory constructors:** type-safe constructors for all unit dimensions

### Fixed
- Profile ordering (active profile always first)
- Ammo selection filtering and sorting
- Immediate application of table settings
- Duplication logic for profiles, ammo, and sights; weapon seed deduplication
- Correct Coriolis force application
- Improved home screen accuracy (holdover, windage)
- Home table hold value issue
- Wizard form validation (touched-flag pattern)
- Twist direction icon display
- Shot details table values

### CI / Build
- GitHub Actions: Linux AppImage and Windows EXE builds on PR
- Reusable `build.yml` with platform/arch/build-type matrix
- Pre-build setup: submodule initialization and FFI bindings generation

### Docs
- `README.md`: badges, screenshots, feature overview, build instructions, dependencies
- `LICENSE`: GPL-3.0
- `OBJECTBOX_MIGRATION.md`: migration details


[Unreleased]: https://github.com/o-murphy/ebalistyka/compare/v0.1.18..HEAD
[v0.1.18]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.18
[v0.1.17]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.17
[v0.1.16]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.16
[v0.1.15]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.15
[v0.1.14]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.14
[v0.1.13]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.13
[v0.1.12]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.12
[v0.1.11-dev]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.11-dev
[v0.1.10-dev]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.10-dev
[v0.1.9-dev]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.9-dev
[v0.1.8]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.8
[v0.1.7]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.7
[v0.1.6]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.6
[v0.1.5]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.5
[v0.1.4]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.4
[v0.1.3]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.3
[v0.1.2]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.2
[v0.1.1]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.1
[v0.1.0+9]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.0+9
[v0.1.0+8]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.0+8
[v0.1.0+7]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.0+7
[v0.1.0-alpha]: https://github.com/o-murphy/ebalistyka/releases/tag/v0.1.0-alpha

[GitHubFav]: https://github.githubassets.com/favicons/favicon-dark.svg
[GitHubBadge]: https://img.shields.io/badge/GitHub-grey?logo=github
[GitHubCompareBadge]: https://img.shields.io/badge/GitHub-compare-grey?logo=github&color=orange
[GitHubReleaseBadge]: https://img.shields.io/badge/GitHub-release-grey?logo=github&color=green
