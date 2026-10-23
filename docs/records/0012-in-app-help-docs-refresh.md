# In-app help docs — refresh before beta

**Status:** Implemented

Audit date: 2026-10-13. Supersedes the single bullet about stale help docs
in [0002] ("Open — Profiles UX (deferred)") — that item is now tracked here,
with the scope below.

## State

- `assets/markdown/{en,uk}/*.md` — 20 topics (`HelpData` ids in
  `lib/shared/widgets/help_dialog.dart`), all present in both locales,
  40 files in total. Every id has a `HelpAction`/`showHelpDialog` entry
  point.
- Last touched **2026-07-18**; 101 commits have landed since (v0.1.19 –
  v0.1.22 and the whole web effort), none of them reached the help docs.
- Screenshots exist for `ammoWizard` (7), `conditionsScreen`,
  `homeScreen`, `profilesScreen`, `reticleScreen`, `settingsScreen`,
  `tablesScreen`. Missing: `weaponWizard`, `sightWizard`, the three
  collection screens.

## Known divergences from the current app

| Topic | What the doc says | What the app does |
|---|---|---|
| `profilesScreen` | swipe between cards, dots indicator, bottom "Select" / "Go to calculations" bar | two tabs ("Profile" / "My profiles"), search, card list, FAB "+", check button to activate; menu: duplicate / export / rename / eject ammo / delete; replace weapon/ammo/sight not described |
| `settingsScreen` | "Backup": all profiles, cartridges, sights; one import | profiles + settings; import asks scope (one profile / settings only / everything) and which profiles; no "Collection", "Links" or "About" sections documented (collection version + update, GitHub / privacy / terms, version / update check / changelog) |
| `tablesScreen` | HTML export "as a file"; no column config | opens as a page in the browser (new tab on web); columns configurable (`tables_config_screen.dart`) |
| `homeScreen`, `firstRun` | not re-checked against current Home | profile bar with "…" menu, shortcut button, Note / More still stubs ([0005]) |
| web | nothing | "Download the app" link instead of update check; data lives in the browser (IndexedDB), so backups matter; no share sheet — export is a download |
| changelog items | — | zero-offset UI in AmmoWizard, collection filter sheets, click display, weapon hotswap, etc. (see `CHANGELOG.md` v0.1.19–0.1.22) |

Not yet compared line by line: `ammoWizard`, `conditionsScreen`,
`reticleScreen`, the convertors and editors topics. Treat the table above
as the minimum, not the full list.

## Plan

1. **Wait for the Profiles UX decisions** ([0002] "Profiles UX (deferred)":
   discoverability, one vs. two profile screens) — otherwise
   `profilesScreen` gets written twice. Everything else can start now.
2. **Audit the remaining topics** against the current screens and fill in
   this record's table.
3. **Screenshots.** Re-shoot stale ones and add the missing wizard /
   collection ones, both locales, light and dark where the doc shows
   both. The web build driven through Chrome DevTools Protocol works for
   this (1280×900 headless, Flutter semantics or raw mouse events) —
   reproducible, no device needed. Check that screenshots don't expose
   real personal data (default seed profile only).
4. **Rewrite**, `en` and `uk` together per topic, in this order by
   divergence: `profilesScreen`, `settingsScreen`, `tablesScreen`,
   `homeScreen`, then the wizards, then the rest.
5. Add a short **"Web version"** topic (or a section in `firstRun`):
   browser storage, back up via Settings → Backup, export is a download,
   "Download the app"; install as an app (desktop browsers offer it; on
   iOS manually via Share → Add to Home Screen, which also protects the
   data from WebKit's inactivity cleanup).

## Done when

- every `HelpData` topic was re-read against the screen it documents, in
  both locales;
- every screenshot referenced by a doc exists and matches the current UI;
- no doc mentions a control that doesn't exist (swipe/dots on Profiles,
  etc.);
- the web-specific differences are documented.

## Notes

- The help texts are also shipped to web as bundled assets; no
  web-specific build step is needed for them.
- Keep the help in sync going forward: when a screen's controls change,
  update its topic in the same change (suggest adding it to the PR
  checklist rather than another audit later).

## Update (2026-10-23): done

All 20 `HelpData` topics were re-read against the screens they document, in
both locales, and rewritten with the real control labels (`en` and `uk`
together). Screenshots were retaken from a release web build of this branch
in headless Chromium (377×848, dark theme, locale `en-US` / `uk-UA`, driven by
direct hash routes plus semantics clicks), so every image exists in both
languages and matches the current UI; the default seed profile is the only
data shown. Details:

- Rewritten: `profilesScreen`, `settingsScreen`, `tablesScreen`, `homeScreen`,
  `firstRun` (with the web note), `conditionsScreen`, `reticleScreen`, the
  three wizards, the three collections and the three table editors.
  `convertorsScreen` and the velocity convertor were updated; the angle and
  target-distance topics were checked against the screens and kept.
- New images: weapon/sight editor, profile list, collections, editors; the
  stale ammo-wizard crops were replaced by four full-screen shots.
- The web version is covered in `firstRun` and `settingsScreen` (data lives in
  the browser, back up via Export, install as an app, "Download the app").
- Found while comparing, fixed in code: hard-coded English in the Units
  screen title, the wizards' "Name is required", the ammo wizard's "Required",
  "Single/Multi-BC mode", "N measurements/breakpoints"; the pressure
  convertor default (1013 was stored as mmHg and showed 1351 hPa); the
  ultra-long A7P range is 100–2185 m, not 2000.
- Fixed on the owner's call (2026-10-23): a **new** cartridge started with a
  vertical and horizontal zero offset of **0.10 MIL** instead of 0
  (`AmmoWizardState` / `AmmoWizardFormState` defaults); it now starts at 0.
- Still open: the custom drag table screen is view-only (see [0001]).
- Keep it in sync: when a screen's controls change, update its topic in the
  same change.
