# Reticles — wizard placeholders & remaining SVG generation

**Status:** In progress

Carried over from `docs/backlogs/5.RETICLES_AND_IMAGES.md` (pre-existing,
unchanged) — everything else in that doc shipped:

- `reticle_gen` CLI has only default + MIL-XT done; remaining reticle IDs
  not yet generated

**Update (2026-10-13), checked against code and `collection.json`:**

- `reticle_gen` has drawers for 8 reticles and `assets/svg/reticles/` has 8
  SVGs: `default`, `MIL-XT`, `MOAR`, `MOAR-T`, `MIL-C-F1`, `MIL-R-F1`,
  `DDR-2`, `APMR-FFP-IR-MIL` — more than the "default + MIL-XT" above.
- The collection still references reticle ids with no SVG: `IHR`,
  `EPR MOA`, `FC-MIL`, `FC-MOA`, `MIL-C`, `MIL-CF2`, `Mil-Dot`, `MIL-R`,
  `NP-R2`, `NP-RF1`, `Reticle 4` — those sights fall back to `default.svg`.

## Update (2026-10-16): placeholder is not a reticle

`SightWizardScreen._SightPlaceholder` ("Sight image") is the slot for a photo
of the sight, **not** the reticle pattern — the reticle is chosen in the
"Reticle pattern" tile below it. So the "show the SVG reticle there" item is
dropped; the placeholder waits for the image picker, which is deferred with
[0007]. What remains in this record is the missing reticle SVGs above.
