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

## Not yet done

No audit has been made. Nothing below is a finding; it is what the audit
should answer.

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
