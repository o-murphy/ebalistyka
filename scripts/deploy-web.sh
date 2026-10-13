#!/usr/bin/env bash
# Manually publishes an already-built web bundle (build/web, see
# scripts/build-web.sh) to the gh-pages branch of a remote. Nothing is
# automatic: run it yourself, it asks before pushing.
#
#   scripts/build-web.sh
#   scripts/deploy-web.sh                       # remote "origin", branch gh-pages
#   REMOTE=bclab scripts/deploy-web.sh          # another remote
#   scripts/deploy-web.sh --yes                 # skip the confirmation
#
# The branch gets ONE fresh commit with the bundle each time (history of the
# deploy branch is not kept — it is force-pushed). The working tree and the
# current branch are not touched: the commit is built in a temp directory.
#
# One-time on GitHub: Settings → Pages → Source: "Deploy from a branch",
# Branch: gh-pages, folder: / (root). With web/CNAME (custom domain) also:
# DNS CNAME record <sub> -> <user>.github.io, Custom domain in Pages
# settings, Enforce HTTPS, and verify the domain at the account level.
set -euo pipefail

REMOTE="${REMOTE:-origin}"
BRANCH="${BRANCH:-gh-pages}"
YES=0
[ "${1:-}" = "--yes" ] && YES=1

cd "$(dirname "$0")/.."
OUT=build/web

[ -f "$OUT/index.html" ] && [ -f "$OUT/.nojekyll" ] \
  || { echo "ERROR: $OUT is not a built bundle — run scripts/build-web.sh first" >&2; exit 1; }

URL="$(git remote get-url "$REMOTE")"
SRC_REV="$(git rev-parse --short HEAD)"
SRC_DIRTY=""
[ -n "$(git status --porcelain)" ] && SRC_DIRTY=" (+uncommitted changes)"
BASE_HREF="$(grep -o '<base href="[^"]*"' "$OUT/index.html" | head -1 | sed 's/.*href="//; s/"$//')"

echo "Bundle:     $OUT  (base href: $BASE_HREF)"
echo "Built from: $SRC_REV$SRC_DIRTY"
echo "Publish to: $URL  branch '$BRANCH'  (force-push, replaces its contents)"
if [ -f "$OUT/CNAME" ]; then
  DOMAIN="$(head -1 "$OUT/CNAME")"
  echo "Pages URL:  https://$DOMAIN/"
  [ "$BASE_HREF" = "/" ] \
    || { echo "ERROR: custom domain $DOMAIN needs base href '/', bundle has '$BASE_HREF' — rebuild" >&2; exit 1; }
else
  echo "Pages URL:  https://<user>.github.io$BASE_HREF  (no CNAME in the bundle)"
fi
echo

if [ "$YES" -ne 1 ]; then
  read -r -p "Push? [y/N] " ans
  [ "$ans" = "y" ] || [ "$ans" = "Y" ] || { echo "Aborted."; exit 1; }
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cp -a "$OUT"/. "$TMP"/
git -C "$TMP" init -q -b "$BRANCH"
git -C "$TMP" add -A
git -C "$TMP" -c user.name="$(git config user.name)" -c user.email="$(git config user.email)" \
  commit -q -m "Deploy web bundle from $SRC_REV$SRC_DIRTY"
git -C "$TMP" push -f "$URL" "$BRANCH"

echo
echo "Published to $URL ($BRANCH). GitHub Pages may take a minute to update."
