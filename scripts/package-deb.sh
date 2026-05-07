#!/usr/bin/env bash
# Package a pre-built Flutter Linux bundle into a .deb.
#
# Usage: package-deb.sh <bundle_dir> <arch_suffix> [build_name] [build_number]
#   bundle_dir   — path to the extracted Flutter Linux bundle
#   arch_suffix  — x86_64 | aarch64
#
# Requirements: dpkg-deb (apt: dpkg-dev)
set -euo pipefail

BUNDLE_DIR="${1:?Usage: package-deb.sh <bundle_dir> <arch_suffix>}"
ARCH_SUFFIX="${2:?}"
BUILD_NAME="${3:-local}"
BUILD_NUMBER="${4:-0}"

APP_ID="io.github.o_murphy.ebalistyka"

# deb uses different arch names
if [ "$ARCH_SUFFIX" = "x86_64" ]; then DEB_ARCH="amd64"; else DEB_ARCH="arm64"; fi

PKG_DIR=".deb-pkg"
rm -rf "$PKG_DIR"

# ── Install bundle ────────────────────────────────────────────────────────────
install -d "$PKG_DIR/opt/ebalistyka"
cp -a "${BUNDLE_DIR}/." "$PKG_DIR/opt/ebalistyka/"

# Wrapper
install -Dm755 /dev/stdin "$PKG_DIR/usr/bin/ebalistyka" <<'EOF'
#!/bin/sh
APP=/opt/ebalistyka
export LD_LIBRARY_PATH="$APP/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export EBALISTYKA_INSTALLER=deb
exec "$APP/ebalistyka" "$@"
EOF

# Icon
if [ -f "assets/icon_512x512.png" ]; then
  ICON="assets/icon_512x512.png"
elif [ -f "assets/icon.png" ]; then
  ICON="assets/icon.png"
else
  echo "❌ No icon found" >&2; exit 1
fi
install -Dm644 "$ICON" "$PKG_DIR/usr/share/icons/hicolor/512x512/apps/${APP_ID}.png"

# Desktop entry
install -Dm644 "flatpak/${APP_ID}.desktop" \
  "$PKG_DIR/usr/share/applications/${APP_ID}.desktop"

# AppStream metainfo (stamp version + date)
TODAY=$(date +%Y-%m-%d)
mkdir -p "$PKG_DIR/usr/share/metainfo"
sed "s|<release version=\"[^\"]*\" date=\"[^\"]*\"/>|<release version=\"${BUILD_NAME}\" date=\"${TODAY}\"/>|" \
  "flatpak/${APP_ID}.metainfo.xml" > "$PKG_DIR/usr/share/metainfo/${APP_ID}.metainfo.xml"

# ── DEBIAN/control ────────────────────────────────────────────────────────────
INSTALLED_SIZE=$(du -sk "$PKG_DIR" | cut -f1)
install -d "$PKG_DIR/DEBIAN"
sed \
  -e "s/VERSION_PLACEHOLDER/${BUILD_NAME}/" \
  -e "s/ARCH_PLACEHOLDER/${DEB_ARCH}/" \
  -e "s/INSTALLED_SIZE_PLACEHOLDER/${INSTALLED_SIZE}/" \
  deb/control > "$PKG_DIR/DEBIAN/control"

echo "✓ Package prepared (version: ${BUILD_NAME}, arch: ${DEB_ARCH})"

# ── Build .deb ────────────────────────────────────────────────────────────────
mkdir -p artifacts/deb
OUT="artifacts/deb/ebalistyka_linux_${ARCH_SUFFIX}.deb"
dpkg-deb --build --root-owner-group "$PKG_DIR" "$OUT"

echo "✓ deb: $OUT"

# ── Cleanup ───────────────────────────────────────────────────────────────────
rm -rf "$PKG_DIR"

echo ""
echo "Artifacts:"
ls -lh artifacts/deb/
