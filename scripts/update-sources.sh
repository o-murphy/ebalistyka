#!/usr/bin/env bash
# Regenerate flatpak/generated-sources.json using flatpak_gen.
# Requires: dart SDK, git
# Usage: scripts/update-sources.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

FLUTTER_VERSION="$(cat flatpak/flutter.version)"

# ── Install Flutter at pinned version ────────────────────────────────────────
FLUTTER_DIR="${RUNNER_TEMP:-/tmp}/flutter-${FLUTTER_VERSION}"
if [ ! -f "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Cloning Flutter $FLUTTER_VERSION..."
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 \
    --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git \
    "$FLUTTER_DIR"
fi
export FLUTTER_ROOT="$FLUTTER_DIR"

# ── Build flatpak_gen ─────────────────────────────────────────────────────────
TOOL_DIR="${RUNNER_TEMP:-/tmp}/flatpak_gen_tool"
TOOL_BIN="${RUNNER_TEMP:-/tmp}/flatpak_gen"
if [ ! -f "$TOOL_BIN" ]; then
  echo "Building flatpak_gen..."
  rm -rf "$TOOL_DIR"
  git clone --depth 1 \
    https://github.com/o-murphy/flutter_flatpak_gen.git \
    "$TOOL_DIR"
  cd "$TOOL_DIR"
  dart pub get
  dart compile exe bin/flatpak_gen.dart -o "$TOOL_BIN"
  cd "$REPO_ROOT"
fi

# ── Generate sources ──────────────────────────────────────────────────────────
echo "Generating flatpak/generated-sources.json..."
"$TOOL_BIN" sources \
  --lock pubspec.lock \
  --lock "$FLUTTER_ROOT/packages/flutter_tools/pubspec.lock" \
  --sdk "$FLUTTER_ROOT" \
  --output flatpak/generated-sources.json \
  --patch patches/flutter/shared.sh.patch

echo "✓ flatpak/generated-sources.json updated"
