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
  _Schema('schema/profiles.schema.json', 'profiles_schema.g.dart', 'kProfilesSchemaJson', 'ProfilesData'),
  _Schema('schema/settings.schema.json', 'settings_schema.g.dart', 'kSettingsSchemaJson', 'SettingsData'),
  _Schema(
    'schema/ebcp.schema.json',
    'ebcp_schema.g.dart',
    'kEbcpSchemaJson',
    'EbcpData',
    mergeDefsFrom: ['schema/profiles.schema.json', 'schema/settings.schema.json'],
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
