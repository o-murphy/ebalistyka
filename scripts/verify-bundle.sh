#!/usr/bin/env bash
# Verify that a Flutter bundle contains the main executable and required native libraries.
#
# Usage: verify-bundle.sh <bundle_dir> <platform>
#   bundle_dir  — path to the Flutter build output (bundle/)
#   platform    — linux | windows
#
# Exits non-zero if critical files are missing.
set -euo pipefail

BUNDLE_DIR="${1:?Usage: verify-bundle.sh <bundle_dir> <platform>}"
PLATFORM="${2:?Usage: verify-bundle.sh <bundle_dir> <platform>}"

# ── Bundle directory ──────────────────────────────────────────────────────────
if [ ! -d "$BUNDLE_DIR" ]; then
  echo "ERROR: bundle directory not found: $BUNDLE_DIR"
  echo "Searching for executables under build/:"
  find build -maxdepth 8 \( -name "ebalistyka" -o -name "ebalistyka.exe" \) 2>/dev/null || true
  exit 1
fi

# ── Executable ────────────────────────────────────────────────────────────────
if [ "$PLATFORM" = "linux" ]; then
  EXE="$BUNDLE_DIR/ebalistyka"
else
  EXE="$BUNDLE_DIR/ebalistyka.exe"
fi

if [ ! -f "$EXE" ]; then
  echo "ERROR: executable not found: $EXE"
  ls -la "$BUNDLE_DIR/" || true
  exit 1
fi
echo "✓ Executable: $EXE"

# ── Native libraries ──────────────────────────────────────────────────────────
if [ "$PLATFORM" = "linux" ]; then
  SO_COUNT=$(find "$BUNDLE_DIR/lib" -name "*.so" 2>/dev/null | wc -l)
  if [ "$SO_COUNT" -eq 0 ]; then
    echo "ERROR: no .so files in $BUNDLE_DIR/lib/ — native libraries not bundled"
    ls -la "$BUNDLE_DIR/" || true
    exit 1
  fi
  echo "✓ Native libraries ($SO_COUNT .so files):"
  find "$BUNDLE_DIR/lib" -name "*.so" | sort | sed 's/^/  /'

  # Critical: bclibc_ffi — check presence, broken-symlink, and ELF format
  BCLIBC_SO="$BUNDLE_DIR/lib/libbclibc_ffi.so"
  if [ ! -e "$BCLIBC_SO" ]; then
    echo "ERROR: libbclibc_ffi.so not found in lib/"
    exit 1
  fi
  if [ ! -f "$BCLIBC_SO" ]; then
    echo "ERROR: libbclibc_ffi.so is a broken symlink → $(readlink "$BCLIBC_SO")"
    ls -la "$BUNDLE_DIR/lib/libbclibc_ffi"* 2>/dev/null || true
    exit 1
  fi
  if ! file -L "$BCLIBC_SO" | grep -q ELF; then
    echo "ERROR: libbclibc_ffi.so is not an ELF binary: $(file -L "$BCLIBC_SO")"
    exit 1
  fi
  echo "✓ libbclibc_ffi.so: $(file -L "$BCLIBC_SO" | cut -d: -f2- | xargs)"

  # FIXME: DEPRECATED DUE TO OBJECTBOX WAS REMOVED AS A DEPENDENCY
  # REMOVE THIS SECTION AFTER SUCCESSFULL MERGE TO THE MAIN BRANCH
  # # Critical: objectbox
  # OBJECTBOX_SO=$(find "$BUNDLE_DIR/lib" -name "libobjectbox*.so*" | head -1)
  # if [ -z "$OBJECTBOX_SO" ]; then
  #   echo "ERROR: libobjectbox not found in lib/ — database will not initialize"
  #   exit 1
  # fi
  # if [ ! -f "$OBJECTBOX_SO" ]; then
  #   echo "ERROR: $(basename "$OBJECTBOX_SO") is a broken symlink"
  #   exit 1
  # fi
  # echo "✓ $(basename "$OBJECTBOX_SO"): $(file -L "$OBJECTBOX_SO" | cut -d: -f2- | xargs)"

else
  DLL_COUNT=$(find "$BUNDLE_DIR" -maxdepth 1 -name "*.dll" 2>/dev/null | wc -l)
  if [ "$DLL_COUNT" -eq 0 ]; then
    echo "ERROR: no .dll files in $BUNDLE_DIR — native libraries not bundled"
    ls -la "$BUNDLE_DIR/" || true
    exit 1
  fi
  echo "✓ Native DLLs ($DLL_COUNT files):"
  find "$BUNDLE_DIR" -maxdepth 1 -name "*.dll" | sort | sed 's/^/  /'

  # Critical: bclibc_ffi — check PE header (MZ magic)
  BCLIBC_DLL=$(find "$BUNDLE_DIR" -maxdepth 1 -name "bclibc_ffi.dll" | head -1)
  if [ -z "$BCLIBC_DLL" ]; then
    echo "ERROR: bclibc_ffi.dll not found — app will crash on startup"
    exit 1
  fi
  MZ=$(od -A n -t x1 -N 2 "$BCLIBC_DLL" | tr -d ' \n')
  if [ "$MZ" != "4d5a" ]; then
    echo "ERROR: bclibc_ffi.dll missing MZ header (got: $MZ) — not a valid PE file"
    exit 1
  fi
  SIZE_KB=$(( $(wc -c < "$BCLIBC_DLL") / 1024 ))
  echo "✓ bclibc_ffi.dll: valid PE file (${SIZE_KB} KB)"
fi

echo "✓ Bundle verified OK"
