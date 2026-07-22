/// Web placeholder for apk_abi_suffix_io.dart's conditional import in
/// update_checker.dart — `dart:ffi`'s `Abi` has no web equivalent. There is
/// no APK to download on web, so any result here is moot; `_universal.apk`
/// keeps the asset-matching logic in update_checker.dart unchanged instead
/// of adding a platform branch there too.
String apkSuffixForCurrentAbi() => '_universal.apk';
