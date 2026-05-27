#!/usr/bin/env bash

set_flatpak_bundle_output() {
  local arch="${MATRIX_ARCH:-${INPUT_ARCH:-amd64}}"
  local suffix
  case "$arch" in
    amd64)          suffix="x86_64"  ;;
    arm64|aarch64)  suffix="aarch64" ;;
    *)              suffix="x86_64"  ;;
  esac
  echo "bundle=ebalistyka_linux_${suffix}.flatpak" >> "$GITHUB_OUTPUT"
}

# Use dbus-run-session only when there is no existing dbus session (e.g. CI).
# Locally a desktop session is already running, so spawning a nested one
# conflicts with the FUSE document portal already mounted at /run/user/$UID/doc.
_dbus_run() {
  if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    dbus-run-session "$@"
  else
    "$@"
  fi
}

install_flatpak_and_appstream() {
  sudo apt update
  sudo apt update -qq
  sudo apt install -y flatpak appstream
}

validate_metainfo() {
  local metainfo_path="${1:?Usage: validate_metainfo <metainfo.xml>}"
  appstreamcli validate --explain --no-net "$metainfo_path"
}

install_flatpak_builder() {
  if ! command -v flatpak &>/dev/null; then
    sudo apt-get update -qq
    sudo apt-get install -y flatpak
  fi
  flatpak remote-add --user --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo
  _dbus_run flatpak install --user -y --noninteractive flathub \
    org.flatpak.Builder
}

lint_flatpak_manifest() {
  local manifest_path="${1:?Usage: lint_flatpak_manifest <manifest.yml>}"

  # FLATPAK_USER_DIR: point sandbox to the regular user dir so flatpak-builder-lint
  # finds flathub refs when Builder is system-installed (not user-installed).
  _dbus_run flatpak run \
    --filesystem=host \
    --env=FLATPAK_USER_DIR="$HOME/.local/share/flatpak" \
    --command=flatpak-builder-lint \
    org.flatpak.Builder \
    --exceptions \
    manifest "$(realpath "$manifest_path")"
}

build_flatpak() {
  local manifest="${1:?Usage: build_flatpak <manifest.yml>}"

  _dbus_run flatpak run --command=flathub-build org.flatpak.Builder \
    "$(realpath "$manifest")"
}

lint_flatpak_repo() {
  local repo_path="${1:?Usage: lint_flatpak_repo <repo_path>}"

  _dbus_run flatpak run \
    --filesystem=host \
    --env=FLATPAK_USER_DIR="$HOME/.local/share/flatpak" \
    --command=flatpak-builder-lint \
    org.flatpak.Builder \
    --exceptions \
    repo "$(realpath "$repo_path")"
}

export_flatpak_bundle() {
  local arch="${1:?Usage: export_flatpak_bundle <arch> <repo> <output.bundle> <app_id>}"
  local repo="${2:?Usage: export_flatpak_bundle <arch> <repo> <output.bundle> <app_id>}"
  local output="${3:?Usage: export_flatpak_bundle <arch> <repo> <output.bundle> <app_id>}"
  local app_id="${4:?Usage: export_flatpak_bundle <arch> <repo> <output.bundle> <app_id>}"

  flatpak build-bundle \
    --arch="$arch" \
    "$repo" \
    "$output" \
    "$app_id"
}

# Run the full generate → validate → lint → build → export pipeline locally.
# Flutter must already be installed; set FLUTTER_ROOT or have flutter in PATH.
# Usage: local_build [manifest.yml] [metainfo.xml]
local_build() {
  (
    set -euo pipefail

    local manifest="${1:-flatpak/generated/io.github.o_murphy.ebalistyka.yml}"
    local metainfo="${2:-app/share/metainfo/io.github.o_murphy.ebalistyka.metainfo.xml}"
    local arch bundle
    arch="$(flatpak --default-arch)"
    bundle="ebalistyka_linux_${arch}.flatpak"

    if ! command -v flutpak &>/dev/null; then
      echo "ERROR: flutpak not found. Build and install it from https://github.com/o-murphy/flutpak:" >&2
      echo "  git clone https://github.com/o-murphy/flutpak && cd flutpak" >&2
      echo "  dart run tool/update_version.dart && dart pub get" >&2
      echo "  dart compile exe bin/flutpak.dart -o /usr/local/bin/flutpak" >&2
      exit 1
    fi

    # Resolve Flutter SDK — must be pre-installed
    if [ -z "${FLUTTER_ROOT:-}" ]; then
      if ! command -v flutter &>/dev/null; then
        echo "ERROR: Flutter not found. Set FLUTTER_ROOT or add flutter to PATH." >&2
        exit 1
      fi
      FLUTTER_ROOT="$(dirname "$(dirname "$(command -v flutter)")")"
    fi

    if ! command -v appstreamcli &>/dev/null; then
      install_flatpak_and_appstream
    fi

    # Ensure flathub user remote is configured (needed for lint dep checks).
    flatpak remote-add --user --if-not-exists flathub \
      https://dl.flathub.org/repo/flathub.flatpakrepo

    if ! flatpak info org.flatpak.Builder &>/dev/null; then
      install_flatpak_builder
    fi

    flutpak generate --commit "$(git rev-parse HEAD)" --sdk "$FLUTTER_ROOT"
    validate_metainfo "$metainfo"
    # Lint may fail locally if flathub user remote has no refs yet (not fatal — build catches real errors).
    lint_flatpak_manifest "$manifest" \
      || echo "WARNING: manifest lint failed (run 'flatpak update --user' to fix flathub refs)" >&2
    # flathub-build doesn't support --disable-rofiles-fuse; call flatpak-builder directly.
    _dbus_run flatpak run \
      --filesystem=host \
      --env=FLATPAK_USER_DIR="$HOME/.local/share/flatpak" \
      --command=flatpak-builder \
      org.flatpak.Builder \
      --force-clean \
      --user \
      --install-deps-from=flathub \
      --disable-rofiles-fuse \
      --repo=repo \
      builddir \
      "$(realpath "$manifest")"
    # appstream-external-screenshot-url / appstream-screenshots-not-mirrored-in-ostree
    # are Flathub submission requirements and expected to fail on dev builds.
    lint_flatpak_repo repo \
      || echo "WARNING: repo lint failed (screenshot mirroring or similar). Check output above." >&2
    export_flatpak_bundle "$arch" repo "$bundle" io.github.o_murphy.ebalistyka

    echo "Bundle ready: $bundle"
  )
}

# Allow direct execution: bash scripts/package-flatpak.sh [manifest] [metainfo]
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
  local_build "$@"
fi
