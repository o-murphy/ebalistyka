# Torque convertor range fix — 0–9999 N·m, one decimal

**Status:** Implemented (2026-10-28)

`FC.torque` (and its alias `FC.convertorTorque`) was 300–1500 N·m, step 1,
no decimals — the same numbers as the pressure convertor, so it looks copied
from there. In the Torque convertor the input therefore rejected anything
below 300 N·m (a scope screw is a few N·m) and the default of 100 N·m was
itself out of range. `packages/ebc_db/schema/settings.schema.json` already
flagged this as an unresolved discrepancy ("left unbounded pending a decision
on which side is wrong"); the `.a7p` schema has no torque or click-size field,
so it could not settle it.

## Decision

`FC.torque`: minimum 0, maximum 9999 N·m (the same 0–9999 as the length and
weight convertors), step 0.1, one decimal. It covers scope screws up to wheel
nuts, the default 100 N·m is inside, and 1.5 N·m is no longer shown as "2 N·m".
The ft·lb and in·lb decimals follow from the step.

## Consequences

- Torque convertor values display with one more decimal (`12.5 N·m` instead
  of `13 N·m`); the golden test in `test/features/convertors/` was regenerated
  and its diff reviewed — only the torque section changed.
- `settings.schema.json` is **not** updated: ConvertorsState's own fields are
  hand-authored, not generated, and the torque entry still carries the
  discrepancy note. Update it (and regenerate `field_constraints.g.dart`) if
  the schema is meant to bound the stored value.
- Separate, unchanged: the same schema bounds the stored pressure to
  300–1500 mmHg while the pressure convertor accepts 0–2000.

Follows [0014] (found while converting the simple convertors to specs).
