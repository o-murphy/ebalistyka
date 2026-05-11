#!/usr/bin/env bash
# Update the Flathub repo directory with a new release (from-source build).
#
# Usage: update-flathub.sh <tag> <flathub_repo_dir>
#   tag              — release tag, e.g. v0.1.12
#   flathub_repo_dir — path to a local clone of flathub/io.github.o_murphy.ebalistyka
#
# Requires: git, curl, sha256sum, python3 (for pub-sources generation)
set -euo pipefail

TAG="${1:?Usage: update-flathub.sh <tag> <flathub_repo_dir>}"
FLATHUB_DIR="${2:?}"
VERSION="${TAG#v}"
TODAY=$(date +%Y-%m-%d)
APP_ID="io.github.o_murphy.ebalistyka"
REPO="o-murphy/ebalistyka-app"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

FLUTTER_VERSION="3.41.6"
FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

echo "=== Updating Flathub repo for ${TAG} ==="

# ── Resolve commit SHA for the tag ───────────────────────────────────────────
echo "Resolving commit SHA for ${TAG}…"
COMMIT_SHA=$(git -C "${ROOT_DIR}" rev-list -n1 "${TAG}" 2>/dev/null || \
             curl -fsSL "https://api.github.com/repos/${REPO}/git/ref/tags/${TAG}" \
               | python3 -c "import sys,json; d=json.load(sys.stdin); \
                 print(d['object']['sha'] if d['object']['type']=='commit' else \
                 __import__('urllib.request',fromlist=['urlopen']).urlopen( \
                   'https://api.github.com/repos/${REPO}/git/tags/'+d['object']['sha']).read())" \
             2>/dev/null || echo "__COMMIT_SHA__")
echo "  commit: ${COMMIT_SHA}"

# ── Compute SHA256 of Flutter SDK ─────────────────────────────────────────────
echo "Fetching Flutter SDK SHA256…"
FLUTTER_SHA256=$(curl -fsSL "${FLUTTER_SDK_URL}" | sha256sum | awk '{print $1}')
echo "  Flutter ${FLUTTER_VERSION}: ${FLUTTER_SHA256}"

# ── Generate pub-sources.json ─────────────────────────────────────────────────
echo "Generating pub-sources.json…"
"${SCRIPT_DIR}/generate-pub-sources.sh" "${ROOT_DIR}/flatpak"
cp "${ROOT_DIR}/flatpak/pub-sources.json" "${FLATHUB_DIR}/pub-sources.json"

# ── Build manifest from template ─────────────────────────────────────────────
echo "Writing manifest…"
sed \
  -e "s|__VERSION__|${VERSION}|g" \
  -e "s|__COMMIT_SHA__|${COMMIT_SHA}|g" \
  -e "s|__SHA256_FLUTTER_SDK__|${FLUTTER_SHA256}|g" \
  "${ROOT_DIR}/flatpak/${APP_ID}.flathub.yml" > "${FLATHUB_DIR}/${APP_ID}.yml"

# ── Update metainfo release list ──────────────────────────────────────────────
METAINFO="${ROOT_DIR}/flatpak/${APP_ID}.metainfo.xml"
METAINFO_DEST="${FLATHUB_DIR}/${APP_ID}.metainfo.xml"
NEW_RELEASE="    <release version=\"${VERSION}\" date=\"${TODAY}\"/>"

cp "${METAINFO}" "${METAINFO_DEST}"
if grep -q "release version=\"${VERSION}\"" "${METAINFO_DEST}"; then
  echo "  metainfo: ${VERSION} already present"
else
  sed -i "/<releases>/a\\${NEW_RELEASE}" "${METAINFO_DEST}"
fi

echo "✓ Flathub repo ready at ${FLATHUB_DIR}"
echo ""
echo "Files:"
ls -lh "${FLATHUB_DIR}/"
echo ""
echo "NOTE: desktop, icon, and metainfo are managed in the upstream repo"
echo "      (flatpak/ directory) and installed from the git source during build."
echo "      Do NOT commit them separately into the Flathub repo."
