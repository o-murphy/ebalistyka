#!/usr/bin/env bash
# Verify an AppImage with the same host-glibc criterion used by AppImageHub.
set -euo pipefail

APPIMAGE="${1:?Usage: verify-appimage-glibc.sh <AppImage> [max_glibc_version]}"
MAX_GLIBC_VERSION="${2:-GLIBC_2.35}"

if [ ! -f "$APPIMAGE" ]; then
  echo "AppImage not found: $APPIMAGE" >&2
  exit 1
fi
APPIMAGE=$(realpath "$APPIMAGE")

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

echo "Extracting $(basename "$APPIMAGE")..."
(
  cd "$WORK_DIR"
  "$APPIMAGE" --appimage-extract >/dev/null
)

is_dynamic() {
  readelf -lW "$1" 2>/dev/null | grep -q 'Requesting program interpreter' \
    || readelf -dW "$1" 2>/dev/null | grep -q '(NEEDED)'
}

glibc_versions() {
  objdump -T "$1" 2>/dev/null | grep '\*UND\*' \
    | grep -oE 'GLIBC_[0-9]+(\.[0-9]+)+' || true
}

APPDIR="$WORK_DIR/squashfs-root"
PAYLOAD_VERSIONS="$WORK_DIR/payload-glibc-versions"
RUNTIME_VERSIONS="$WORK_DIR/runtime-glibc-versions"

while IFS= read -r -d '' file; do
  [ "$(od -An -tx1 -N4 "$file" 2>/dev/null)" = " 7f 45 4c 46" ] || continue
  is_dynamic "$file" && glibc_versions "$file" >> "$PAYLOAD_VERSIONS"
done < <(find "$APPDIR" -type f -print0)

# A bundled libc and loader mean that payload requirements do not come from
# the host. The AppImage runtime is always checked because it executes first.
loader=$(find "$APPDIR" \( -name 'ld-linux*.so*' -o -name 'ld-2.*.so' -o -name 'ld-musl-*.so.1' \) -print -quit)
libc=$(find "$APPDIR" \( -name 'libc.so.6' -o -name 'libc.musl-*.so.1' -o -name 'ld-musl-*.so.1' \) -print -quit)
if [ -n "$loader" ] && [ -n "$libc" ]; then
  : > "$PAYLOAD_VERSIONS"
fi

is_dynamic "$APPIMAGE" && glibc_versions "$APPIMAGE" >> "$RUNTIME_VERSIONS"
required_max=$(sort -Vu "$PAYLOAD_VERSIONS" "$RUNTIME_VERSIONS" | tail -n 1)

if [ -z "$required_max" ]; then
  echo "✓ AppImage does not require host glibc symbols"
  exit 0
fi

echo "Maximum required host glibc: $required_max (allowed: $MAX_GLIBC_VERSION)"
if [ "$(printf '%s\n%s\n' "$MAX_GLIBC_VERSION" "$required_max" | sort -V | tail -n 1)" != "$MAX_GLIBC_VERSION" ]; then
  echo "AppImage requires $required_max, which is newer than $MAX_GLIBC_VERSION" >&2
  exit 1
fi

echo "✓ AppImage is compatible with $MAX_GLIBC_VERSION"
