#!/usr/bin/env bash
# Package a Flutter Linux bundle into a portable tar.gz.
#
# Usage: package-linux.sh <bundle_dir> <arch_suffix>
#   arch_suffix  — x86_64 | aarch64
set -euo pipefail

BUNDLE_DIR="${1:?Usage: package-linux.sh <bundle_dir> <arch_suffix>}"
ARCH_SUFFIX="${2:?}"

mkdir -p artifacts/portable

TAR_OUT="artifacts/portable/ebalistyka_linux_${ARCH_SUFFIX}.tar.gz"
tar -czf "$TAR_OUT" -C "$BUNDLE_DIR" .
echo "✓ tar.gz: $TAR_OUT"

echo ""
echo "Artifacts:"
ls -lh artifacts/portable/
