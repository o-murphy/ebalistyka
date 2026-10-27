import 'dart:js_interop';
import 'dart:js_interop_unsafe';

Future<bool> requestPersistentStorage() async {
  try {
    final storage = (globalContext['navigator'] as JSObject?)?['storage'];
    if (storage == null || !storage.isA<JSObject>()) return false;
    final s = storage as JSObject;
    if (!s.has('persist')) return false;

    final already = await (s.callMethod<JSPromise<JSBoolean>>('persisted'.toJS))
        .toDart;
    if (already.toDart) return true;

    final granted = await (s.callMethod<JSPromise<JSBoolean>>('persist'.toJS))
        .toDart;
    return granted.toDart;
  } catch (_) {
    return false;
  }
}
