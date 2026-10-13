import 'dart:js_interop';
import 'dart:js_interop_unsafe';

JSObject? _deferred;

JSObject get _navigator => globalContext['navigator'] as JSObject;

bool _isDesktopBrowser() {
  final nav = _navigator;
  // Chromium: authoritative.
  final uaData = nav['userAgentData'];
  if (uaData.isA<JSObject>()) {
    final mobile = (uaData as JSObject)['mobile'];
    if (mobile.isA<JSBoolean>()) return !(mobile as JSBoolean).toDart;
  }
  final ua = (nav['userAgent'] as JSString?)?.toDart ?? '';
  if (RegExp(
    r'Android|iPhone|iPad|iPod|Mobile',
    caseSensitive: false,
  ).hasMatch(ua)) {
    return false;
  }
  // iPadOS reports a Mac user agent but has a touch screen.
  final touch = (nav['maxTouchPoints'] as JSNumber?)?.toDartInt ?? 0;
  if (ua.contains('Macintosh') && touch > 1) return false;
  return true;
}

bool _isStandalone() {
  try {
    final mq = globalContext.callMethod<JSObject>(
      'matchMedia'.toJS,
      '(display-mode: standalone)'.toJS,
    );
    return (mq['matches'] as JSBoolean).toDart;
  } catch (_) {
    return false;
  }
}

void init({required void Function(bool) setAvailable}) {
  if (!_isDesktopBrowser() || _isStandalone()) return;

  globalContext.callMethod<JSAny?>(
    'addEventListener'.toJS,
    'beforeinstallprompt'.toJS,
    ((JSObject event) {
      // Suppress the browser's own mini-infobar; we offer it ourselves.
      event.callMethod<JSAny?>('preventDefault'.toJS);
      _deferred = event;
      setAvailable(true);
    }).toJS,
  );
  globalContext.callMethod<JSAny?>(
    'addEventListener'.toJS,
    'appinstalled'.toJS,
    ((JSAny? _) {
      _deferred = null;
      setAvailable(false);
    }).toJS,
  );
}

Future<void> prompt() async {
  final event = _deferred;
  if (event == null) return;
  _deferred = null; // a deferred prompt can only be used once
  event.callMethod<JSAny?>('prompt'.toJS);
  try {
    await (event['userChoice'] as JSPromise<JSAny?>).toDart;
  } catch (_) {}
}
