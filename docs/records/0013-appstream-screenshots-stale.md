# AppStream metainfo screenshots point at the v0.1.16 tag

**Status:** Proposed

`app/share/metainfo/io.github.o_murphy.ebalistyka.metainfo.xml` lists five
screenshots as `https://raw.githubusercontent.com/o-murphy/ebalistyka/v0.1.16/docs/screenshots/<name>.png`
(`home`, `conditions`, `tables_trajectory`, `tables_details`, `convertors`).
That is the UI of v0.1.16 — before the protobuf storage, the Profiles tabs,
the bundled fonts and the arrow icons — and it is what Flathub / GNOME
Software / KDE Discover show.

Why it is still open: AppStore screenshot URLs have to be stable, so they are
pinned to a tag, and the refreshed images only exist on `platform/web`
(2026-10-23), not in any tag yet.

## To do after the next release tag

1. Retake the five images listed above in `docs/screenshots/`. Already
   refreshed on 2026-10-23: `home`, `conditions`, `tables_trajectory`,
   `convertors` (720×1440, dark theme, seed profile). **Not yet:**
   `tables_details` (still the old one).
2. Point the five `<image>` URLs at the new tag (`vX.Y.Z`) once it contains
   those files.
3. Validate with `appstreamcli validate --explain --no-net` (it was not
   available when the release list was extended, so only well-formedness was
   checked). The `<release>` dates added on 2026-10-23 for 0.1.18–0.1.22 are
   the tags' commit dates and may differ from the GitHub release dates.
4. Add the new version's `<release>` entry.

## Related, not blocking

- Other files in `docs/screenshots/` (`settings`, `shot_info`, the wizards,
  `my_sights`, `weapon_collection`, `reticle_picker`, `html_report`, the
  `phone/`, `tab7/`, `tab10/` store sets) were not retaken. Check which of
  them the Play / Flathub listings actually use before refreshing them.
