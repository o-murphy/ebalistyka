#!/usr/bin/env bash
# Builds the release web bundle for GitHub Pages into build/web.
#
# Base href, unless BASE_HREF is given explicitly:
#   web/CNAME present  -> "/"            (custom domain, served from its root)
#   no web/CNAME       -> "/ebalistyka/" (https://<user>.github.io/ebalistyka/)
#
#   scripts/build-web.sh
#   BASE_HREF=/ebalistyka/ scripts/build-web.sh
#
# web/CNAME is copied into the bundle by Flutter, so it ends up in the
# gh-pages branch (GitHub reads the custom domain from it; a force-pushed
# deploy without it would drop the domain).
#
# Does not publish anything — see scripts/deploy-web.sh.
set -euo pipefail

cd "$(dirname "$0")/.."

if [ -z "${BASE_HREF:-}" ]; then
  if [ -f web/CNAME ]; then BASE_HREF=/; else BASE_HREF=/ebalistyka/; fi
fi
case "$BASE_HREF" in
  /|/*/) ;;
  *) echo "ERROR: BASE_HREF must start and end with '/', got '$BASE_HREF'" >&2; exit 1 ;;
esac

OUT=build/web

flutter build web --release --base-href "$BASE_HREF"

# GitHub Pages runs Jekyll by default, which skips files/dirs starting with
# '_' or '.' — it must be told not to touch the bundle.
touch "$OUT/.nojekyll"

# The router uses hash URLs, so deep links never reach the server; this is
# only a safety net so an unknown path still lands on the app.
cp "$OUT/index.html" "$OUT/404.html"

# ── Sanity checks ────────────────────────────────────────────────────────
fail=0
need() { [ -e "$OUT/$1" ] || { echo "MISSING: $1" >&2; fail=1; }; }
need index.html
need flutter_bootstrap.js
need main.dart.js
need manifest.json
need canvaskit/canvaskit.wasm     # local CanvasKit, no gstatic.com CDN
need download/index.html

# Custom domain: CNAME must be in the bundle and the app must sit at the root.
if [ -f web/CNAME ]; then
  need CNAME
  if [ "$BASE_HREF" != "/" ]; then
    echo "WARN: web/CNAME is set ($(head -1 web/CNAME)) but BASE_HREF is '$BASE_HREF'; a custom domain serves the app from '/'" >&2
  fi
fi

grep -q "<base href=\"$BASE_HREF\">" "$OUT/index.html" \
  || { echo "ERROR: base href in index.html is not '$BASE_HREF'" >&2; fail=1; }

# The bundle must use the local CanvasKit (web/flutter_bootstrap.js sets
# canvasKitBaseUrl) — the default prefers the gstatic.com CDN, which hangs
# the splash screen forever for a client with no route to it.
grep -q 'canvasKitBaseUrl: "canvaskit/"' "$OUT/flutter_bootstrap.js" \
  || { echo "ERROR: flutter_bootstrap.js does not force the local CanvasKit" >&2; fail=1; }

[ "$fail" -eq 0 ] || exit 1

echo
echo "Web bundle ready: $OUT  (base href $BASE_HREF)"
[ -f "$OUT/CNAME" ] && echo "Custom domain: $(head -1 "$OUT/CNAME")"
du -sh "$OUT" | awk '{print "Total size: " $1}'
