#!/usr/bin/env bash

set_build_metadata() {
  local prefix="$1"
  local build_type="${2:-release}"
  local use_deps="${3:-false}"

  # ---------- BUILD NAME ----------
  local build_name="${INPUT_BUILD_NAME:-${VERSION:-}}"

  if [ -z "$build_name" ] && [ -f pubspec.yaml ]; then
    build_name=$(grep '^version:' pubspec.yaml \
      | sed 's/version:[[:space:]]*//' \
      | sed 's/+.*//')
  fi

  build_name="${build_name#v}"

  if [ -n "${PR_NUMBER:-}" ]; then
    build_name="${build_name}-pr.${PR_NUMBER}"
  fi

  safe_build_name=$(echo "$build_name" | tr '/+ ' '---' | tr -s '-')

  # ---------- BUILD NUMBER ----------
  local build_number
  build_number=$(git rev-list --count --first-parent HEAD)

  # ---------- ARCH ----------
  local arch="${INPUT_ARCH:-${MATRIX_ARCH:-amd64}}"
  local arch_suffix

  case "$arch" in
    amd64) arch_suffix="x86_64" ;;
    arm64|aarch64) arch_suffix="aarch64" ;;
    *) arch_suffix="x86_64" ;;
  esac

  # ---------- PLATFORM ----------
  local platform="${INPUT_PLATFORM:-linux}"
  local flutter_arch="x64"

  if [ "$arch" = "arm64" ]; then
    flutter_arch="arm64"
  fi

  # ---------- DEP HASHES ----------
  if [ "$use_deps" = "true" ]; then
    echo "bclibc_hash=$(git -C external/bclibc rev-parse HEAD 2>/dev/null || echo unknown)" >> "$GITHUB_OUTPUT"
    echo "bclibc_ffi_hash=$(git log -1 --format='%H' -- packages/bclibc_ffi 2>/dev/null || echo unknown)" >> "$GITHUB_OUTPUT"
  fi

  # ---------- CORE OUTPUT ----------
  {
    echo "build_name=$build_name"
    echo "safe_build_name=$safe_build_name"
    echo "build_number=$build_number"
    echo "arch=$arch"
    echo "arch_suffix=$arch_suffix"
    echo "flutter_arch=$flutter_arch"
    echo "artifact_name=${prefix}-${arch_suffix}-${safe_build_name}-${build_number}"
    echo "build_type=$build_type"
  } >> "$GITHUB_OUTPUT"

  # ---------- PLATFORM ----------
  if [ "$platform" = "linux" ]; then
    echo "bundle_dir=build/linux/${flutter_arch}/${build_type:-release}/bundle" >> "$GITHUB_OUTPUT"
  fi

  if [ "$platform" = "windows" ]; then
    local build_subdir="Debug"
    [ "$build_type" = "release" ] && build_subdir="Release"
    echo "bundle_dir=build/windows/x64/runner/${build_subdir}" >> "$GITHUB_OUTPUT"
  fi
}

resolve_version() {
    local github_ref_type="$1"
    local github_ref_name="$2"
    local version=""
    
    if [[ "$github_ref_type" == "tag" ]]; then
        version="$github_ref_name"
        [[ "${version}" == v* ]] && version="${version:1}"
    else
        version=$(grep '^version:' pubspec.yaml | sed 's/version:[[:space:]]*//' | sed 's/+.*//')
    fi
    
    # Встановлюємо output для GitHub Actions
    echo "version=${version}" >> $GITHUB_OUTPUT
    echo "Resolved version: ${version}"
}

set_pubspec_version() {
    local build_name="$1"
    local build_number="$2"

    sed -i "s/^version:.*/version: ${build_name}+${build_number}/" pubspec.yaml
    echo "pubspec version → ${build_name}+${build_number}"
}

extract_bundle() {
    local arch_suffix="$1"
    local dest="${2:-bundle}"
    mkdir -p "$dest"
    tar -xzf "dl/portable/ebalistyka_linux_${arch_suffix}.tar.gz" -C "$dest"
}

install_package_deps() {
    local format="$1"
    case "$format" in
        deb)      sudo apt-get install -y --no-install-recommends dpkg-dev ;;
        rpm)      sudo apt-get install -y --no-install-recommends rpm ;;
        appimage) ;;
        *) echo "install_package_deps: unknown format '${format}'" >&2; return 1 ;;
    esac
}

run_packager() {
    local format="$1"; shift
    bash "scripts/package-${format}.sh" "$@"
}

setup_linux_build_deps() {
    sudo apt-get update -q
    sudo apt-get install -y \
      clang \
      cmake \
      ninja-build \
      pkg-config \
      libgtk-3-dev \
      liblzma-dev \
      libstdc++-12-dev \
      libclang-dev \
      fuse \
      libfuse2 \
      zsync
}

build_android() {
    local format="$1"; shift
    bash scripts/build-android.sh --target "$format" "$@"
}
