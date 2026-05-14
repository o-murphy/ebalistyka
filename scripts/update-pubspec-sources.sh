#!/usr/bin/env bash
# Regenerate flatpak/pubspec-sources.json from all project pubspec.lock files.
# Run this after any `flutter pub get` that changes dependencies.
#
# Usage (from project root):
#   bash scripts/update-pubspec-sources.sh
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

FF_REPO="/tmp/flatpak-flutter"
FF_VENV="/tmp/ff-venv"
OUT="flatpak/pubspec-sources.json"

PUBSPEC_LOCKS="pubspec.lock,\
packages/a7p/pubspec.lock,\
packages/bclibc_ffi/pubspec.lock,\
packages/ebalistyka_db/pubspec.lock"

# flutter_tools packages are needed for the offline `flutter pub get` step inside the sandbox.
# Try to find pubspec.lock from local Flutter SDK or from a previous flatpak-builder build.
FLUTTER_TOOLS_LOCK=""
if [ -n "${FLUTTER_ROOT:-}" ] && [ -f "$FLUTTER_ROOT/packages/flutter_tools/pubspec.lock" ]; then
  FLUTTER_TOOLS_LOCK="$FLUTTER_ROOT/packages/flutter_tools/pubspec.lock"
elif [ -f "$HOME/flutter/packages/flutter_tools/pubspec.lock" ]; then
  FLUTTER_TOOLS_LOCK="$HOME/flutter/packages/flutter_tools/pubspec.lock"
else
  LATEST_BUILD=$(find .flatpak-builder/build -name "pubspec.lock" -path "*/flutter_tools/*" 2>/dev/null | sort | tail -1)
  if [ -n "$LATEST_BUILD" ]; then
    FLUTTER_TOOLS_LOCK="$LATEST_BUILD"
  fi
fi

if [ -n "$FLUTTER_TOOLS_LOCK" ]; then
  echo "Including flutter_tools: $FLUTTER_TOOLS_LOCK"
  PUBSPEC_LOCKS="${PUBSPEC_LOCKS},${FLUTTER_TOOLS_LOCK}"
else
  echo "⚠️  flutter_tools/pubspec.lock not found — run a local flatpak build first, or set FLUTTER_ROOT"
fi

# ── Ensure flatpak-flutter is available ───────────────────────────────────────
if [ ! -d "$FF_REPO" ]; then
  echo "Cloning flatpak-flutter..."
  git clone --depth=1 https://github.com/TheAppgineer/flatpak-flutter.git "$FF_REPO"
fi

# ── Ensure Python venv with dependencies ─────────────────────────────────────
if [ ! -f "$FF_VENV/bin/python3" ]; then
  echo "Creating Python venv..."
  python3 -m venv "$FF_VENV"
  "$FF_VENV/bin/pip" install --quiet packaging PyYAML tomlkit
fi

# ── Run generator with tuple-bug fix ─────────────────────────────────────────
echo "Generating $OUT ..."
PYTHONPATH="$FF_REPO" "$FF_VENV/bin/python3" - "$PUBSPEC_LOCKS" "$OUT" << 'PYEOF'
import sys, json, yaml

# Inline the generator to work around the tuple return bug in pubspec_generator.py
from pubspec_generator.pubspec_generator import generate_sources

pubspec_paths = [p.strip() for p in sys.argv[1].split(',')]
outfile = sys.argv[2]

sources, deduped = generate_sources(pubspec_paths)

with open(outfile, 'w') as f:
    json.dump(sources, f, indent=4, sort_keys=False)
    f.write('\n')

print(f"  {len(sources)} source entries ({deduped} deduplicated) → {outfile}")
PYEOF

echo "✓ Done"
