#!/usr/bin/env bash
# Package a pre-built Flutter Linux bundle into a self-contained AppImage.
#
# Usage: package-appimage.sh <bundle_dir> <arch_suffix> [build_name] [build_number]
#   bundle_dir   — path to the extracted Flutter Linux bundle
#   arch_suffix  — x86_64 | aarch64
#
# GTK3/glib/gdk-pixbuf and their dependencies are bundled via linuxdeploy +
# linuxdeploy-plugin-gtk so the AppImage doesn't depend on the host's GTK/glib
# ABI (see https://github.com/AppImage/appimage.github.io/pull/7817).
#
# Requirements: curl, appimagetool/linuxdeploy (downloaded automatically), zsyncmake (optional)
set -euo pipefail

BUNDLE_DIR="${1:?Usage: package-appimage.sh <bundle_dir> <arch_suffix>}"
ARCH_SUFFIX="${2:?}"
BUILD_NAME="${3:-local}"
BUILD_NUMBER="${4:-0}"

APPIMAGE_TOOL_URL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${ARCH_SUFFIX}.AppImage"
LINUXDEPLOY_URL="https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${ARCH_SUFFIX}.AppImage"
LINUXDEPLOY_GTK_PLUGIN_URL="https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-gtk/master/linuxdeploy-plugin-gtk.sh"

REPO_SLUG="${GITHUB_REPOSITORY:-}"
if [ -n "$REPO_SLUG" ]; then
  OWNER="${REPO_SLUG%%/*}"
  REPO="${REPO_SLUG##*/}"
  APPIMAGE_FILENAME="ebalistyka-${ARCH_SUFFIX}.AppImage"
  UPDATE_INFO="gh-releases-zsync|${OWNER}|${REPO}|latest|${APPIMAGE_FILENAME}.zsync"
  ZSYNC_URL="https://github.com/${REPO_SLUG}/releases/latest/download/${APPIMAGE_FILENAME}"
else
  UPDATE_INFO=""
  ZSYNC_URL=""
  echo "⚠️  GITHUB_REPOSITORY not set — skipping zsync"
fi

mkdir -p artifacts/appimage

# ── AppDir ─────────────────────────────────────────────────────────────────────────────
APPDIR=".appimage-build/AppDir"
rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/share/ebalistyka"

cp -a "${BUNDLE_DIR}/." "$APPDIR/usr/share/ebalistyka/"

# Icon
install -Dm644 "app/share/icons/hicolor/512x512/apps/io.github.o_murphy.ebalistyka.png" \
  "$APPDIR/usr/share/icons/hicolor/512x512/apps/io.github.o_murphy.ebalistyka.png"

# Desktop entry
install -Dm644 "app/share/applications/io.github.o_murphy.ebalistyka.desktop" \
  "$APPDIR/usr/share/applications/io.github.o_murphy.ebalistyka.desktop"

ln -sf "usr/share/applications/io.github.o_murphy.ebalistyka.desktop" "$APPDIR/io.github.o_murphy.ebalistyka.desktop"
ln -sf "usr/share/icons/hicolor/512x512/apps/io.github.o_murphy.ebalistyka.png" "$APPDIR/io.github.o_murphy.ebalistyka.png"

CUSTOM_APPRUN="$(mktemp)"
install -m755 /dev/stdin "$CUSTOM_APPRUN" <<'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")"
APPDIR="$HERE"
export APPDIR
APP_DIR="$HERE/usr/share/ebalistyka"
export LD_LIBRARY_PATH="$APP_DIR/lib:$HERE/usr/lib:$HERE/usr/lib/$(uname -m)-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

if [ -d "$HERE/apprun-hooks" ]; then
  for hook in "$HERE"/apprun-hooks/*.sh; do
    [ -f "$hook" ] && . "$hook"
  done
fi

exec "$APP_DIR/ebalistyka" "$@"
EOF

# ── Bundle GTK3/glib/gdk-pixbuf via linuxdeploy ────────────────────────────────────────────
echo "Downloading linuxdeploy (${ARCH_SUFFIX})..."
DEPLOY_DIR="$(mktemp -d)"
curl -fsSL "$LINUXDEPLOY_URL" -o "${DEPLOY_DIR}/linuxdeploy.AppImage"
curl -fsSL "$LINUXDEPLOY_GTK_PLUGIN_URL" -o "${DEPLOY_DIR}/linuxdeploy-plugin-gtk.sh"
chmod +x "${DEPLOY_DIR}/linuxdeploy.AppImage" "${DEPLOY_DIR}/linuxdeploy-plugin-gtk.sh"

echo "Bundling GTK3/glib into AppDir..."
PATH="${DEPLOY_DIR}:${PATH}" \
DEPLOY_GTK_VERSION=3 \
LD_LIBRARY_PATH="$APPDIR/usr/share/ebalistyka/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
  "${DEPLOY_DIR}/linuxdeploy.AppImage" \
    --appdir "$APPDIR" \
    --executable "$APPDIR/usr/share/ebalistyka/ebalistyka" \
    --desktop-file "$APPDIR/usr/share/applications/io.github.o_murphy.ebalistyka.desktop" \
    --icon-file "$APPDIR/usr/share/icons/hicolor/512x512/apps/io.github.o_murphy.ebalistyka.png" \
    --custom-apprun "$CUSTOM_APPRUN" \
    --plugin gtk

rm -rf "$DEPLOY_DIR" "$CUSTOM_APPRUN"

# ── Build AppImage ──────────────────────────────────────────────────────────────────────────
echo "Downloading appimagetool (${ARCH_SUFFIX})..."
curl -fsSL "$APPIMAGE_TOOL_URL" -o /tmp/appimagetool
chmod +x /tmp/appimagetool

APPIMAGE_OUT="artifacts/appimage/ebalistyka-${ARCH_SUFFIX}.AppImage"

SIGN_ARGS=()
if [ -n "${GPG_KEY_ID:-}" ]; then
  SIGN_ARGS=(--sign --sign-key "$GPG_KEY_ID")
  echo "✓ Signing AppImage with key $GPG_KEY_ID"
fi

if [ -n "$UPDATE_INFO" ]; then
  ARCH="${ARCH_SUFFIX}" /tmp/appimagetool "${SIGN_ARGS[@]}" --updateinformation "$UPDATE_INFO" "$APPDIR" "$APPIMAGE_OUT"
else
  ARCH="${ARCH_SUFFIX}" /tmp/appimagetool "${SIGN_ARGS[@]}" "$APPDIR" "$APPIMAGE_OUT"
fi
echo "✓ AppImage: $APPIMAGE_OUT"

# ── zsync ─────────────────────────────────────────────────────────────────────────────────
if [ -n "$ZSYNC_URL" ] && command -v zsyncmake &>/dev/null; then
  zsyncmake -u "$ZSYNC_URL" -o "${APPIMAGE_OUT}.zsync" "$APPIMAGE_OUT"
  echo "✓ zsync:    ${APPIMAGE_OUT}.zsync"
fi

# ── Cleanup ────────────────────────────────────────────────────────────────────────────
rm -rf ".appimage-build"

echo ""
echo "Artifacts:"
ls -lh artifacts/appimage/
