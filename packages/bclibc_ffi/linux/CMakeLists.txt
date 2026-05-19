# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.13)

set(PROJECT_NAME "bclibc_ffi")
project(${PROJECT_NAME} LANGUAGES C CXX)

# ============================================================================
# bclibc_ffi – thin C wrapper over the embedded bclibc ballistics engine
#
# Two modes:
#   1. Source build (local dev): external/bclibc submodule is present → add_subdirectory
#   2. Pre-installed (Flatpak): bclibc module already built → find_library in /app/lib
# ============================================================================

# Via symlink path: linux/flutter/ephemeral/.plugin_symlinks/bclibc_ffi/linux/
# (6 levels up reaches the project root, regardless of whether this is a local
# path dependency or a pub-cache package)
get_filename_component(PROJECT_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../.." ABSOLUTE)
set(BCLIBC_ROOT "${PROJECT_ROOT}/external/bclibc")

message(STATUS "bclibc_ffi: project root = ${PROJECT_ROOT}")
message(STATUS "bclibc_ffi: submodule path = ${BCLIBC_ROOT}")

if(EXISTS "${BCLIBC_ROOT}/CMakeLists.txt")
  # Mode 1: build bclibc from the submodule (local development)
  message(STATUS "bclibc_ffi: building from source at ${BCLIBC_ROOT}")
  add_subdirectory("${BCLIBC_ROOT}" "${CMAKE_CURRENT_BINARY_DIR}/bclibc_ffi_build")
  set(bclibc_ffi_bundled_libraries $<TARGET_FILE:bclibc_ffi> PARENT_SCOPE)
else()
  # Mode 2: use pre-installed library (Flatpak separate module)
  # Check both lib and lib64 — freedesktop SDK installs to lib64 on x86_64
  find_library(BCLIBC_FFI_LIB bclibc_ffi REQUIRED
    HINTS /app/lib /app/lib64 "${CMAKE_INSTALL_PREFIX}/lib" "${CMAKE_INSTALL_PREFIX}/lib64")
  message(STATUS "bclibc_ffi: using pre-installed library: ${BCLIBC_FFI_LIB}")
  # Resolve symlinks and copy into build dir so Flutter bundles a plain file named
  # libbclibc_ffi.so — not a dangling relative symlink that breaks dlopen at runtime.
  get_filename_component(BCLIBC_FFI_REAL "${BCLIBC_FFI_LIB}" REALPATH)
  set(BCLIBC_FFI_COPY "${CMAKE_BINARY_DIR}/libbclibc_ffi.so")
  configure_file("${BCLIBC_FFI_REAL}" "${BCLIBC_FFI_COPY}" COPYONLY)
  set(bclibc_ffi_bundled_libraries "${BCLIBC_FFI_COPY}" PARENT_SCOPE)
endif()