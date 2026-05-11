#!/usr/bin/env bash
# Generate pub-sources.json for the flatpak offline build.
#
# Requires: Python 3, PyYAML (installed automatically via venv)
#
# Usage: scripts/generate-pub-sources.sh [output_dir]
#   output_dir — directory where pub-sources.json is written (default: flatpak/)
set -euo pipefail

OUTPUT_DIR="${1:-flatpak}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

echo "=== Generating pub-sources.json ==="

echo "Setting up Python venv…"
python3 -m venv "${WORK_DIR}/venv"
"${WORK_DIR}/venv/bin/pip" install -q pyyaml

echo "Running pub generator against pubspec.lock…"
"${WORK_DIR}/venv/bin/python3" "${SCRIPT_DIR}/flatpak-pub-generator.py" \
  "${ROOT_DIR}/pubspec.lock" \
  -o "${ROOT_DIR}/${OUTPUT_DIR}/pub-sources.json"
