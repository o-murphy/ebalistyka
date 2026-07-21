// Embeds schema/*.schema.json into lib/src/generated/*_schema.g.dart as
// Dart string constants, so the validators don't need to read a file off
// disk at runtime (matches a7p's Python `scripts/compile.py --dart` step,
// done in pure Dart here since this package has no Python/JS siblings to
// share a single script with).
//
// Run after editing a schema source:
//   dart run bin/embed_schema.dart
import 'dart:convert';
import 'dart:io';

class _Schema {
  final String schemaFile;
  final String outFile;
  final String constName;
  final String messageName;
  // Other schema.json files whose $defs this one references by name
  // (e.g. ebcp.schema.json's EbcpData refs "#/$defs/ProfilesData") without
  // redefining them. Their $defs get merged in at embed time so the
  // *embedded* constant is self-contained (no external $ref resolver
  // needed at JsonSchema.create() time) while the *source* file stays a
  // single point of truth — nothing is hand-duplicated on disk.
  final List<String> mergeDefsFrom;
  const _Schema(
    this.schemaFile,
    this.outFile,
    this.constName,
    this.messageName, {
    this.mergeDefsFrom = const [],
  });
}

const _schemas = [
  _Schema(
    'schema/profiles.schema.json',
    'profiles_schema.g.dart',
    'kProfilesSchemaJson',
    'ProfilesData',
    mergeDefsFrom: ['schema/bounds.schema.json'],
  ),
  _Schema(
    'schema/settings.schema.json',
    'settings_schema.g.dart',
    'kSettingsSchemaJson',
    'SettingsData',
    mergeDefsFrom: ['schema/bounds.schema.json'],
  ),
  _Schema(
    'schema/ebcp.schema.json',
    'ebcp_schema.g.dart',
    'kEbcpSchemaJson',
    'EbcpData',
    mergeDefsFrom: ['schema/profiles.schema.json', 'schema/settings.schema.json', 'schema/bounds.schema.json'],
  ),
];

void main() {
  final outDir = Directory('lib/src/generated');
  outDir.createSync(recursive: true);

  for (final schema in _schemas) {
    final schemaFile = File(schema.schemaFile);
    if (!schemaFile.existsSync()) {
      stderr.writeln('${schemaFile.path} not found — run from the package root.');
      exit(1);
    }

    final raw = schemaFile.readAsStringSync();
    // Round-trip through jsonDecode/jsonEncode to fail fast on malformed
    // JSON and to normalize whitespace before embedding.
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (e) {
      stderr.writeln('Invalid JSON in ${schemaFile.path}: $e');
      exit(1);
    }

    final merged = _mergeExternalDefs(decoded, schema.mergeDefsFrom);
    final compact = jsonEncode(merged);

    final escaped = compact
        .replaceAll(r'\', r'\\')
        .replaceAll(r'$', r'\$')
        .replaceAll("'", r"\'");

    final outFile = File('${outDir.path}/${schema.outFile}');
    outFile.writeAsStringSync('''
// GENERATED CODE — DO NOT EDIT BY HAND.
// Regenerate with: dart run bin/embed_schema.dart

/// JSON Schema for [${schema.messageName}], embedded from ${schema.schemaFile}.
const String ${schema.constName} = '$escaped';
''');

    print('Done. Wrote ${outFile.path}');
  }

  _generateFieldConstraints(outDir);
}

// ─── Phase 7 field constraints (see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md) ──
//
// Generates lib/src/generated/field_constraints.g.dart: one const
// FieldBounds (minRaw/maxRaw only, no unit) per persisted field role.
//
// Role names carry the wire unit as a suffix (matching the schema's own
// field-naming convention, e.g. `distance_meter`/`temperature_c`) —
// FieldBounds has no unit field (see field_bounds.dart), so the name is the
// only thing telling a reader what unit minRaw/maxRaw are in. Roles with no
// physical unit (dimensionless magnification, ballistic coefficient) stay
// bare, same as their wire fields (`min_magnification`, `bc_g1`) do.
//
// Three sources, each handled differently:
//
// 1. `_boundsSchemaRoles` — roles whose bounds live directly in
//    schema/bounds.schema.json's own $defs (shared across BOTH
//    profiles.schema.json and settings.schema.json, e.g. `temperatureC`
//    validates Zero.temperature_c, Ammo.muzzle_velocity_temperature_c,
//    ShootingConditions.temperature_c and VelocityConv.atmo_temperature_c
//    all at once). Read straight from bounds.schema.json — no path-walking,
//    no "do these N usages agree" check needed, since there's exactly one
//    place the number can come from by construction, not by convention.
// 2. `_profilesFieldConstraintRoles` — roles sourced by walking
//    profiles.schema.json's own $defs (Weapon/Sight/Zero/Ammo), for bounds
//    that don't need to be shared with settings.schema.json.
// 3. `_settingsFieldConstraintRoles` — same, walking settings.schema.json's
//    own $defs (GeneralSettings/TablesSettings/ShootingConditions/
//    AnglesConv/VelocityConv/DistanceConvTargetSize). ConvertorsState's
//    direct fields (length/weight/pressure/temperature/torque) are excluded
//    — they're nested one level deeper (behind `allOf: [{$ref: UnitValue}]`
//    plus a `properties.value` override, not a leaf number property) *and*
//    three of them have an unresolved unit/range discrepancy (see that
//    doc's Phase 7 notes) — deferred together, not worth half-generating.
//
// For (2) and (3), a property whose bounds resolve through a $ref/allOf
// pointing at one of _boundsSchemaRoles' own $defs entries is silently
// skipped (not "unmapped", not required to have its own path-based role
// entry) — it's already covered by source (1).
const _boundsSchemaRoles = <String, String>{
  'temperatureC': 'TemperatureC',
  'altitudeMeter': 'AltitudeMeter',
  'pressureHPa': 'PressureHPa',
  'humidityFrac': 'HumidityFrac',
  'latitudeDeg': 'LatitudeDeg',
  'azimuthDeg': 'AzimuthDeg',
  'lookAngleRad': 'LookAngleRad',
};

const _profilesFieldConstraintRoles = <String, List<(String, String)>>{
  'projectileDiameterInch': [('Weapon', 'caliber_inch'), ('Ammo', 'caliber_inch')],
  'twistInch': [('Weapon', 'twist_inch')],
  'barrelLengthInch': [('Weapon', 'barrel_length_inch')],
  'sightHeightInch': [('Sight', 'sight_height_inch'), ('Sight', 'sight_horizontal_offset_inch')],
  'magnification': [
    ('Sight', 'min_magnification'),
    ('Sight', 'max_magnification'),
    ('Sight', 'calibrated_magnification'),
  ],
  'zeroDistanceMeter': [('Zero', 'distance_meter')],
  'projectileWeightGrain': [('Ammo', 'weight_grain')],
  'projectileLengthInch': [('Ammo', 'length_inch')],
  'ballisticCoefficient': [('Ammo', 'bc_g1'), ('Ammo', 'bc_g7')],
  'muzzleVelocityMps': [('Ammo', 'muzzle_velocity_mps')],
  'powderSensitivityFrac': [('Ammo', 'powder_sensitivity_frac')],
};
const _profilesFieldConstraintDefs = ['Weapon', 'Sight', 'Zero', 'Ammo'];

const _settingsFieldConstraintRoles = <String, List<(String, String)>>{
  'targetDistanceMeter': [('ShootingConditions', 'distance_meter')],
  'windDirectionDeg': [('ShootingConditions', 'wind_direction_deg')],
  'windSpeedMps': [('ShootingConditions', 'wind_speed_mps')],
  'distanceStepMeter': [
    ('GeneralSettings', 'home_chart_distance_step'),
    ('GeneralSettings', 'home_table_distance_step'),
    ('TablesSettings', 'distance_step_meter'),
  ],
  'tableRangeMeter': [
    ('TablesSettings', 'distance_start_meter'),
    ('TablesSettings', 'distance_end_meter'),
  ],
  'convertorDistanceMeter': [('AnglesConv', 'distance_value_meter')],
  'convertorVelocityMps': [('VelocityConv', 'value_mps')],
  'convertorTargetPhysicalSizeInch': [('DistanceConvTargetSize', 'size_inch')],
  'targetSizeMil': [('DistanceConvTargetSize', 'size_angular_mil')],
};
const _settingsFieldConstraintDefs = [
  'GeneralSettings',
  'TablesSettings',
  'ShootingConditions',
  'AnglesConv',
  'VelocityConv',
  'DistanceConvTargetSize',
];

// Role -> every (defName, propertyName) in profiles.schema.json's Ammo
// sharing one array-length cap (`maxItems`). customDragTable/
// powderSensitivityTable are still paired-array concepts (their two arrays
// are meant to stay the same length row-for-row, but nothing enforces that
// agreement — JSON Schema has no keyword for it). multiBcTableG1/G7 no
// longer have this problem: each is one `repeated MultiBcPoint` array of
// {v_mps, bc} objects (see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md
// Phase 7's "Repeated-field length" note), so a length mismatch between
// v_mps and bc is structurally impossible rather than merely unchecked —
// still one path each below since `maxItems` still needs resolving per role.
const _arrayLimitRoles = <String, List<(String, String)>>{
  'multiBcTableG1': [('Ammo', 'multi_bc_table_g1')],
  'multiBcTableG7': [('Ammo', 'multi_bc_table_g7')],
  'customDragTable': [('Ammo', 'custom_drag_table_mach'), ('Ammo', 'custom_drag_table_cd')],
  'powderSensitivityTable': [('Ammo', 'powder_sensitivity_tc'), ('Ammo', 'powder_sensitivity_v_mps')],
};

void _generateFieldConstraints(Directory outDir) {
  final boundsDefs =
      (jsonDecode(File('schema/bounds.schema.json').readAsStringSync()) as Map<String, dynamic>)[r'$defs']
          as Map<String, dynamic>;

  // role -> (min, max, description), collected from all three sources below.
  final resolved = <String, (num, num, String)>{};

  for (final entry in _boundsSchemaRoles.entries) {
    final target = boundsDefs[entry.value] as Map<String, dynamic>?;
    if (target == null) {
      stderr.writeln("_boundsSchemaRoles['${entry.key}'] points to a missing bounds.schema.json \$defs entry: ${entry.value}");
      exit(1);
    }
    resolved[entry.key] = (
      target['minimum'] as num,
      target['maximum'] as num,
      target['description'] as String? ?? '',
    );
  }

  _resolvePathBasedRoles(
    schemaFile: 'schema/profiles.schema.json',
    defNames: _profilesFieldConstraintDefs,
    roles: _profilesFieldConstraintRoles,
    mergeDefsFrom: const ['schema/bounds.schema.json'],
    into: resolved,
  );
  _resolvePathBasedRoles(
    schemaFile: 'schema/settings.schema.json',
    defNames: _settingsFieldConstraintDefs,
    roles: _settingsFieldConstraintRoles,
    mergeDefsFrom: const ['schema/bounds.schema.json'],
    into: resolved,
  );

  final arrayLimits = <String, int>{};
  _resolveArrayLimitRoles(
    schemaFile: 'schema/profiles.schema.json',
    defName: 'Ammo',
    roles: _arrayLimitRoles,
    into: arrayLimits,
  );

  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE — DO NOT EDIT BY HAND.')
    ..writeln('// Regenerate with: dart run bin/embed_schema.dart')
    ..writeln()
    ..writeln("import '../validation/field_bounds.dart';")
    ..writeln()
    ..writeln('/// Numeric bounds for persisted field roles, generated from')
    ..writeln('/// schema/bounds.schema.json, schema/profiles.schema.json and')
    ..writeln('/// schema/settings.schema.json. See')
    ..writeln('/// docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7 — ConvertorsState')
    ..writeln("/// (length/weight/pressure/temperature/torque) isn't covered yet, see that")
    ..writeln('/// doc for why.')
    ..writeln('abstract final class FieldLimits {');

  for (final role
      in [..._boundsSchemaRoles.keys, ..._profilesFieldConstraintRoles.keys, ..._settingsFieldConstraintRoles.keys]) {
    final (min, max, description) = resolved[role]!;
    if (description.isNotEmpty) {
      buffer.writeln('  /// $description');
    }
    buffer.writeln('  static const $role = FieldBounds(minRaw: $min, maxRaw: $max);');
    buffer.writeln();
  }
  buffer.writeln('}');

  buffer
    ..writeln()
    ..writeln('/// Max element counts for Ammo\'s paired-array (row-wise) fields —')
    ..writeln('/// generated from each field\'s `maxItems` in profiles.schema.json. Only')
    ..writeln('/// caps each array\'s own length; does NOT check that a pair (e.g.')
    ..writeln('/// multiBcTableG1\'s v_mps/bc arrays) agree on length with each other —')
    ..writeln('/// see docs/backlogs/8.PROTOBUF_STORAGE_MIGRATION.md Phase 7.')
    ..writeln('abstract final class ArrayLimits {');
  for (final role in _arrayLimitRoles.keys) {
    buffer.writeln('  static const int ${role}MaxItems = ${arrayLimits[role]};');
  }
  buffer.writeln('}');

  final outFile = File('${outDir.path}/field_constraints.g.dart');
  outFile.writeAsStringSync(buffer.toString());
  print('Done. Wrote ${outFile.path}');
}

/// Walks [defName] within [schemaFile] for array properties with a
/// `maxItems`, resolving each to its role via [roles] and writing the count
/// into [into]. Exits loudly on: an array field with `maxItems` but no role
/// entry, a role entry pointing at a path with no `maxItems`, or a role
/// whose mapped paths disagree on the count.
void _resolveArrayLimitRoles({
  required String schemaFile,
  required String defName,
  required Map<String, List<(String, String)>> roles,
  required Map<String, int> into,
}) {
  final defs = (jsonDecode(File(schemaFile).readAsStringSync()) as Map<String, dynamic>)[r'$defs'] as Map<String, dynamic>;
  final props = (defs[defName] as Map<String, dynamic>)['properties'] as Map<String, dynamic>;

  final pathToRole = <(String, String), String>{
    for (final entry in roles.entries)
      for (final path in entry.value) path: entry.key,
  };

  final unmapped = <String>[];
  final found = <String, List<(String, int)>>{};

  for (final propEntry in props.entries) {
    final prop = propEntry.value as Map<String, dynamic>;
    final maxItems = prop['maxItems'] as int?;
    if (maxItems == null) continue;
    final path = (defName, propEntry.key);
    final role = pathToRole[path];
    if (role == null) {
      unmapped.add('$defName.${propEntry.key}');
      continue;
    }
    (found[role] ??= []).add(('$defName.${propEntry.key}', maxItems));
  }

  if (unmapped.isNotEmpty) {
    stderr.writeln(
      '$schemaFile/$defName has array field(s) with maxItems but no '
      '_arrayLimitRoles mapping entry in bin/embed_schema.dart: ${unmapped.join(', ')}',
    );
    exit(1);
  }

  for (final entry in roles.entries) {
    final role = entry.key;
    final actual = found[role];
    if (actual == null || actual.length != entry.value.length) {
      stderr.writeln(
        "_arrayLimitRoles['$role'] references a path with no maxItems in "
        '$schemaFile/$defName — check for a typo or a renamed field.',
      );
      exit(1);
    }
    final (_, max0) = actual.first;
    for (final (path, max) in actual.skip(1)) {
      if (max != max0) {
        stderr.writeln(
          "Array-limit role '$role' has disagreeing maxItems across its "
          'mapped paths: ${actual.first.$1}=$max0 vs. $path=$max.',
        );
        exit(1);
      }
    }
    into[role] = max0;
  }
}

/// Walks [defNames] within [schemaFile], resolving each numeric property to
/// its role via [roles] and writing `(min, max, description)` into [into].
/// A property whose bounds resolve through a $ref/allOf pointing at one of
/// [_boundsSchemaRoles]'s own $defs entries is skipped — that role is
/// already resolved directly from bounds.schema.json, not from here.
/// Exits loudly on: a numeric property with no role entry, a role entry
/// pointing at a path with no numeric bounds, or a role whose mapped paths
/// disagree on min/max.
void _resolvePathBasedRoles({
  required String schemaFile,
  required List<String> defNames,
  required Map<String, List<(String, String)>> roles,
  required List<String> mergeDefsFrom,
  required Map<String, (num, num, String)> into,
}) {
  final decoded = jsonDecode(File(schemaFile).readAsStringSync());
  final defs = (_mergeExternalDefs(decoded, mergeDefsFrom) as Map<String, dynamic>)[r'$defs'] as Map<String, dynamic>;
  final boundsSchemaDefNames = _boundsSchemaRoles.values.toSet();

  final pathToRole = <(String, String), String>{
    for (final entry in roles.entries)
      for (final path in entry.value) path: entry.key,
  };

  final unmapped = <String>[];
  final found = <String, List<(String, num, num, String)>>{};

  for (final defName in defNames) {
    final props = (defs[defName] as Map<String, dynamic>)['properties'] as Map<String, dynamic>;
    for (final propEntry in props.entries) {
      final prop = propEntry.value as Map<String, dynamic>;
      if (_refTargetName(prop) case final refName? when boundsSchemaDefNames.contains(refName)) {
        continue; // handled directly from bounds.schema.json, not here
      }
      final bounds = _numericBounds(prop, defs);
      if (bounds == null) continue;
      final path = (defName, propEntry.key);
      final role = pathToRole[path];
      if (role == null) {
        unmapped.add('$defName.${propEntry.key}');
        continue;
      }
      (found[role] ??= []).add((
        '$defName.${propEntry.key}',
        bounds.$1,
        bounds.$2,
        // description lives on the property itself (sibling of $ref/allOf),
        // not on the shared $defs target, so per-usage wording is kept even
        // when the bounds themselves are shared.
        prop['description'] as String? ?? '',
      ));
    }
  }

  if (unmapped.isNotEmpty) {
    stderr.writeln('$schemaFile has numeric field(s) with no mapping entry in bin/embed_schema.dart: ${unmapped.join(', ')}');
    exit(1);
  }

  for (final entry in roles.entries) {
    final role = entry.key;
    final actual = found[role];
    if (actual == null || actual.length != entry.value.length) {
      stderr.writeln(
        "Role '$role' references a path not found in $schemaFile (or found "
        'more/fewer times than expected) — check for a typo or a renamed field.',
      );
      exit(1);
    }
    final (_, min0, max0, description0) = actual.first;
    for (final (path, min, max, _) in actual.skip(1)) {
      if (min != min0 || max != max0) {
        stderr.writeln(
          "Role '$role' has disagreeing bounds across its mapped paths: "
          '${actual.first.$1}=[$min0,$max0] vs. $path=[$min,$max]. '
          'A single role can only validate multiple wire fields if they '
          'share one range — split it into two roles instead.',
        );
        exit(1);
      }
    }
    into[role] = (min0, max0, description0);
  }
}

/// Returns the raw `$defs` target name a property points to — via a direct
/// `$ref` or the first `$ref` found inside an `allOf` — without resolving
/// further. Null if [prop] doesn't reference a `$defs` entry at all.
String? _refTargetName(Map<String, dynamic> prop) {
  const prefix = r'#/$defs/';
  String? nameFrom(String? ref) => (ref != null && ref.startsWith(prefix)) ? ref.substring(prefix.length) : null;

  final direct = nameFrom(prop[r'$ref'] as String?);
  if (direct != null) return direct;

  final allOf = prop['allOf'] as List<dynamic>?;
  if (allOf != null) {
    for (final entry in allOf) {
      final name = nameFrom((entry as Map<String, dynamic>)[r'$ref'] as String?);
      if (name != null) return name;
    }
  }
  return null;
}

/// Resolves [prop]'s numeric bounds, following one level of indirection if
/// the bounds live in a shared `$defs` entry instead of inline — either a
/// direct `$ref` (full replacement) or an `allOf` containing one
/// (bounds-only, layered under a sibling `type`/`default` that varies per
/// field). Returns null if [prop] has no numeric bounds at all (not every
/// property is meant to have one).
(num, num)? _numericBounds(Map<String, dynamic> prop, Map<String, dynamic> defs) {
  if (prop.containsKey('minimum') && prop.containsKey('maximum')) {
    return (prop['minimum'] as num, prop['maximum'] as num);
  }
  final ref = prop[r'$ref'] as String?;
  if (ref != null) {
    return _numericBounds(_resolveRef(ref, defs), defs);
  }
  final allOf = prop['allOf'] as List<dynamic>?;
  if (allOf != null) {
    for (final entry in allOf) {
      final bounds = _numericBounds(entry as Map<String, dynamic>, defs);
      if (bounds != null) return bounds;
    }
  }
  return null;
}

Map<String, dynamic> _resolveRef(String ref, Map<String, dynamic> defs) {
  const prefix = r'#/$defs/';
  if (!ref.startsWith(prefix)) {
    stderr.writeln(
      'Unsupported \$ref: $ref (only local #/\$defs/Name refs are resolved by _numericBounds).',
    );
    exit(1);
  }
  final name = ref.substring(prefix.length);
  final target = defs[name];
  if (target == null) {
    stderr.writeln('\$ref points to an unknown \$defs entry: $ref');
    exit(1);
  }
  return target as Map<String, dynamic>;
}

/// Copies [decoded]'s `$defs` and extends it with every `$defs` entry found
/// in [otherSchemaFiles], so `$ref: "#/$defs/Foo"` inside [decoded] resolves
/// locally once embedded, without [decoded] having to redefine `Foo` on
/// disk. Errors (loudly) on a def-name collision between sources — that
/// would silently pick one and hide a real conflict.
Object? _mergeExternalDefs(Object? decoded, List<String> otherSchemaFiles) {
  if (otherSchemaFiles.isEmpty) return decoded;
  if (decoded is! Map<String, dynamic>) return decoded;

  final ownDefs = Map<String, dynamic>.from(
    decoded[r'$defs'] as Map<String, dynamic>? ?? {},
  );
  final mergedDefs = <String, dynamic>{};

  for (final path in otherSchemaFiles) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('$path (referenced via mergeDefsFrom) not found.');
      exit(1);
    }
    final otherDefs =
        (jsonDecode(file.readAsStringSync()) as Map<String, dynamic>)[r'$defs']
            as Map<String, dynamic>? ??
        {};
    for (final entry in otherDefs.entries) {
      if (mergedDefs.containsKey(entry.key)) {
        stderr.writeln(
          "\$defs name collision: '${entry.key}' appears in more than one "
          'mergeDefsFrom source for ${decoded[r'$id']}.',
        );
        exit(1);
      }
      mergedDefs[entry.key] = entry.value;
    }
  }

  mergedDefs.addAll(ownDefs); // own defs win if a name somehow also collides here
  return {...decoded, r'$defs': mergedDefs};
}
