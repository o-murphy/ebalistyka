#!/usr/bin/env bash
# Package a pre-built Flutter Linux bundle into a .rpm.
#
# Usage: package-rpm.sh <bundle_dir> <arch_suffix> [build_name] [build_number]
#   bundle_dir   — path to the extracted Flutter Linux bundle
#   arch_suffix  — x86_64 | aarch64
#
# Requirements: rpm-build (apt: rpm or dnf: rpm-build)
set -euo pipefail

BUNDLE_DIR="${1:?Usage: package-rpm.sh <bundle_dir> <arch_suffix>}"
ARCH_SUFFIX="${2:?}"
BUILD_NAME="${3:-local}"
BUILD_NUMBER="${4:-0}"

APP_ID="io.github.o_murphy.ebalistyka"

# rpm uses different arch name for aarch64
if [ "$ARCH_SUFFIX" = "x86_64" ]; then RPM_ARCH="x86_64"; else RPM_ARCH="aarch64"; fi

# Split version: "0.1.10-dev" → Version=0.1.10, Release=dev
RPM_VERSION="${BUILD_NAME%%-*}"
RPM_RELEASE="${BUILD_NAME#"$RPM_VERSION"}"
RPM_RELEASE="${RPM_RELEASE#-}"
if [ -z "$RPM_RELEASE" ]; then RPM_RELEASE="1"; fi

BUILD_ROOT="$(pwd)/.rpm-build"
rm -rf "$BUILD_ROOT"
mkdir -p "$BUILD_ROOT"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

SRC="$BUILD_ROOT/SOURCES"

# ── Install bundle ────────────────────────────────────────────────────────────
install -d "$SRC/opt/ebalistyka"
cp -a "${BUNDLE_DIR}/." "$SRC/opt/ebalistyka/"

# Wrapper
install -Dm755 /dev/stdin "$SRC/usr/bin/ebalistyka" <<'EOF'
#!/bin/sh
APP=/opt/ebalistyka
export LD_LIBRARY_PATH="$APP/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export EBALISTYKA_INSTALLER=rpm
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
install -Dm644 "$ICON" "$SRC/usr/share/icons/hicolor/512x512/apps/${APP_ID}.png"

# Desktop entry
install -Dm644 "flatpak/${APP_ID}.desktop" \
  "$SRC/usr/share/applications/${APP_ID}.desktop"

# AppStream metainfo (stamp version + date)
TODAY=$(date +%Y-%m-%d)
mkdir -p "$SRC/usr/share/metainfo"
sed "s|<release version=\"[^\"]*\" date=\"[^\"]*\"/>|<release version=\"${BUILD_NAME}\" date=\"${TODAY}\"/>|" \
  "flatpak/${APP_ID}.metainfo.xml" > "$SRC/usr/share/metainfo/${APP_ID}.metainfo.xml"

echo "✓ Sources prepared (version: ${RPM_VERSION}, release: ${RPM_RELEASE}, arch: ${RPM_ARCH})"

# ── Spec file ─────────────────────────────────────────────────────────────────
sed \
  -e "s/VERSION_PLACEHOLDER/${RPM_VERSION}/" \
  -e "s/RELEASE_PLACEHOLDER/${RPM_RELEASE}/" \
  -e "s/ARCH_PLACEHOLDER/${RPM_ARCH}/" \
  rpm/ebalistyka.spec > "$BUILD_ROOT/SPECS/ebalistyka.spec"

# ── Build .rpm ────────────────────────────────────────────────────────────────
rpmbuild \
  --define "_topdir $BUILD_ROOT" \
  --define "_build_id_links none" \
  --buildroot "$BUILD_ROOT/BUILDROOT" \
  -bb "$BUILD_ROOT/SPECS/ebalistyka.spec"

mkdir -p artifacts/rpm
OUT="artifacts/rpm/ebalistyka_linux_${ARCH_SUFFIX}.rpm"
find "$BUILD_ROOT/RPMS" -name "*.rpm" -exec cp {} "$OUT" \;

echo "✓ rpm: $OUT"

# ── Cleanup ───────────────────────────────────────────────────────────────────
rm -rf "$BUILD_ROOT"

echo ""
echo "Artifacts:"
ls -lh artifacts/rpm/
