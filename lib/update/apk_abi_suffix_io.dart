import 'dart:ffi';

/// Returns the filename suffix that matches the current device ABI.
/// Corresponds to the naming used in build-android.sh:
///   arm64-v8a  → _arm64.apk
///   armeabi-v7a → _armeabi_v7a.apk
///   x86_64     → _x86_64.apk
String apkSuffixForCurrentAbi() => switch (Abi.current()) {
  Abi.androidArm64 => '_arm64.apk',
  Abi.androidArm => '_armeabi_v7a.apk',
  Abi.androidX64 => '_x86_64.apk',
  _ => '_universal.apk',
};
