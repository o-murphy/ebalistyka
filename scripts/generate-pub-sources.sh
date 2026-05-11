#!/usr/bin/env bash
# Generate pub-sources.json for the flatpak offline build.
#
# Requires: Python 3, pip (flatpak-builder-tools dart generator)
#
# Usage: scripts/generate-pub-sources.sh [output_dir]
#   output_dir — directory where pub-sources.json is written (default: flatpak/)
set -euo pipefail

OUTPUT_DIR="${1:-flatpak}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

GENERATOR_REPO="https://github.com/flatpak/flatpak-builder-tools.git"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

echo "=== Generating pub-sources.json ==="
echo "Cloning flatpak-builder-tools…"
git clone --depth=1 --filter=blob:none --sparse "${GENERATOR_REPO}" "${WORK_DIR}/flatpak-builder-tools"
cd "${WORK_DIR}/flatpak-builder-tools"
git sparse-checkout set dart

echo "Setting up Python venv…"
python3 -m venv "${WORK_DIR}/venv"
"${WORK_DIR}/venv/bin/pip" install -q toml

echo "Running dart generator against pubspec.lock…"
"${WORK_DIR}/venv/bin/python3" "${WORK_DIR}/flatpak-builder-tools/dart/flatpak-dart-generator.py" \
  "${ROOT_DIR}/pubspec.lock" \
  -o "${ROOT_DIR}/${OUTPUT_DIR}/pub-sources.json"

echo "✓ Written to ${ROOT_DIR}/${OUTPUT_DIR}/pub-sources.json"
