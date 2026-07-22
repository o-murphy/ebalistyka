{{flutter_js}}
{{flutter_build_config}}

// Force the locally-bundled CanvasKit assets (build/web/canvaskit/) instead
// of the default gstatic.com CDN fallback — a LAN-only client with no
// internet route to Google's CDN would otherwise hang forever on the
// splash screen waiting for a CanvasKit fetch that never completes, even
// though the Dart app itself boots fine (main() runs, state seeds) since
// that part doesn't depend on the network at all.
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/",
  },
});
