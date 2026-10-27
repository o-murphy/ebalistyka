import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('Blob')
extension type _Blob._(JSObject _) implements JSObject {
  external _Blob(JSArray<JSAny> parts, JSObject options);
}

@JS('URL.createObjectURL')
external String _createObjectUrl(_Blob blob);

@JS('window.open')
external JSAny? _windowOpen(String url, String target);

/// Opens [html] in a new browser tab (the web equivalent of the desktop
/// "open in default browser" path) via a `blob:` URL.
///
/// Must be called synchronously from the user gesture that triggered the
/// export, or the browser's popup blocker may swallow `window.open`.
Future<void> openHtmlInBrowser(String html) async {
  final options = JSObject()..['type'] = 'text/html;charset=utf-8'.toJS;
  final blob = _Blob([html.toJS].toJS, options);
  _windowOpen(_createObjectUrl(blob), '_blank');
}
