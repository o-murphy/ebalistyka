# In-app help docs — refresh before beta

**Status:** Proposed

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
