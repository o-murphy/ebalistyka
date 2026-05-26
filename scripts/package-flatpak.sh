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
  flatpak remote-add --user --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo
  dbus-run-session flatpak install --user -y --noninteractive flathub \
    org.flatpak.Builder
}

lint_flatpak_manifest() {
  local manifest_path="${1:?Usage: lint_flatpak_manifest <manifest.yml>}"

  dbus-run-session flatpak run \
    --filesystem=host \
    --command=flatpak-builder-lint \
    org.flatpak.Builder \
    --exceptions \
    manifest "$manifest_path"
}

build_flatpak() {
  local manifest="${1:?Usage: build_flatpak <manifest.yml>}"
  
  dbus-run-session flatpak run --command=flathub-build org.flatpak.Builder \
    "$manifest"
}

lint_flatpak_repo() {
  local repo_path="${1:?Usage: lint_flatpak_repo <repo_path>}"

  dbus-run-session flatpak run \
    --filesystem=host \
    --command=flatpak-builder-lint \
    org.flatpak.Builder \
    --exceptions \
    repo "$repo_path"
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
