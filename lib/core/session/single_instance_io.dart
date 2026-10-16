import 'dart:io';

import 'package:ebalistyka/core/session/single_instance_core.dart';
import 'package:ebalistyka/shared/helpers/is_desktop.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path_provider/path_provider.dart';

Future<void> ensureSingleInstance({
  required Future<void> Function() onActivate,
}) async {
  if (!isDesktop) return;
  final Directory dir;
  try {
    dir = await getApplicationSupportDirectory();
    await dir.create(recursive: true);
  } catch (e) {
    debugPrint('single instance: no data directory, not guarding: $e');
    return;
  }

  if (await tryBecomePrimary(dir, onActivate: onActivate)) return;

  if (!await notifyRunningInstance(dir)) {
    debugPrint('single instance: running instance did not answer, exiting');
  }
  exit(0);
}
