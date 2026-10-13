# Reticles — wizard placeholders & remaining SVG generation

**Status:** In progress

Carried over from `docs/backlogs/5.RETICLES_AND_IMAGES.md` (pre-existing,
unchanged) — everything else in that doc shipped:

- `SightWizardScreen._SightPlaceholder` still shows `Icon(IconDef.sight)`
  instead of the SVG reticle from `reticleSvgProvider`
- `reticle_gen` CLI has only default + MIL-XT done; remaining reticle IDs
  not yet generated

**Update (2026-10-13), checked against code and `collection.json`:**

- `reticle_gen` has drawers for 8 reticles and `assets/svg/reticles/` has 8
  SVGs: `default`, `MIL-XT`, `MOAR`, `MOAR-T`, `MIL-C-F1`, `MIL-R-F1`,
  `DDR-2`, `APMR-FFP-IR-MIL` — more than the "default + MIL-XT" above.
- The collection still references reticle ids with no SVG: `IHR`,
  `EPR MOA`, `FC-MIL`, `FC-MOA`, `MIL-C`, `MIL-CF2`, `Mil-Dot`, `MIL-R`,
  `NP-R2`, `NP-RF1`, `Reticle 4` — those sights fall back to `default.svg`.
- `SightWizardScreen._SightPlaceholder` still shows an icon, not the
  reticle.
