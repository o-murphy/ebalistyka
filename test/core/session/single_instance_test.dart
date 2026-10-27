// The activation channel of the desktop single-instance guard. The lock
// itself is per-process on POSIX (fcntl), so exclusivity between two
// processes isn't testable in-process.
//   flutter test test/core/session/single_instance_test.dart

import 'dart:async';
import 'dart:io';

import 'package:ebalistyka/core/session/single_instance_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('ebc_instance_'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('a later launch can ask the running instance to come forward', () async {
    final activated = Completer<void>();
    final primary = await tryBecomePrimary(
      dir,
      onActivate: () async => activated.complete(),
    );
    expect(primary, isTrue);

    expect(await notifyRunningInstance(dir), isTrue);
    await activated.future.timeout(const Duration(seconds: 5));
  });

  test('notifying with nothing running reports failure', () async {
    // No port file in an empty directory — gives up after its retries.
    expect(await notifyRunningInstance(dir), isFalse);
  });
}
