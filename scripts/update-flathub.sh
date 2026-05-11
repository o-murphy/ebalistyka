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
if git -C "${ROOT_DIR}" rev-list -n1 "${TAG}" &>/dev/null; then
  COMMIT_SHA=$(git -C "${ROOT_DIR}" rev-list -n1 "${TAG}")
else
  # Resolve via GitHub API, handling both lightweight and annotated tags
  REF_JSON=$(curl -fsSL "https://api.github.com/repos/${REPO}/git/ref/tags/${TAG#refs/tags/}")
  OBJ_TYPE=$(echo "${REF_JSON}" | python3 -c "import sys,json; print(json.load(sys.stdin)['object']['type'])")
  OBJ_SHA=$(echo "${REF_JSON}"  | python3 -c "import sys,json; print(json.load(sys.stdin)['object']['sha'])")
  if [ "${OBJ_TYPE}" = "tag" ]; then
    COMMIT_SHA=$(curl -fsSL "https://api.github.com/repos/${REPO}/git/tags/${OBJ_SHA}" \
      | python3 -c "import sys,json; print(json.load(sys.stdin)['object']['sha'])")
  else
    COMMIT_SHA="${OBJ_SHA}"
  fi
fi
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

# ── Bump release entry in upstream metainfo ───────────────────────────────────
# metainfo.xml stays in the upstream repo (flatpak/); it is installed from the
# git source during the Flatpak build.  We only update it here in-place so the
# release list is current before tagging.
METAINFO="${ROOT_DIR}/flatpak/${APP_ID}.metainfo.xml"
NEW_RELEASE="    <release version=\"${VERSION}\" date=\"${TODAY}\"/>"

if grep -q "release version=\"${VERSION}\"" "${METAINFO}"; then
  echo "  metainfo: ${VERSION} already present"
else
  sed -i "/<releases>/a\\${NEW_RELEASE}" "${METAINFO}"
  echo "  metainfo: added release ${VERSION}"
fi

echo "✓ Flathub repo ready at ${FLATHUB_DIR}"
echo ""
echo "Files:"
ls -lh "${FLATHUB_DIR}/"
