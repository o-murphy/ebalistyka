.PHONY: generate \
		generate-reticles \
		generate-icons \
		generate-a7p \
		proto-setup \
		generate-localization \
		generate-collection \
		reticle-gen-setup \
		build-web deploy-web \
		test format clean run run-clean

# Cross-platform helpers
ifeq ($(OS),Windows_NT)
  NPROC   := $(NUMBER_OF_PROCESSORS)
  RM_DIR  := cmake -E remove_directory
  # getApplicationSupportDirectory() on Windows → %APPDATA%\<company>\<app>\data
  # Flutter uses the BINARY_NAME from CMakeLists.txt ("ebalistyka")
  DB_DIR  := $(APPDATA)\ebalistyka\ebalistyka
else
  NPROC   := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
  RM_DIR  := rm -rf
  UNAME_S := $(shell uname -s)
  ifeq ($(UNAME_S),Darwin)
    # getApplicationSupportDirectory() on macOS → ~/Library/Application Support/<bundle_id>
    DB_DIR := $(HOME)/Library/Application Support/com.o.murphy.ebalistyka
  else
    # getApplicationSupportDirectory() on Linux → $XDG_DATA_HOME/<bundle_id>
    DB_DIR := $(or $(XDG_DATA_HOME),$(HOME)/.local/share)/com.o.murphy.ebalistyka
  endif
endif

# Install protoc + Dart plugin (run once per machine)
proto-setup:
ifeq ($(OS),Windows_NT)
	@echo "Install protoc manually: https://github.com/protocolbuffers/protobuf/releases"
	dart pub global activate protoc_plugin
else ifeq ($(UNAME_S),Darwin)
	brew install protobuf
	dart pub global activate protoc_plugin
else
	sudo apt-get install -y protobuf-compiler
	dart pub global activate protoc_plugin
endif

generate-localization:
	flutter gen-l10n

# Release web bundle for GitHub Pages (build/web). BASE_HREF=/ for a root.
build-web:
	./scripts/build-web.sh

# Manual publish of build/web to the gh-pages branch (asks first).
deploy-web: build-web
	./scripts/deploy-web.sh

generate-reticles:
	./scripts/gen_reticles.sh

generate-icons:
	dart run flutter_launcher_icons:main && dart run flutter_native_splash:create

generate-collection:
	python3 scripts/merge_collections.py \
	assets/json/base.json assets/json/ammo_plus.json \
	--map assets/json/map.json \
	--out assets/json/collection.json \
	--near-dupes \
	--near-dupes-threshold 0.0

generate: generate-localization \
	generate-reticles generate-icons \
	generate-collection

# bclibc needs no build step here: its build hook compiles libbclibc_ffi from the
# sources shipped in the package for `flutter test` and `flutter build` alike.

# ob_dump_reader likewise compiles its bundled LMDB through its build hook.

# `tools/reticle_gen` is a standalone Dart package (not a pubspec dependency
# of the app), so `flutter analyze` can't resolve its `package:reticle_gen`
# self-import unless its own deps are fetched separately.
reticle-gen-setup:
	cd tools/reticle_gen && dart pub get

test: reticle-gen-setup
	flutter analyze && flutter test 2>&1

format:
	dart format lib test \
		packages/ebalistyka_db/lib \
		tools/reticle_gen/lib \
		tools/reticle_gen/bin

run:
	flutter run --flavor dev

run-clean:
ifeq ($(OS),Windows_NT)
	-if exist "$(DB_DIR)" rmdir /s /q "$(DB_DIR)"
else
	-$(RM_DIR) "$(DB_DIR)"
endif
	flutter run

clean:
