#!/usr/bin/env bash
# Update aur/PKGBUILD to a new version and recompute checksums.
# Run this after a GitHub Release is published.
#
# Usage: update-aur.sh <version>
#   version — e.g. 0.1.10  or  0.1.10-dev
set -euo pipefail

VERSION="${1:?Usage: update-aur.sh <version>}"
TAG="v${VERSION}"
REPO="o-murphy/ebalistyka"
APP_ID="io.github.o_murphy.ebalistyka"

echo "Updating AUR PKGBUILD → ${VERSION} (${TAG})"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

BASE_REL="https://github.com/${REPO}/releases/download/${TAG}"
BASE_RAW="https://raw.githubusercontent.com/${REPO}/${TAG}"

echo "Downloading release tarballs..."
curl -fsSL "${BASE_REL}/ebalistyka_linux_x86_64.tar.gz"  -o "${TMP}/x86_64.tar.gz"
curl -fsSL "${BASE_REL}/ebalistyka_linux_aarch64.tar.gz" -o "${TMP}/aarch64.tar.gz"

echo "Downloading metadata files..."
curl -fsSL "${BASE_RAW}/app/share/applications/${APP_ID}.desktop" -o "${TMP}/desktop"
curl -fsSL "${BASE_RAW}/app/share/icons/hicolor/512x512/apps/${APP_ID}.png" -o "${TMP}/icon"
curl -fsSL "${BASE_RAW}/app/share/metainfo/${APP_ID}.metainfo.xml" -o "${TMP}/metainfo"

SUM_X86=$(sha256sum "${TMP}/x86_64.tar.gz"  | cut -d' ' -f1)
SUM_A64=$(sha256sum "${TMP}/aarch64.tar.gz" | cut -d' ' -f1)
SUM_DT=$(sha256sum  "${TMP}/desktop"        | cut -d' ' -f1)
SUM_IC=$(sha256sum  "${TMP}/icon"           | cut -d' ' -f1)
SUM_MT=$(sha256sum  "${TMP}/metainfo"       | cut -d' ' -f1)

echo "sha256 x86_64:   ${SUM_X86}"
echo "sha256 aarch64:  ${SUM_A64}"
echo "sha256 desktop:  ${SUM_DT}"
echo "sha256 icon:     ${SUM_IC}"
echo "sha256 metainfo: ${SUM_MT}"

PKGBUILD="packaging/aur/PKGBUILD"
sed -i \
    -e "s/_pkgver=\"[^\"]*\"/_pkgver=\"${VERSION}\"/" \
    -e "s/sha256sums=('[^']*' '[^']*' '[^']*')/sha256sums=('${SUM_DT}' '${SUM_IC}' '${SUM_MT}')/" \
    -e "s/sha256sums_x86_64=('[^']*')/sha256sums_x86_64=('${SUM_X86}')/" \
    -e "s/sha256sums_aarch64=('[^']*')/sha256sums_aarch64=('${SUM_A64}')/" \
    "$PKGBUILD"

echo "✓ aur/PKGBUILD updated"

if command -v makepkg &>/dev/null; then
    (cd aur && makepkg --printsrcinfo > .SRCINFO)
    echo "✓ aur/.SRCINFO regenerated"
else
    echo "⚠ makepkg not found — run on Arch: cd aur && makepkg --printsrcinfo > .SRCINFO"
fi

echo ""
echo "Next: push to AUR git repo:"
echo "  cd /path/to/aur-clone && cp /path/to/repo/packaging/aur/PKGBUILD aur/.SRCINFO . && git add -A && git commit -m 'upgpkg: ebalistyka-bin ${VERSION}' && git push"
