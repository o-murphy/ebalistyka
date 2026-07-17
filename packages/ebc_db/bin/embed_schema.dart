// Embeds schema/ebc_db.schema.json into lib/src/generated/ebc_db_schema.g.dart
// as a Dart string constant, so DbValidator doesn't need to read a file off
// disk at runtime (matches a7p's Python `scripts/compile.py --dart` step,
// done in pure Dart here since this package has no Python/JS siblings to
// share a single script with).
//
// Run after editing the schema source:
//   dart run bin/embed_schema.dart
import 'dart:convert';
import 'dart:io';

void main() {
  final schemaFile = File('schema/ebc_db.schema.json');
  if (!schemaFile.existsSync()) {
    stderr.writeln('${schemaFile.path} not found — run from the package root.');
    exit(1);
  }

  final raw = schemaFile.readAsStringSync();
  // Round-trip through jsonDecode/jsonEncode to fail fast on malformed JSON
  // and to normalize whitespace before embedding.
  final Object? decoded;
  try {
    decoded = jsonDecode(raw);
  } catch (e) {
    stderr.writeln('Invalid JSON in ${schemaFile.path}: $e');
    exit(1);
  }
  final compact = jsonEncode(decoded);

  final escaped = compact
      .replaceAll(r'\', r'\\')
      .replaceAll(r'$', r'\$')
      .replaceAll("'", r"\'");

  final outDir = Directory('lib/src/generated');
  outDir.createSync(recursive: true);
  final outFile = File('${outDir.path}/ebc_db_schema.g.dart');
  outFile.writeAsStringSync('''
// GENERATED CODE — DO NOT EDIT BY HAND.
// Regenerate with: dart run bin/embed_schema.dart

/// JSON Schema for [Db], embedded from schema/ebc_db.schema.json.
const String kEbcDbSchemaJson = '$escaped';
''');

  print('Done. Wrote ${outFile.path}');
}
