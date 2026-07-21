## 0.0.1

Initial implementation. See `docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md`
for the full history — summary:

* `ProfilesData`/`SettingsData`/`EbcpData` protobuf messages, JSON Schema
  validation per message, and the `MsgStore`-based atomic
  tmp-write+`.bak`-rotate+rename persistence layer.
* Generated numeric field bounds (`FieldLimits`/`ArrayLimits`) driven
  entirely from the JSON Schema sources, plus a centralized
  `sanitizeProfile`/`sanitizeSettingsData` clamp-on-write gate.
* `Profile` is a flat `Weapon`+`Ammo`+`Sight` embed (no relational ids, no
  `ToOne`/`ToMany`) — `Ammo`'s multi-BC/custom-drag/powder-sensitivity
  tables are `repeated` message types (`MultiBcPoint`/`CustomDragPoint`/
  `PowderSensitivityPoint`), not parallel arrays, so a length mismatch
  between paired values is structurally inexpressible.
* Licensed LGPL-3.0-only (see `LICENSE`).
