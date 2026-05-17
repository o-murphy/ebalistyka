#!/usr/bin/env bash
# Update the Flathub repository directory for a new release.
# Called by .github/workflows/publish-flathub.yml
#
# Usage: update-flathub.sh <tag> <flathub-repo-dir>
#   tag             — git tag, e.g. v0.1.15
#   flathub-repo-dir — path to the cloned flathub/io.github.o_murphy.ebalistyka repo
set -euo pipefail

TAG="${1:?Usage: update-flathub.sh <tag> <flathub-repo-dir>}"
FLATHUB_DIR="${2:?}"
APP_ID="io.github.o_murphy.ebalistyka"

COMMIT=$(git rev-parse "${TAG}^{}")
VERSION="${TAG#v}"
TODAY=$(date +%Y-%m-%d)

echo "Tag:     $TAG"
echo "Commit:  $COMMIT"
echo "Version: $VERSION"
echo "Date:    $TODAY"

# ── Regenerate sources if not already fresh ───────────────────────────────────
if [ ! -f "flatpak/generated-sources.json" ]; then
  echo "generated-sources.json not found — running update-sources.sh first"
  "$(dirname "${BASH_SOURCE[0]}")/update-sources.sh"
fi

# ── Copy manifest and files it references ──────────────────────────────────
cp "flatpak/${APP_ID}.yml"              "${FLATHUB_DIR}/${APP_ID}.yml"
cp "flatpak/generated-sources.json"    "${FLATHUB_DIR}/generated-sources.json"
cp -r "flatpak/patches"                "${FLATHUB_DIR}/"

# ── Patch manifest: update app source tag + commit, drop temp patches ──────
python3 - "$TAG" "$COMMIT" "${FLATHUB_DIR}/${APP_ID}.yml" << 'PYEOF'
import sys

tag, commit, path = sys.argv[1], sys.argv[2], sys.argv[3]
lines = open(path).readlines()
out = []
i = 0

# Pass 1: update app source tag + commit (lines following ebalistyka-app.git URL)
in_app_source = False
while i < len(lines):
    line = lines[i]
    if 'github.com/o-murphy/ebalistyka-app.git' in line:
        in_app_source = True
        out.append(line)
    elif in_app_source and line.lstrip().startswith('tag:'):
        indent = len(line) - len(line.lstrip())
        out.append(' ' * indent + f'tag: {tag}\n')
    elif in_app_source and line.lstrip().startswith('commit:'):
        indent = len(line) - len(line.lstrip())
        out.append(' ' * indent + f'commit: {commit}\n')
        in_app_source = False
    else:
        out.append(line)
    i += 1

# Pass 2: remove temporary patch sources (only needed for old tags that
# predate the dual-mode bclibc_ffi plugin cmake changes)
TEMP_PATCHES = ('bclibc_ffi_plugin_cmake.patch', 'linux_cmake_bclibc_conditional.patch')
lines, out = out, []
i = 0
while i < len(lines):
    line = lines[i]
    if (line.lstrip().startswith('- type: patch')
            and i + 1 < len(lines)
            and any(p in lines[i + 1] for p in TEMP_PATCHES)):
        i += 2  # skip "- type: patch" + "  path: ..." lines
    else:
        out.append(line)
        i += 1

open(path, 'w').writelines(out)
print(f"  manifest updated: tag={tag}, commit={commit[:12]}")
PYEOF

# ── Update metainfo release entry ──────────────────────────────────────────
sed -i \
  "s|<release version=\"[^\"]*\" date=\"[^\"]*\"/>|<release version=\"${VERSION}\" date=\"${TODAY}\"/>|" \
  "flatpak/${APP_ID}.metainfo.xml"

echo "✓ Flathub repo updated for ${TAG}"
