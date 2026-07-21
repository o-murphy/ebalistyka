// Re-generates lib/src/proto/*.dart from ../proto/*.proto.
//
// Run after editing the .proto source:
//   dart run bin/generate_proto.dart
//
// Requires `protoc` (the Protocol Buffers compiler) and the
// `protoc-gen-dart` plugin on PATH:
//   sudo apt-get install -y protobuf-compiler   # or `brew install protobuf`
//   dart pub global activate protoc_plugin
import 'dart:io';
import 'dart:developer' as developer;

import 'package:path/path.dart' as p;

void main() {
  final protoc = _findOnPath('protoc');
  if (protoc == null) {
    stderr.writeln(
      "protoc not found on PATH. Install it first — see this file's header "
      'comment for one-time machine setup.',
    );
    exit(1);
  }

  final pluginDir = p.join(_pubCacheHome(), 'bin');
  final pluginName = Platform.isWindows
      ? 'protoc-gen-dart.bat'
      : 'protoc-gen-dart';
  final plugin = File(p.join(pluginDir, pluginName));
  if (!plugin.existsSync()) {
    stderr.writeln(
      'protoc-gen-dart not found at ${plugin.path}. Run:\n'
      '  dart pub global activate protoc_plugin',
    );
    exit(1);
  }

  final binDir = p.dirname(Platform.script.toFilePath());
  final repoRoot = p.dirname(binDir);

  // profiles.proto/settings.proto are independent (own package, no
  // cross-imports); ebcp.proto imports both to define the shareable
  // container. One protoc invocation compiles all three.
  const protoFiles = [
    'proto/profiles.proto',
    'proto/settings.proto',
    'proto/ebcp.proto',
  ];
  final result = Process.runSync(protoc, [
    '--dart_out=lib/src/proto',
    '-I',
    'proto',
    ...protoFiles,
    '--plugin=protoc-gen-dart=${plugin.path}',
  ], workingDirectory: repoRoot);

  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) exit(result.exitCode);
  developer.log('Done. Files written to lib/src/proto/');
}

/// Resolves `protoc` via PATH — [Process.runSync] doesn't do PATH lookup
/// itself on every platform, so this mirrors what a shell would do.
String? _findOnPath(String executable) {
  final pathVar = Platform.environment['PATH'];
  if (pathVar == null) return null;
  final exeName = Platform.isWindows ? '$executable.exe' : executable;
  for (final dir in pathVar.split(Platform.isWindows ? ';' : ':')) {
    final candidate = File(p.join(dir, exeName));
    if (candidate.existsSync()) return candidate.path;
  }
  return null;
}

/// `dart pub global activate` installs shims under the pub cache's `bin/`
/// — `$HOME/.pub-cache` on Linux/macOS, `%LOCALAPPDATA%\Pub\Cache` on
/// Windows (falling back to `%APPDATA%\Pub\Cache` on older setups).
String _pubCacheHome() {
  final env = Platform.environment;
  if (env['PUB_CACHE'] != null) return env['PUB_CACHE']!;
  if (Platform.isWindows) {
    final base = env['LOCALAPPDATA'] ?? env['APPDATA'];
    if (base != null) return p.join(base, 'Pub', 'Cache');
  }
  return p.join(env['HOME'] ?? '.', '.pub-cache');
}
