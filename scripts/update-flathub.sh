#!/usr/bin/env bash
# Update the Flathub repo directory with a new release.
#
# Usage: update-flathub.sh <tag> <flathub_repo_dir>
#   tag             — release tag, e.g. v0.1.12
#   flathub_repo_dir — path to a local clone of flathub/io.github.o_murphy.ebalistyka
#
# Secrets/env expected: none (downloads from public GitHub Releases).
set -euo pipefail

TAG="${1:?Usage: update-flathub.sh <tag> <flathub_repo_dir>}"
FLATHUB_DIR="${2:?}"
VERSION="${TAG#v}"
TODAY=$(date +%Y-%m-%d)
APP_ID="io.github.o_murphy.ebalistyka"
REPO="o-murphy/ebalistyka-app"
BASE_URL="https://github.com/${REPO}/releases/download/${TAG}"

echo "=== Updating Flathub repo for ${TAG} ==="

# ── Compute SHA256 of release archives ───────────────────────────────────────
echo "Fetching SHA256 hashes…"
AMD64_SHA256=$(curl -fsSL "${BASE_URL}/ebalistyka_linux_x86_64.tar.gz" | sha256sum | awk '{print $1}')
ARM64_SHA256=$(curl -fsSL "${BASE_URL}/ebalistyka_linux_aarch64.tar.gz" | sha256sum | awk '{print $1}')
echo "  x86_64:  ${AMD64_SHA256}"
echo "  aarch64: ${ARM64_SHA256}"

# ── Copy static files ─────────────────────────────────────────────────────────
cp "flatpak/ebalistyka-wrapper.sh"      "${FLATHUB_DIR}/ebalistyka-wrapper.sh"
cp "flatpak/${APP_ID}.desktop"          "${FLATHUB_DIR}/${APP_ID}.desktop"

if [ -f "assets/icon_512x512.png" ]; then
  cp "assets/icon_512x512.png" "${FLATHUB_DIR}/${APP_ID}.png"
else
  cp "assets/icon.png" "${FLATHUB_DIR}/${APP_ID}.png"
fi

# ── Build manifest from template ─────────────────────────────────────────────
sed \
  -e "s|__VERSION__|${VERSION}|g" \
  -e "s|__SHA256_X86_64__|${AMD64_SHA256}|g" \
  -e "s|__SHA256_AARCH64__|${ARM64_SHA256}|g" \
  "flatpak/${APP_ID}.flathub.yml" > "${FLATHUB_DIR}/${APP_ID}.yml"

# ── Update metainfo ───────────────────────────────────────────────────────────
METAINFO="${FLATHUB_DIR}/${APP_ID}.metainfo.xml"
NEW_RELEASE="    <release version=\"${VERSION}\" date=\"${TODAY}\"/>"

if [ ! -f "$METAINFO" ]; then
  # First run: copy template, replace placeholder with real version
  cp "flatpak/${APP_ID}.metainfo.xml" "$METAINFO"
  sed -i "s|<release version=\"[^\"]*\" date=\"[^\"]*\"/>|${NEW_RELEASE}|" "$METAINFO"
else
  # Subsequent runs: prepend new release entry, skip if version already present
  if grep -q "release version=\"${VERSION}\"" "$METAINFO"; then
    echo "  metainfo: ${VERSION} already present, skipping"
  else
    sed -i "/<releases>/a\\${NEW_RELEASE}" "$METAINFO"
  fi
fi

echo "✓ Flathub repo ready at ${FLATHUB_DIR}"
echo ""
echo "Files:"
ls -lh "${FLATHUB_DIR}/"
