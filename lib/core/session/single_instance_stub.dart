/// No desktop process model here (web/mobile): nothing to coordinate.
Future<void> ensureSingleInstance({
  required Future<void> Function() onActivate,
}) async {}
