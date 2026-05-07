#!/usr/bin/env bash
# Package a pre-built Flutter Linux bundle into an AppImage.
#
# Usage: package-appimage.sh <bundle_dir> <arch_suffix> [build_name] [build_number]
#   bundle_dir   — path to the extracted Flutter Linux bundle
#   arch_suffix  — x86_64 | aarch64
#
# Requirements: curl, appimagetool (downloaded automatically), zsyncmake (optional)
set -euo pipefail

BUNDLE_DIR="${1:?Usage: package-appimage.sh <bundle_dir> <arch_suffix>}"
ARCH_SUFFIX="${2:?}"
BUILD_NAME="${3:-local}"
BUILD_NUMBER="${4:-0}"

APPIMAGE_TOOL_URL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${ARCH_SUFFIX}.AppImage"

REPO_SLUG="${GITHUB_REPOSITORY:-}"
if [ -n "$REPO_SLUG" ]; then
  OWNER="${REPO_SLUG%%/*}"
  REPO="${REPO_SLUG##*/}"
  APPIMAGE_FILENAME="ebalistyka_linux_${ARCH_SUFFIX}.AppImage"
  UPDATE_INFO="gh-releases-zsync|${OWNER}|${REPO}|latest|${APPIMAGE_FILENAME}.zsync"
  ZSYNC_URL="https://github.com/${REPO_SLUG}/releases/latest/download/${APPIMAGE_FILENAME}"
else
  UPDATE_INFO=""
  ZSYNC_URL=""
  echo "⚠️  GITHUB_REPOSITORY not set — skipping zsync"
fi

mkdir -p artifacts/appimage

# ── AppDir ────────────────────────────────────────────────────────────────────
APPDIR=".appimage-build/AppDir"
rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/share/ebalistyka"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/256x256/apps"

cp -a "${BUNDLE_DIR}/." "$APPDIR/usr/share/ebalistyka/"

# Icon
ICON_SOURCE=""
if [ -f "assets/icon_512x512.png" ]; then
  ICON_SOURCE="assets/icon_512x512.png"
elif [ -f "assets/icon.png" ]; then
  ICON_SOURCE="assets/icon.png"
fi

if [ -n "$ICON_SOURCE" ]; then
  cp "$ICON_SOURCE" "$APPDIR/usr/share/icons/hicolor/256x256/apps/ebalistyka.png"
  echo "✓ Icon: $ICON_SOURCE"
else
  echo "❌ No icon found" >&2; exit 1
fi

install -Dm644 /dev/stdin "$APPDIR/usr/share/applications/ebalistyka.desktop" <<'EOF'
[Desktop Entry]
Name=eBalistyka
Comment=Ballistic calculator
Exec=ebalistyka
Icon=ebalistyka
Type=Application
Categories=Utility;Science;
StartupWMClass=ebalistyka
EOF

ln -sf usr/share/applications/ebalistyka.desktop "$APPDIR/ebalistyka.desktop"
ln -sf usr/share/icons/hicolor/256x256/apps/ebalistyka.png "$APPDIR/ebalistyka.png"

install -m755 /dev/stdin "$APPDIR/AppRun" <<'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")"
APP_DIR="$HERE/usr/share/ebalistyka"
export LD_LIBRARY_PATH="$APP_DIR/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
exec "$APP_DIR/ebalistyka" "$@"
EOF

# ── Build AppImage ────────────────────────────────────────────────────────────
echo "Downloading appimagetool (${ARCH_SUFFIX})..."
curl -fsSL "$APPIMAGE_TOOL_URL" -o /tmp/appimagetool
chmod +x /tmp/appimagetool

APPIMAGE_OUT="artifacts/appimage/ebalistyka_linux_${ARCH_SUFFIX}.AppImage"

if [ -n "$UPDATE_INFO" ]; then
  ARCH="${ARCH_SUFFIX}" /tmp/appimagetool --updateinformation "$UPDATE_INFO" "$APPDIR" "$APPIMAGE_OUT"
else
  ARCH="${ARCH_SUFFIX}" /tmp/appimagetool "$APPDIR" "$APPIMAGE_OUT"
fi
echo "✓ AppImage: $APPIMAGE_OUT"

# ── zsync ─────────────────────────────────────────────────────────────────────
if [ -n "$ZSYNC_URL" ] && command -v zsyncmake &>/dev/null; then
  zsyncmake -u "$ZSYNC_URL" -o "${APPIMAGE_OUT}.zsync" "$APPIMAGE_OUT"
  echo "✓ zsync:    ${APPIMAGE_OUT}.zsync"
fi

# ── Cleanup ───────────────────────────────────────────────────────────────────
rm -rf ".appimage-build"

echo ""
echo "Artifacts:"
ls -lh artifacts/appimage/
