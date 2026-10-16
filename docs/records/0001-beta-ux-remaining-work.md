# Beta UX — remaining work

**Status:** In progress

Carried over from `docs/backlogs/7.BETA_UX.md` (pre-existing, unchanged) —
this record tracks only what's still open there, not the parts already
shipped:

Checked against current code (2026-10-13).

## Done since this record was written

- Display / entry of corrections in clicks (Home AdjPanel, Tables, HTML
  report, ReticleView, AmmoWizard) — `CHANGELOG.md`, `7.BETA_UX.md`.
- `ammo.zeroOffset` — UI in AmmoWizard (`OffsetsEdit`, X/Y + units).
- Filter panel — `filter_sheet.dart` for Weapon/Ammo/Sight and their
  collections.
- Legal links — Privacy Policy, Terms of Use and Changelog are in Settings
  (`privacyPolicyUrl`, `tosUrl`, `changelogUrl`).
- CI smoke test with `xvfb-run` for the Linux package
  (`build-linux-package.yml`).
- Help screenshots for `ammoWizard` (all 7) — the rest moved to [0012].
- **Web beta** — see [0002]: import/export of profiles/backup/HTML report,
  collection cache, single active tab ([0011]), persistent-storage
  request, desktop-only PWA install offer, GitHub Pages deploy (manual,
  `scripts/build-web.sh` + `scripts/deploy-web.sh`).

## Dropped

- Help Overlay (coach marks) — dropped 2026-10-16. `MasterProject.md` §5.4
  planned an all-in-one overlay highlighting every key UI element, but
  `7.BETA_UX.md` already marks "Help Overlay" done as the per-screen help
  dialogs (? button in the AppBar), and the owner confirmed that is the help
  feature. No library was ever chosen and none is needed; what remains is
  refreshing the help content — see [0012].

## Still open

- Image picker / camera UI in wizard screens (Weapon, Sight, Ammo) —
  blocked on [0007]'s `entity.image` format decision (no `image_picker`
  dependency yet)
- Notepad — Note button on Home (currently `showNotAvailableSnackBar`);
  storage TBD
- Tools Screen — "More" button on Home (currently
  `showNotAvailableSnackBar`); composition TBD
- Custom drag function editor — `CustomDragTableEditorScreen` is still
  opened read-only (`router.dart` doesn't pass `readOnly: false`); full
  editing/validation/saving pending (low priority, UX needs rethink first)
- Help docs and the missing screenshots (`weaponWizard`, `sightWizard`,
  collection screens) — tracked in [0012]
- Platform builds & signing: Android APK, macOS, iOS, Windows
- Auto-update: Windows msix, macOS, Android Play Store, Linux
  Flatpak/deb/rpm/Winget (see [0008] for the Windows msix blocker
  specifically); iOS ships via App Store only, no sideload autoupdates.
  Web has no auto-update flow by design ("Download the app" instead).
- Database resilience — the "database was reset" snackbar is now localized
  (`databaseResetNotice`, 2026-10-16). Still open: a database that
  disappeared entirely (e.g. evicted by the browser) is re-seeded silently —
  not detectable reliably, since the browser clears all of the origin's
  storage (IndexedDB and `localStorage`) together, so a "was initialized"
  marker would be wiped as well
