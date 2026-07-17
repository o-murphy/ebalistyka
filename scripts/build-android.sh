#!/usr/bin/env bash
# Build Flutter Android artifacts (APK split/universal or AAB) and place them in artifacts/.
#
# Usage:
#   build-android.sh [--target apk|aab] <build_name> <build_number>
#
# Options:
#   --target apk   Per-ABI split APKs + universal fat APK  (default)
#   --target aab   App Bundle for Google Play
#
# Arguments:
#   build_name    Version string, e.g. "1.2.3" or "1.2.3-beta.1".  "v" prefix is stripped.
#   build_number  Integer build number (git rev-list --count --first-parent HEAD).
#
# Signing (optional — falls back to debug key if not set):
#   ANDROID_KEYSTORE_BASE64      Base64-encoded .jks/.p12 keystore file.
#   ANDROID_KEYSTORE_PASSWORD    Keystore (store) password.
#   ANDROID_KEY_ALIAS            Key alias inside the keystore.
#   ANDROID_KEY_PASSWORD         Key password.
#
# Outputs (apk):
#   artifacts/ebalistyka_android_arm64.apk
#   artifacts/ebalistyka_android_armeabi_v7a.apk
#   artifacts/ebalistyka_android_x86_64.apk
#   artifacts/ebalistyka_android_universal.apk
#
# Outputs (aab):
#   artifacts/ebalistyka_android.aab

set -euo pipefail

# ── Argument parsing ─────────────────────────────────────────────────────────
TARGET="apk"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target)
            TARGET="$2"
            shift 2
            ;;
        --target=*)
            TARGET="${1#--target=}"
            shift
            ;;
        *)
            break
            ;;
    esac
done

BUILD_NAME="${1:-0.1.0-dev}"
BUILD_NUMBER="${2:-0}"
BUILD_NAME="${BUILD_NAME#v}"

if [[ "$TARGET" != "apk" && "$TARGET" != "aab" ]]; then
    echo "Error: --target must be 'apk' or 'aab' (got: '$TARGET')" >&2
    exit 1
fi

echo "Target: $TARGET | Version: $BUILD_NAME ($BUILD_NUMBER)"

# ── Cleanup trap ─────────────────────────────────────────────────────────────
cleanup() {
    rm -f android/ebalistyka.keystore android/key.properties
}
trap cleanup EXIT

# ── Android signing ──────────────────────────────────────────────────────────
if [ -n "${ANDROID_KEYSTORE_BASE64:-}" ]; then
    echo "Setting up Android release signing…"
    echo "$ANDROID_KEYSTORE_BASE64" | base64 -d > android/ebalistyka.keystore
    cat > android/key.properties <<EOF
storePassword=${ANDROID_KEYSTORE_PASSWORD}
keyPassword=${ANDROID_KEY_PASSWORD}
keyAlias=${ANDROID_KEY_ALIAS}
storeFile=../ebalistyka.keystore
EOF
    echo "Keystore written → android/ebalistyka.keystore  (alias: ${ANDROID_KEY_ALIAS})"
else
    echo "ANDROID_KEYSTORE_BASE64 not set — using debug signing"
fi

mkdir -p artifacts

# ── Build ────────────────────────────────────────────────────────────────────
if [[ "$TARGET" == "aab" ]]; then
    flutter build appbundle --release --flavor googlePlay \
        --build-name="$BUILD_NAME" \
        --build-number="$BUILD_NUMBER"

    cp build/app/outputs/bundle/googlePlayRelease/app-googlePlay-release.aab \
        artifacts/ebalistyka_android.aab

else
    # Split per-ABI first
    flutter build apk --release --flavor sideload --split-per-abi \
        --build-name="$BUILD_NAME" \
        --build-number="$BUILD_NUMBER"

    cp build/app/outputs/flutter-apk/app-arm64-v8a-sideload-release.apk   artifacts/ebalistyka_android_arm64.apk
    cp build/app/outputs/flutter-apk/app-armeabi-v7a-sideload-release.apk artifacts/ebalistyka_android_armeabi_v7a.apk
    cp build/app/outputs/flutter-apk/app-x86_64-sideload-release.apk      artifacts/ebalistyka_android_x86_64.apk

    # Universal (fat) APK — окремий запуск, бо --split-per-abi і fat несумісні
    flutter build apk --release --flavor sideload \
        --build-name="$BUILD_NAME" \
        --build-number="$BUILD_NUMBER"

    cp build/app/outputs/flutter-apk/app-sideload-release.apk artifacts/ebalistyka_android_universal.apk
fi

echo "=== Artifacts ==="
ls -lh artifacts/
