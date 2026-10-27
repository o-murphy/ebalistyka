import 'package:ebalistyka/core/session/single_instance_stub.dart'
    if (dart.library.io) 'package:ebalistyka/core/session/single_instance_io.dart'
    as impl;

/// Single-instance guard for the desktop app.
///
/// The data files assume one writer (see docs/records/0011): two app
/// processes would each keep their own in-memory copy and overwrite one
/// another. So a second launch doesn't open a window — it asks the running
/// instance to come to the front and exits.
///
/// Returns normally in the first (or only) instance, after which
/// [onActivate] is called whenever a later launch asks for the window.
/// In a second instance it **does not return**: the process exits once the
/// running one has been notified. Web and mobile: no-op (web has its own
/// guard in `tab_lock.dart`).
Future<void> ensureSingleInstance({required Future<void> Function() onActivate}) =>
    impl.ensureSingleInstance(onActivate: onActivate);
