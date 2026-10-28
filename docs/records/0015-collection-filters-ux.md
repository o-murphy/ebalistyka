# Collection filters — usability rework

**Status:** Proposed

Raised by the project owner (2026-10-28). The filters on the Weapon / Ammo /
Sight collection screens work as designed; the concern is how convenient and
useful they are, not their logic. This record is about UI/UX only — filter
semantics (`WeaponFilterState`, `AmmoFilterState`, `SightFilterState` in
`core/providers/filter_providers.dart`) are out of scope unless a UX change
needs them.

## What exists today

- A filter icon in the app bar of each collection screen, with a badge when a
  filter is active. It opens a modal bottom sheet (`filter_sheet.dart`).
- The sheet is a list of collapsed `ExpansionTile` sections with checkboxes
  and a count per option, an *Apply* button at the bottom and a *Reset*
  action. Sections: Weapon — vendor; Sight — vendor, focal plane; Ammo —
  vendor, caliber, weight range (min/max fields).
- Changes are drafted in the sheet and only take effect on *Apply*. The
  collection screen also has a free-text search.
- The Ammo filter pre-selects the profile weapon's caliber.

## Problems to describe

The owner sees convenience / usefulness problems but has not listed them yet.
Fill this in before designing anything — candidates to confirm or discard,
not findings:

1. What users try to do with the filters and cannot (or find slow).
2. Whether the bottom-sheet + collapsed sections + Apply flow is the issue, or
   what the filters offer (fields, ordering, defaults).
3. Whether the active filters are visible enough once the sheet is closed
   (today only a badge on the icon).
4. Interaction with search, and with the pre-selected caliber on Ammo.
5. Behaviour on small phones vs. tablets / desktop / web.

## Next steps

1. Write down the concrete problems above (owner).
2. Sketch one or two alternatives and compare them against the real
   collection sizes.
3. Implement the chosen one; update the in-app help
   (`assets/markdown/{en,uk}/*Collection*.md`) and screenshots.

## Related

- [0014] — the filter sheet code was just deduplicated (`_toggled`,
  `_vendorSection`, `_showFilterSheet`); a UX rework should build on that,
  not on the old copies.
