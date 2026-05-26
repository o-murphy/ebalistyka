#!/usr/bin/env bash
# Build a Flutter Linux app into a Snap package.
#
# Usage: package-snap.sh [build_name] [build_number]
#   build_name   — version string (e.g. 1.2.3 or 1.2.3-beta)
#   build_number — monotonic build number (e.g. 42)
#
# Requirements: snapcraft
#   CI (SNAPCRAFT_BUILD_ENVIRONMENT=host or CI=true) → --destructive-mode (no LXD)
#   Local                                            → --use-lxd (requires LXD)
#
# The snap version is set from build_name with '+' stripped (snap doesn't allow '+').
# Grade is set to 'devel' for prerelease tags (those containing '-'), 'stable' otherwise.
set -euo pipefail

BUILD_NAME="${1:-local}"
# BUILD_NUMBER is accepted for API parity with other package scripts but snap
# versions are strings, so the build number is appended only when not 'local'.
BUILD_NUMBER="${2:-0}"

SRC="packaging/snap"
SNAP_DIR="snap"

if [ ! -f "$SRC/snapcraft.yaml" ]; then
  echo "❌ $SRC/snapcraft.yaml not found — run from the project root" >&2
  exit 1
fi

# Mirror what CI does: copy packaging/snap → snap/ so snapcraft finds it
cp -r "$SRC" "$SNAP_DIR"
trap 'rm -rf "$SNAP_DIR"' EXIT

YAML="$SNAP_DIR/snapcraft.yaml"

# Snap version: strip '+' (not allowed), keep '-prerelease' suffix
VERSION="${BUILD_NAME%%+*}"

# Grade: devel for prerelease, stable for full releases
if [[ "$VERSION" == *-* ]]; then
  GRADE="devel"
else
  GRADE="stable"
fi

sed -i "s/^version: .*/version: '${VERSION}'/" "$YAML"
sed -i "s/^grade: .*/grade: ${GRADE}/" "$YAML"
echo "✓ Set snap version: ${VERSION} (grade: ${GRADE})"

# Copy icon into snap/gui so snapcraft picks it up
if [ -f "app/share/icons/hicolor/512x512/apps/io.github.o_murphy.ebalistyka.png" ]; then
  cp "app/share/icons/hicolor/512x512/apps/io.github.o_murphy.ebalistyka.png" "$SNAP_DIR/gui/ebalistyka.png"
  echo "✓ Icon copied"
else
  echo "❌ No icon found" >&2
  exit 1
fi

mkdir -p artifacts/snap

# Remove stale snap files so we pick up only the freshly built one
rm -f ebalistyka_*.snap

# Use destructive mode in CI; LXD locally
if [ "${CI:-}" = "true" ] || [ "${SNAPCRAFT_BUILD_ENVIRONMENT:-}" = "host" ]; then
  BUILD_FLAGS="--destructive-mode"
else
  BUILD_FLAGS="--use-lxd"
fi

echo "Building snap (${BUILD_FLAGS})..."
snapcraft pack "$SNAP_DIR" $BUILD_FLAGS

SNAP_FILE=$(ls ebalistyka_*.snap 2>/dev/null | head -1)
if [ -z "$SNAP_FILE" ]; then
  echo "❌ No snap file produced after build" >&2
  exit 1
fi

# Normalise output name to match the other Linux artifact naming convention
ARCH_SUFFIX=$(uname -m)  # x86_64 | aarch64
OUT="artifacts/snap/ebalistyka_linux_${ARCH_SUFFIX}.snap"
mv "$SNAP_FILE" "$OUT"
echo "✓ Snap: $OUT"

echo ""
echo "Artifacts:"
ls -lh artifacts/snap/
