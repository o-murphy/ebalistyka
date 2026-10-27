/// Native platforms never reach this — [TableHtmlExporter] only calls it
/// under `kIsWeb`. See `open_html_web.dart` for the real implementation.
Future<void> openHtmlInBrowser(String html) =>
    throw UnsupportedError('openHtmlInBrowser is web-only');
