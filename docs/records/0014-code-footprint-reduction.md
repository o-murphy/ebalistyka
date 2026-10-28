# Code footprint reduction — less duplication, tighter abstractions

**Status:** Proposed

Raised by the project owner (2026-10-28), not tied to a bug or a release.
The codebase has grown a lot of repeated code, leaky or poor abstractions
and tangled dependencies, in both the UI and the services. Flutter is
verbose by nature, but the owner's read is that it can be made thinner,
easier to follow and cheaper to maintain without changing behaviour.

## Baseline (2026-10-28, `main`)

- `lib/`: 209 Dart files, ~36.5k lines; about 8.5k of that is generated or
  localization output (`l10n/app_localizations*.dart`,
  `ob_migrate/generated/schema.g.dart`), so ~28k hand-written.
- `test/`: ~6.8k lines.
- By area: `features/` 15.8k (`home/` 10.4k, `convertors/` 2.1k,
  `tables/` 1.9k, `settings/` 0.8k, `conditions/` 0.5k), `core/` 5.2k,
  `shared/` 4.9k, `ob_migrate/` 3.1k (legacy, hand-written part is
  `legacy_migrator.dart`), `update/` 0.8k.
- Largest hand-written files: `my_profiles_screen.dart` (739),
  `ammo_wizard_screen.dart` (702), `filter_sheet.dart` (630),
  `settings_screen.dart` (592), `reticle_view_screen.dart` (516),
  `trajectory_tables_vm.dart` (496), `trajectory_chart.dart` (465),
  `field_constraints.dart` (461), `router.dart` (459).

Line counts are a starting point, not the goal: the target is fewer
concepts and clearer seams, not a smaller number for its own sake.

## Audit (2026-10-28)

Three read-only passes (wizards/collections, convertors/tables/settings/shared
widgets, core/services/providers). Line savings are estimates. Dead-code
claims were re-checked by grep over `lib/` and `test/` (not `integration_test/`
beyond the first check). Not read in depth: `router.dart`, `home_vm.dart`,
`trajectory_tables_vm.dart`, `a7p_converter.dart`, the extensions,
`unit_formatter_impl.dart`, the ammo wizard screen's save/validation,
`table_html_exporter.dart` CSS/JS, `home_builders.dart`.

### A. Delete — done in `18b8bcf` (1,228 lines removed incl. a 586-line test)

- `home/sub_screens/ammo_wizard_form_state.dart` (360) — twin of
  `AmmoWizardState`; only its own test imports it. Delete with the test.
- `shared/widgets/unit_wheel_picker_dialog.dart` (128),
  `unit_value_header.dart` (69, used only by the dialog),
  `_stub_screen.dart` (26) — no importers.
- `showAmmoFilterSheet` and the `forCollection: false` branches of the sight
  and ammo filter sheets (~40, plus `ammoFilterProvider`/`sightFilterProvider`
  if nothing else uses them).
  These are leftovers of the old *My Ammo* / *My Sights* list screens
  (`my_ammo_screen.dart`, `my_sights_screen.dart`, present in the v0.2.0
  baseline, gone since); the profile model is now 1:1:1:1 and
  `docs/backlogs/8.3.md` states "no My Ammo/My Sights screens". No record
  reserves them for future use — keep only if such lists are planned.
- `custom_drag_table_editor_screen.dart`: 3-line re-export shim.

### B. Mechanical dedupe (low risk, ~450 lines)

- **Done** — profile actions copied between `my_profiles_screen.dart` and
  `profiles_list_screen.dart` (ask-name, add sheet, export + A7P range sheet,
  duplicate, remove) moved to `profile_actions.dart` (renamed from
  `profile_ebcp_actions.dart`) as plain `(context, ref, Profile)` functions;
  net −169 lines. Rename and the hot-swap flows were left in the screens: the
  two copies of rename differ, hot-swap is item C.
- **Done** — `FieldConstraints.inUnit(Unit)` replaces 8 hand-written
  conversion blocks in the convertor VMs (length, weight, torque, velocity,
  target-distance ×2, angular ×2), with a test. Pressure and temperature keep
  their own bounds. **Dropped:** `fromLimits(...)` for the ~39 roles in
  `field_constraints.dart` — each role is already a short declarative block,
  and positional factory args would read worse than the named ones.
- **Done** — `filter_sheet.dart`: `_toggled<T>`, `_vendorSection` and
  `_showFilterSheet` replace the three copies of each (−49 lines). A generic
  `FilterSheet<T>` was not attempted: the ammo sheet's weight range and
  default-caliber reset would make it harder to read than three plain sheets.
- **Done** — details-section labels were written three times
  (`details_table_mv.dart`, `details_table.dart`, `table_html_exporter.dart`);
  now `DetailsTableData.sections(l10n)` is the one place. −80 lines in `lib/`,
  +61 of tests. The widget's and the HTML report's output were captured
  before the change and are byte-identical after (full, empty and partial
  data).
- `ValueInputWithUnitPicker` and `UnitInputWithPicker` are the same widget (~45).
- `weapon_svg_provider`/`ammo_svg_provider` are copies (~20); platform-stub
  forwarders (~40); `AnglesConvertorField` duplicates `GenericConvertorField`
  (~15); powder-sens coefficient averaging written twice (~20).

### C. Abstractions worth building (medium risk, ~600-800 lines)

- Generic `CollectionPickerScreen<T>` for the three collection screens, with
  `matches(item)` on each filter state (~100-120).
- Data-driven simple convertors: one `SimpleConvertorSpec` + generic VM and
  screen instead of 5 VMs + 5 screens (~250-300). Existing tests reference the
  per-unit providers.
- Wizard states: a generic `update((s) => s.copyWith(..))` on the notifier
  drops ~55 `updateX` one-liners (~60); `freezed`/`dart_mappable` would save
  ~120-150 but is a codegen decision.
- Hot-swap `_onReplaceWeapon/Ammo/Sight` (~220 lines, same skeleton): a shared
  replace-sheet helper (~90-110). `context.mounted` sequencing is delicate.
- `trajectory_table.dart` main vs zero table share ~80% (~60-70); needs
  golden or manual visual checks.
- `ballistics_service_impl.dart` vs `_web.dart`: duplicated
  `CalculationException` and shot-building/result-mapping (~80-120). The file
  headers warn against merging the isolate and async paths — extract only the
  common parts.

### C2. Smaller items (each under ~60 lines)

- Wizard screens are already factored (`WizardFormMixin`, `WizardActionBar`,
  `WizardNameField`); what is left between weapon and sight is ~25-30 lines
  (vendor `TextField` block, `onNameChanged`/`_onSave`/`_provider` trio,
  `initialName`/`initialVendor`). Low payoff.
- `angular_convertor_vm.dart` / `target_distance_convertor_vm.dart` repeat a
  "convert, validate, `unawaited(save)`" block four times (~50). The reject
  rule differs by site (`>=` vs `>`), so the helper needs a `strict` flag.
- `settings_screen.dart`: five link tiles plus several chevron tiles share one
  shape (`_NavTile`), and the two spinner-leading tiles share a `_BusyLeading`
  (~40-50). The language sheet may duplicate `action_sheet.dart` /
  `profile_selection_sheet.dart` — not compared.
- `unit_hybrid_picker_dialog.dart` and `unit_constrained_input_dialog.dart`:
  the `showNullable…Dialog` wrapper is duplicated (~25). Merging the two
  dialogs fully is high risk. `UnitPickerListTile` could fold into
  `UnitPickerButton` (`tile: true`).
- `conditions_vm.dart:95-140`: nine pass-through setters forwarding to
  `shotConditionsProvider.notifier` (~30). Removing them changes the API for
  four widgets, so low value.
- Thin providers: `service_providers.dart` (10) and `formatter_provider.dart`
  (11) only re-expose; `shot_context_provider.dart` (35) could be a plain
  `Provider` instead of a `Notifier`.
- Platform stubs: `*_stub.dart` + forwarding facades (`single_instance.dart`
  is a pure forwarder); put the conditional `export` in the facade directly
  (~40).
- `ammo_collection_screen.dart:32-35,60` computes `defaultCaliberInch` twice.
- `unit_formatter_impl.dart` (235): ~30 methods that each map to one unit /
  symbol; probably table-driven. Unverified, only the interface was read.

### D. Decision for the owner: `ob_migrate/` (~3,200 lines)

Self-contained legacy ObjectBox migration (`schema.g.dart` 2412,
`legacy_migrator.dart` 420, gate screen 239, …). Only `app_bootstrap_io.dart`
and the `ob_dump_reader` dependency touch it; web does not use it. Removing it
is technically easy, but anyone still holding a `data.mdb` loses their data
silently. This is a product call (when to drop the upgrade path), not a
refactor. Cheapest option: keep it frozen until a stated cut-off.

### E. Layering notes (no line savings)

- `update_checker.dart` (415) mixes release checking, changelog and collection
  updates, and takes `WidgetRef` in plain functions.
- `settings_screen.dart` imports `home/profiles_vm.dart`, the only
  cross-feature import found; `core/` and `shared/` do not import `features/`.

### Totals

A+B ≈ 1,000 lines at low risk; C ≈ 600-800 more at medium risk; D ≈ 3,200 by
decision. Hand-written `lib/` is ~28k lines, so A–C is a ~5-6% cut: the win
here is fewer copies to keep in sync, not a dramatically smaller app.

## Open questions the audit did not settle

1. Where is the duplication? Candidates to check first: the three
   Weapon/Ammo/Sight wizards and their notifiers, the three collection
   screens, the unit-constrained input widgets, the convertor view models,
   the per-screen empty-state and readiness handling, the platform
   `_io`/`_web` split files.
2. Which abstractions are wrong rather than missing: provider layering,
   view models that reach across features, services with several
   responsibilities (`ballistics_service`, `a7p_converter`, the table
   exporters).
3. What is dead or legacy and can be deleted outright (`ob_migrate/` once
   the legacy-migration window closes, superseded helpers).
4. Which refactors are safe to do under the current test coverage, and
   which need tests written first.

## Approach (proposed)

- Audit first, then a short list of concrete refactors, each its own
  change with its own behaviour-preserving check (`flutter analyze`,
  `flutter test`, a manual pass over the affected screens).
- Prefer deleting and merging over adding layers; a new abstraction must
  replace at least two existing copies.
- Keep refactors out of release branches: do not mix them with feature or
  fix work, and not right before a tagged release.
- Record each accepted refactor as its own note under this record, or as a
  follow-up record if it needs a decision.

## Out of scope

Behaviour changes, UI redesign, storage format changes (`ebc_db`), and the
generated/localization files.
