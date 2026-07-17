.PHONY: generate \
		generate-reticles \
		generate-icons \
		generate-a7p \
		proto-setup \
        objectbox-generate objectbox-setup objectbox-clean \
		objectbox-get-sha \
		generate-localization \
		generate-collection \
		build-bclibc \
		reticle-gen-setup \
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

generate-reticles:
	./scripts/gen_reticles.sh

generate-icons:
	dart run flutter_launcher_icons:main && dart run flutter_native_splash:create

objectbox-setup:
	cd packages/ebalistyka_db && bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh)

objectbox-generate:
	cd packages/ebalistyka_db && dart run build_runner build --delete-conflicting-outputs

objectbox-clean:
	cd packages/ebalistyka_db && dart run build_runner clean

objectbox-admin:
	cd packages/ebalistyka_db && ./admin.sh

objectbox-get-sha:
	wget https://github.com/objectbox/objectbox-c/releases/download/v5.3.2/objectbox-linux-x64.tar.gz
	wget https://github.com/objectbox/objectbox-c/releases/download/v5.3.2/objectbox-linux-aarch64.tar.gz
	sha256sum objectbox-linux-x64.tar.gz
	sha256sum objectbox-linux-aarch64.tar.gz
	rm objectbox-linux-*.tar.gz

generate-collection:
	python3 scripts/merge_collections.py \
	assets/json/base.json assets/json/ammo_plus.json \
	--map assets/json/map.json \
	--out assets/json/collection.json \
	--near-dupes \
	--near-dupes-threshold 0.0

generate: objectbox-generate \
	generate-localization \
	generate-reticles generate-icons \
	generate-collection

# Build libbclibc_ffi standalone (dart_bclibc's bundled bclibc source) so
# `flutter test` can dlopen it via the package's `build/bclibc/` fallback path.
# `flutter build` bundles this automatically for the app itself, but `flutter
# test` never runs a platform build, so tests need it built explicitly.
build-bclibc:
	dart run dart_bclibc:build_native

# `tools/reticle_gen` is a standalone Dart package (not a pubspec dependency
# of the app), so `flutter analyze` can't resolve its `package:reticle_gen`
# self-import unless its own deps are fetched separately.
reticle-gen-setup:
	cd tools/reticle_gen && dart pub get

test: build-bclibc reticle-gen-setup
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
