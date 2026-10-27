# ebc_db

Protobuf-backed data layer for eBalistyka — replaces the app's original
ObjectBox-based storage (`packages/ebalistyka_db`, now deprecated). Full
design rationale and history: `docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md`
(in the root repo).

## What this is

Two independent documents, each a standalone protobuf message persisted to
disk with a simple "md5 checksum + protobuf bytes" wire format:

- **`ProfilesData`** (`profiles.ebcp`) — the user's saved profiles
  (`Weapon`/`Ammo`/`Sight`/`Zero` embedded directly, no relational ids,
  `profiles[0]` is the active one).
- **`SettingsData`** (`settings.ebcp`) — app-wide settings (units, tables,
  reticle, unit-converter state, shooting conditions).

Plus `EbcpData`, a third message that wraps one or more `ProfilesData`
blocks and an optional `SettingsData` block into a single shareable/
exportable `.ebcp` file (profile sharing and whole-app backup).

No `ToOne`/`ToMany`, no relational ids, no multi-user support — deliberately
simpler than the ObjectBox model it replaces. See the migration doc's
"Core Design" section for why.

## Package layout

- `proto/` — `.proto` sources (source of truth for message shapes).
- `schema/` — JSON Schema per root message, used for validation.
- `lib/src/proto/` — generated Dart protobuf classes (`bin/generate_proto.dart`).
- `lib/src/generated/` — generated schema constants + numeric field bounds
  (`bin/embed_schema.dart`).
- `lib/src/persistence/` — `MsgCodec`/`MsgStore` (atomic disk read/write)
  and the per-message `ProfilesFile`/`SettingsFile`/`EbcpFile` wrappers.
- `lib/src/validation/` — JSON Schema-based validators + proto→JSON
  conversion functions.
- `lib/src/ops/` — small pure helpers encoding conventions that belong with
  the data (e.g. "`profiles[0]` is active", `sanitizeProfile`'s numeric
  clamping gate).

Regenerating after a `.proto`/schema change:

```sh
dart run bin/generate_proto.dart   # requires protoc + protoc-gen-dart
dart run bin/embed_schema.dart
```

## License

LGPL-3.0-only (`LICENSE`). Chosen deliberately more permissive than the
main app (GPL-3.0) since this package is a general-purpose data layer with
no inherent tie to eBalistyka specifically — LGPL lets it be linked from a
differently-licensed project without forcing that project under GPL, while
keeping modifications to this package itself copyleft.
