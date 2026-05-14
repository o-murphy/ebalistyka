# Flathub Publishing Guide

This document covers the complete workflow for building, testing, publishing, and updating the
app on Flathub.

---

## Background: why source builds?

Flathub requires **full offline source builds** — the sandbox has no network access during
`flatpak-builder`. Every dependency (Flutter SDK, Dart packages, C libraries) must be declared as
a source with a verified SHA-256 checksum.

GitHub CI also uses the same source-build approach (via `build-flatpak.yml`) so that CI-produced
artifacts and Flathub builds are identical.

| File | Used by | Purpose |
|---|---|---|
| `io.github.o_murphy.ebalistyka.yml` | Flathub + GitHub CI | Full offline source build |
| `io.github.o_murphy.ebalistyka.bundle.yml` | local packaging only | Packages a pre-built bundle |

---

## Repository layout

```
flatpak/
├── io.github.o_murphy.ebalistyka.yml        # Flathub manifest (source build)
├── io.github.o_murphy.ebalistyka.bundle.yml # CI manifest (bundle)
├── flutter-sdk.json                          # Flutter 3.41.9 SDK sources (20 archives)
├── pubspec-sources.json                      # 426 pub.dev package sources
├── ebalistyka-wrapper.sh                     # /app/bin/ebalistyka launcher
├── io.github.o_murphy.ebalistyka.desktop     # .desktop file
├── io.github.o_murphy.ebalistyka.metainfo.xml# AppStream metadata
└── patches/
    ├── flutter/shared.sh.patch               # Forces --offline in flutter pub upgrade
    └── objectbox_flutter_libs/
        └── CMakeLists.txt.patch              # Skips FetchContent download for libobjectbox
```

Generator scripts (kept in `/tmp/` — not committed, recreate if `/tmp` is cleared):

```
/tmp/gen_manifest.py       # Regenerates io.github.o_murphy.ebalistyka.yml from flutter-sdk.json
/tmp/gen_flutter_sdk.py    # Regenerates flutter-sdk.json from local Flutter install
/tmp/flatpak-flutter/      # flatpak-flutter tool (git clone of TheAppgineer/flatpak-flutter)
/tmp/ff-venv/              # Python venv for the generators
```

---

## How the offline build works

Two modules are built in sequence. When `flatpak-builder` runs, all sources are fetched and
verified **before** build commands execute.

### Module 1: `bclibc` (cmake-ninja)

```
sources:  git @ v1.0.5
builds:   libbclibc_core.a + libbclibc_ffi.so
installs: /app/lib/libbclibc_ffi.so
          /app/include/bclibc/...
```

### Module 2: `ebalistyka` (simple)

Sources applied in order:

```
1. App source      git @ v0.1.14         → /run/build/ebalistyka/
2. Flutter SDK     git @ 3.41.9          → /run/build/ebalistyka/flutter/
   + 17 engine artifact archives          → flutter/bin/cache/artifacts/...
   + shared.sh.patch                      → patches flutter pub upgrade to --offline
   + setup-flutter.sh script
3. objectbox-c     archive x64/aarch64   → /run/build/ebalistyka/objectbox-c/
4. pubspec-sources.json                  → /run/build/ebalistyka/.pub-cache/hosted/pub.dev/*/
5. objectbox patch (after pubspec!)      → patches objectbox_flutter_libs CMakeLists.txt
```

Then build commands run:
```
7 stamp copies → setup-flutter.sh (flutter pub get --offline) → flutter build linux --release --no-pub → install
```

The `bclibc_ffi` Flutter plugin detects that `external/bclibc` is absent and finds
`/app/lib/libbclibc_ffi.so` (installed by module 1) instead of building from source.

### Why ObjectBox needs a patch

`objectbox_flutter_libs` downloads `libobjectbox.so` via CMake `FetchContent_Populate`. This
deprecated API creates a cmake *subbuild* — a separate cmake process that doesn't inherit
variables from the parent. The standard `FETCHCONTENT_SOURCE_DIR_*` approach fails here.

The fix: `patches/objectbox_flutter_libs/CMakeLists.txt.patch` makes the plugin check whether
`${CMAKE_SOURCE_DIR}/../objectbox-c/lib/libobjectbox.so` already exists (placed there by the
archive source) and skip the download entirely.

---

## Local testing

### Prerequisites (one-time setup)

```bash
sudo apt install flatpak flatpak-builder
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub \
  org.freedesktop.Platform//25.08 \
  org.freedesktop.Sdk//25.08 \
  org.freedesktop.Sdk.Extension.llvm20//25.08
```

### Build and install

```bash
cd /home/murphy/flutterproj/ebalistyka-app

flatpak-builder --sandbox --user --install --install-deps-from=flathub --force-clean \
  --repo=.flatpak-repo --state-dir=.flatpak-builder \
  .flatpak-build flatpak/io.github.o_murphy.ebalistyka.yml
```

First run downloads all sources (~1–2 GB) into `.flatpak-builder/downloads/` — this is cached
and subsequent builds are fast. `--force-clean` removes only the build dir, not the cache.

### Run the installed app

```bash
flatpak run io.github.o_murphy.ebalistyka
```

### Export a standalone `.flatpak` file

```bash
flatpak build-bundle .flatpak-repo \
  ebalistyka_linux_x86_64.flatpak \
  io.github.o_murphy.ebalistyka
```

---

## Publishing to Flathub (first submission)

Flathub uses its own git repository per app. The process:

### 1. Fork the Flathub repository

Go to https://github.com/flathub/flathub and click **"Add New App"** (top right),
or for direct submission: fork https://github.com/flathub/flathub and submit a PR
adding a new directory `io.github.o_murphy.ebalistyka/`.

The Flathub submission repository needs:
```
io.github.o_murphy.ebalistyka/
└── io.github.o_murphy.ebalistyka.yml   ← the source-build manifest
```

All supporting files referenced in the manifest (`pubspec-sources.json`,
`patches/`, etc.) must also be in that same directory.

### 2. Prepare the Flathub repository

```bash
# Clone your fork
git clone https://github.com/YOUR_FORK/io.github.o_murphy.ebalistyka flathub-repo
cd flathub-repo

# Copy the manifest and all referenced files
cp ../ebalistyka-app/flatpak/io.github.o_murphy.ebalistyka.yml .
cp ../ebalistyka-app/flatpak/pubspec-sources.json .
cp ../ebalistyka-app/flatpak/flutter-sdk.json .
cp -r ../ebalistyka-app/flatpak/patches .
# (The manifest, desktop, metainfo, wrapper, icon are fetched from git source — no copy needed)
```

> **Note:** The manifest's `type: git` sources (app source, Flutter, bclibc) pull files from
> GitHub at build time. Only the generated JSON/patch files need to be in the Flathub repo.

### 3. Update metainfo before submission

Edit `flatpak/io.github.o_murphy.ebalistyka.metainfo.xml` — the `<releases>` section must
list at least the current version with today's date:

```xml
<releases>
  <release version="0.1.14" date="2026-05-14"/>
</releases>
```

### 4. Validate locally before submitting

```bash
# AppStream validation
flatpak run --command=appstreamcli org.freedesktop.Sdk//25.08 \
  validate flatpak/io.github.o_murphy.ebalistyka.metainfo.xml

# Full sandbox build (as described in Local testing above)
```

### 5. Submit PR

Push to your fork and open a PR against `https://github.com/flathub/io.github.o_murphy.ebalistyka`
(the app-specific repo, not the main flathub repo). Flathub CI will run the sandbox build.

---

## Version update workflow

### What goes into the release PR

**Only if `pubspec.lock` changed** (new/upgraded Dart packages):
```bash
bash scripts/update-pubspec-sources.sh
# commit the updated flatpak/pubspec-sources.json
```

The script includes `flutter/packages/flutter_tools/pubspec.lock` automatically (needed for the
offline `pub get` step inside the sandbox). Without it the build fails with:
`json_annotation X.Y.Z which doesn't match any versions`

**The manifest `tag`/`commit` fields do NOT need manual editing** — `build-flatpak.yml` patches
them automatically from `${{ github.ref_name }}` when the tag is pushed.

---

### After merging — tag and push

```bash
git tag v0.1.15
git push origin v0.1.15
```

This triggers `release.yml` automatically:
- Builds all artifacts including the source-built `.flatpak`
- Creates the GitHub release

---

### After the GitHub release — publish to Flathub

Trigger manually: **GitHub → Actions → Publish Flathub → Run workflow → tag: `v0.1.15`**

This runs `scripts/update-flathub.sh` which:
- Copies the manifest + pubspec-sources.json + patches to the Flathub repo
- Updates the manifest `tag`/`commit` to `v0.1.15`
- Removes temporary backport patches (no longer needed once cmake changes are in the tag)
- Commits and pushes to the Flathub repo → Flathub CI triggers automatically

---

## Flutter version upgrade

When bumping Flutter (e.g. `3.41.9` → `3.42.0`):

### 1. Update local Flutter

```bash
flutter upgrade  # or: cd ~/flutter && git checkout 3.42.0
```

### 2. Regenerate flutter-sdk.json

```bash
# flutter-sdk.json requires downloading engine artifacts to compute SHA-256.
# This needs network access (once), then everything is cached.

python3 -m venv /tmp/ff-venv
/tmp/ff-venv/bin/pip install packaging PyYAML tomlkit
[ -d /tmp/flatpak-flutter ] || git clone https://github.com/TheAppgineer/flatpak-flutter /tmp/flatpak-flutter

cat > /tmp/gen_flutter_sdk.py << 'EOF'
import sys
sys.path.insert(0, '/tmp/flatpak-flutter')
from flutter_sdk_generator.flutter_sdk_generator import generate_sdk
import json

sdk_path = '/home/murphy/flutter'
tag = open(f'{sdk_path}/version').read().strip()
patch_path = '../patches/flutter'  # relative path for the patch entry

result = generate_sdk(sdk_path, tag, patch_path)
json.dump(result, open('/home/murphy/flutterproj/ebalistyka-app/flatpak/flutter-sdk.json', 'w'), indent=2)
print(f"Written flutter-sdk.json (tag: {tag})")
EOF

python3 /tmp/gen_flutter_sdk.py
```

### 3. Regenerate pub sources

Run Step 2 of the version update workflow above (include `flutter_tools/pubspec.lock`).

### 4. Regenerate the manifest

```bash
python3 /tmp/gen_manifest.py flatpak/io.github.o_murphy.ebalistyka.yml
```

Then manually set the correct `tag` and `commit` for the app source in the manifest
(the generator uses the values hardcoded in `gen_manifest.py` — update them first):

```python
# In /tmp/gen_manifest.py, update:
APP_SOURCES = [
    {
        'type': 'git',
        'url': 'https://github.com/o-murphy/ebalistyka-app.git',
        'tag': 'v0.1.15',           # ← update
        'commit': '<hash>',          # ← update
        'disable-submodules': True,
    },
    ...
]
```

---

## ObjectBox version upgrade

If `objectbox_flutter_libs` is upgraded (e.g. `5.3.1` → `5.4.0`):

### 1. Find new archive SHA-256

```bash
VERSION=5.4.0
curl -sL "https://github.com/objectbox/objectbox-c/releases/download/v${VERSION}/objectbox-linux-x64.tar.gz" | sha256sum
curl -sL "https://github.com/objectbox/objectbox-c/releases/download/v${VERSION}/objectbox-linux-aarch64.tar.gz" | sha256sum
```

### 2. Update the manifest

In `flatpak/io.github.o_murphy.ebalistyka.yml`, update the two objectbox archive sources:

```yaml
- type: archive
  only-arches: [x86_64]
  url: .../objectbox-linux-x64.tar.gz        # ← new version
  sha256: <new-sha256-x64>
  dest: objectbox-c
  strip-components: 0
- type: archive
  only-arches: [aarch64]
  url: .../objectbox-linux-aarch64.tar.gz    # ← new version
  sha256: <new-sha256-aarch64>
  dest: objectbox-c
  strip-components: 0
```

Also update the patch `dest` path if the package version changed:

```yaml
- type: patch
  dest: .pub-cache/hosted/pub.dev/objectbox_flutter_libs-5.4.0   # ← new version
  path: patches/objectbox_flutter_libs/CMakeLists.txt.patch
```

### 3. Verify the patch still applies

```bash
patch --dry-run -p1 -d ~/.pub-cache/hosted/pub.dev/objectbox_flutter_libs-5.4.0 \
  < flatpak/patches/objectbox_flutter_libs/CMakeLists.txt.patch
```

If it fails, update the patch against the new CMakeLists.txt:

```bash
# Make the same changes manually to /tmp/objectbox_cmake_new.txt, then:
diff -u ~/.pub-cache/hosted/pub.dev/objectbox_flutter_libs-<ver>/linux/CMakeLists.txt \
        /tmp/objectbox_cmake_new.txt \
  | sed 's|.*CMakeLists.txt.*|--- a/linux/CMakeLists.txt\n+++ b/linux/CMakeLists.txt|' \
  > flatpak/patches/objectbox_flutter_libs/CMakeLists.txt.patch
```

---

## Troubleshooting

### Build fails with "network access" errors

Something is trying to download at build time. Common culprits:

- **Missing pub package**: A package in `pubspec.lock` is not in `pubspec-sources.json`.
  Run `bash scripts/update-pubspec-sources.sh`.
- **flutter_tools packages missing** (`json_annotation X.Y.Z not found`): The script auto-includes
  `flutter_tools/pubspec.lock` — if it fails, check that `~/flutter/` or `$FLUTTER_ROOT` is set.
- **ObjectBox download**: The objectbox patch didn't apply. Check source ordering —
  the patch must come *after* `pubspec-sources.json` in the manifest.

### Patch fails to apply: "can't find file to patch"

The `objectbox_flutter_libs` package version in `.pub-cache` doesn't match the `dest` path.
Check the version in `pubspec.lock`:

```bash
grep -A3 'objectbox_flutter_libs:' pubspec.lock
```

Update the `dest` in the manifest to match the actual version.

### Build fails at `flutter pub get`

The offline pub cache is incomplete. Check which package is missing:

```bash
# Run pub get manually pointing at the pub cache from the last build
PUB_CACHE=/path/to/.flatpak-builder/... flutter pub get
```

Then regenerate `pubspec-sources.json`.

### `appstreamcli compose` warning: no release

Update the `<releases>` block in `io.github.o_murphy.ebalistyka.metainfo.xml` with the
current version and date.

### Flathub CI passes locally but fails on Flathub

- Flathub builds on `x86_64` and `aarch64` — test aarch64 locally with `--arch=aarch64`
  if you have the runtime: `flatpak install flathub org.freedesktop.Platform//25.08//aarch64`
- Flathub uses a stricter sandbox. Run locally with `--sandbox` flag (already in the test command).

---

## bclibc version upgrade

When `bclibc` is updated:

### 1. Update the submodule

```bash
cd external/bclibc
git fetch --tags
git checkout v1.0.6   # new version
cd ../..
git add external/bclibc
```

### 2. Update the manifest

In `flatpak/io.github.o_murphy.ebalistyka.yml`, update the bclibc module source:

```yaml
- name: bclibc
  ...
  sources:
    - type: git
      url: https://github.com/ballistics-lab/bclibc.git
      tag: v1.0.6                           # ← new tag
      commit: <git rev-parse v1.0.6>        # ← new commit hash
```

### 3. Test locally

```bash
flatpak-builder --sandbox --user --install --install-deps-from=flathub --force-clean \
  --repo=.flatpak-repo --state-dir=.flatpak-builder \
  .flatpak-build flatpak/io.github.o_murphy.ebalistyka.yml
```

---

## Key paths inside the sandbox

During the Flathub build, the filesystem looks like:

```
/run/build/bclibc/             ← bclibc module build (cmake-ninja)

/app/                          ← after bclibc module installs:
  lib64/libbclibc_ffi.so       ← found by bclibc_ffi plugin (mode 2, searches lib + lib64)
  include/bclibc/...

/run/build/ebalistyka/         ← ebalistyka module working directory
  flutter/                     ← Flutter SDK
  objectbox-c/                 ← objectbox prebuilt (lib/libobjectbox.so, include/)
  .pub-cache/hosted/pub.dev/   ← Dart packages (from pubspec-sources.json)
    objectbox_flutter_libs-5.3.1/linux/CMakeLists.txt  ← patched to skip download
  build/linux/x64/release/bundle/  ← flutter build output (copied to /app/ebalistyka/)

/app/                          ← final installed state
  ebalistyka/                  ← bundle files (binary + libs + data)
    lib/libbclibc_ffi.so       ← copied from /app/lib/ via bclibc_ffi_bundled_libraries
    lib/libobjectbox.so        ← copied from objectbox-c/
  bin/ebalistyka               ← wrapper script (sets LD_LIBRARY_PATH)
  share/applications/...
  share/icons/...
  share/metainfo/...
```
