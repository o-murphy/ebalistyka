// Unit tests for GithubRelease model and enums in update_checker.dart.
// Network-dependent functions (checkForUpdate, updateCheckerProvider) require
// HTTP stubbing and are not covered here.
//   flutter test test/update/update_checker_test.dart

import 'package:ebalistyka/update/update_checker.dart';
import 'package:flutter_test/flutter_test.dart';

GithubRelease _release({
  String tagName = 'v1.0.0',
  bool prerelease = false,
  bool isPlayStore = false,
  String? apkUrl,
  LinuxInstallerType? linuxInstallerType,
}) => GithubRelease(
  tagName: tagName,
  htmlUrl: 'https://github.com/o-murphy/ebalistyka/releases/tag/$tagName',
  prerelease: prerelease,
  isPlayStore: isPlayStore,
  packageName: 'com.o_murphy.ebalistyka',
  apkUrl: apkUrl,
  linuxInstallerType: linuxInstallerType,
);

void main() {
  // ── GithubRelease.isSnap ──────────────────────────────────────────────────

  group('GithubRelease.isSnap', () {
    test('true when linuxInstallerType is snap', () {
      final r = _release(linuxInstallerType: LinuxInstallerType.snap);
      expect(r.isSnap, isTrue);
    });

    test('false when linuxInstallerType is null', () {
      expect(_release().isSnap, isFalse);
    });

    test('false for every non-snap LinuxInstallerType', () {
      for (final type in LinuxInstallerType.values) {
        if (type == LinuxInstallerType.snap) continue;
        expect(
          _release(linuxInstallerType: type).isSnap,
          isFalse,
          reason: '${type.name} should not count as snap',
        );
      }
    });

    test('isSnap and isFlatpak are mutually exclusive for snap', () {
      final r = _release(linuxInstallerType: LinuxInstallerType.snap);
      expect(r.isSnap, isTrue);
      expect(r.isFlatpak, isFalse);
    });
  });

  // ── GithubRelease.isFlatpak ───────────────────────────────────────────────

  group('GithubRelease.isFlatpak', () {
    test('true when linuxInstallerType is flatpak', () {
      final r = _release(linuxInstallerType: LinuxInstallerType.flatpak);
      expect(r.isFlatpak, isTrue);
    });

    test('false when linuxInstallerType is null', () {
      expect(_release().isFlatpak, isFalse);
    });

    test('false for every non-flatpak LinuxInstallerType', () {
      for (final type in LinuxInstallerType.values) {
        if (type == LinuxInstallerType.flatpak) continue;
        expect(
          _release(linuxInstallerType: type).isFlatpak,
          isFalse,
          reason: '${type.name} should not count as flatpak',
        );
      }
    });

    test('isSnap and isFlatpak are mutually exclusive for flatpak', () {
      final r = _release(linuxInstallerType: LinuxInstallerType.flatpak);
      expect(r.isFlatpak, isTrue);
      expect(r.isSnap, isFalse);
    });
  });

  // ── GithubRelease.isWinget ────────────────────────────────────────────────

  group('GithubRelease.isWinget', () {
    // isWinget = Platform.isWindows && _isWingetInstall().
    // Tests always run on Linux/macOS, so this is always false regardless
    // of the release configuration.
    test('false on non-Windows test runner', () {
      expect(_release().isWinget, isFalse);
    });
  });

  // ── GithubRelease fields ──────────────────────────────────────────────────

  group('GithubRelease fields', () {
    test('all fields are stored correctly', () {
      final r = GithubRelease(
        tagName: 'v2.5.1',
        htmlUrl: 'https://github.com/foo/releases/tag/v2.5.1',
        prerelease: true,
        isPlayStore: true,
        packageName: 'com.example.app',
        apkUrl: 'https://example.com/app.apk',
        linuxInstallerType: LinuxInstallerType.deb,
      );
      expect(r.tagName, 'v2.5.1');
      expect(r.htmlUrl, 'https://github.com/foo/releases/tag/v2.5.1');
      expect(r.prerelease, isTrue);
      expect(r.isPlayStore, isTrue);
      expect(r.packageName, 'com.example.app');
      expect(r.apkUrl, 'https://example.com/app.apk');
      expect(r.linuxInstallerType, LinuxInstallerType.deb);
    });

    test('apkUrl defaults to null', () {
      expect(_release().apkUrl, isNull);
    });

    test('linuxInstallerType defaults to null', () {
      expect(_release().linuxInstallerType, isNull);
    });

    test('prerelease flag is preserved', () {
      expect(_release(prerelease: true).prerelease, isTrue);
      expect(_release(prerelease: false).prerelease, isFalse);
    });
  });

  // ── LinuxInstallerType ────────────────────────────────────────────────────

  group('LinuxInstallerType enum', () {
    test('contains all expected values', () {
      expect(
        LinuxInstallerType.values,
        containsAll([
          LinuxInstallerType.snap,
          LinuxInstallerType.flatpak,
          LinuxInstallerType.deb,
          LinuxInstallerType.rpm,
          LinuxInstallerType.aur,
          LinuxInstallerType.appImage,
          LinuxInstallerType.portable,
        ]),
      );
    });

    test('has exactly 7 values', () {
      expect(LinuxInstallerType.values.length, 7);
    });
  });

  // ── NewVersionState ───────────────────────────────────────────────────────

  group('NewVersionState enum', () {
    test('contains all expected values', () {
      expect(
        NewVersionState.values,
        containsAll([
          NewVersionState.firstRun,
          NewVersionState.updated,
          NewVersionState.none,
        ]),
      );
    });

    test('has exactly 3 values', () {
      expect(NewVersionState.values.length, 3);
    });
  });

  // ── CollectionCommit ──────────────────────────────────────────────────────

  group('CollectionCommit', () {
    test('stores sha', () {
      const c = CollectionCommit(sha: 'abc123def456');
      expect(c.sha, 'abc123def456');
    });
  });
}
