import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui' show VoidCallback;

const _lockName = 'ebalistyka:active-session';

extension type _LockManager._(JSObject _) implements JSObject {
  external JSPromise<JSAny?> request(
    String name,
    JSObject options,
    JSFunction callback,
  );
}

// `navigator.locks` is undefined in insecure contexts (plain http on a
// non-localhost host) — treated as "no coordination available".
@JS('navigator.locks')
external _LockManager? get _locks;

@JS('location.reload')
external void _reload();

Future<void> acquire({required VoidCallback onLost}) async {
  final locks = _locks;
  if (locks == null) return;

  final granted = Completer<void>();
  // Never completed: the lock is held for as long as this page lives.
  final hold = Completer<void>();

  final options = JSObject()..['steal'] = true.toJS;
  final callback = ((JSAny? _) {
    if (!granted.isCompleted) granted.complete();
    return hold.future.toJS;
  }).toJS;

  unawaited(
    locks
        .request(_lockName, options, callback)
        .toDart
        .then<void>((_) {}, onError: (Object _) => onLost()),
  );

  // Granted immediately when stealing; the timeout only guards against a
  // browser quirk blocking startup.
  await granted.future.timeout(const Duration(seconds: 3), onTimeout: () {});
}

void reload() => _reload();
