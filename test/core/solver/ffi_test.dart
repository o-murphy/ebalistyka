// FFI smoke-tests for bclibc_ffi.
//
// Build the native library first:
//   make native
//   dart test test/core/solver/ffi_test.dart
//
// Or point to a custom build:
//   BCLIBC_FFI_PATH=/path/to/libbclibc_ffi.so dart test test/core/solver/ffi_test.dart

import 'package:dart_bclibc/bclibc.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Minimal G7 drag table (same points as the WASM test fixture)
// ---------------------------------------------------------------------------

final _g7Table = [
  BcDragPoint(0.00, 0.1198),
  BcDragPoint(0.05, 0.1197),
  BcDragPoint(0.10, 0.1196),
  BcDragPoint(0.15, 0.1194),
  BcDragPoint(0.20, 0.1193),
  BcDragPoint(0.25, 0.1194),
  BcDragPoint(0.30, 0.1194),
  BcDragPoint(0.35, 0.1194),
  BcDragPoint(0.40, 0.1193),
  BcDragPoint(0.45, 0.1193),
  BcDragPoint(0.50, 0.1194),
  BcDragPoint(0.55, 0.1193),
  BcDragPoint(0.60, 0.1194),
  BcDragPoint(0.65, 0.1197),
  BcDragPoint(0.70, 0.1202),
  BcDragPoint(0.725, 0.1207),
  BcDragPoint(0.75, 0.1215),
  BcDragPoint(0.775, 0.1226),
  BcDragPoint(0.80, 0.1242),
  BcDragPoint(0.825, 0.1266),
  BcDragPoint(0.85, 0.1306),
  BcDragPoint(0.875, 0.1368),
  BcDragPoint(0.90, 0.1464),
  BcDragPoint(0.925, 0.1660),
  BcDragPoint(0.95, 0.2054),
  BcDragPoint(0.975, 0.2993),
  BcDragPoint(1.0, 0.3803),
  BcDragPoint(1.025, 0.4015),
  BcDragPoint(1.05, 0.4043),
  BcDragPoint(1.075, 0.4034),
  BcDragPoint(1.10, 0.4014),
  BcDragPoint(1.15, 0.3955),
  BcDragPoint(1.20, 0.3884),
  BcDragPoint(1.30, 0.3732),
  BcDragPoint(1.40, 0.3579),
  BcDragPoint(1.50, 0.3440),
  BcDragPoint(1.60, 0.3315),
  BcDragPoint(1.80, 0.3106),
  BcDragPoint(2.00, 0.2950),
  BcDragPoint(2.20, 0.2838),
  BcDragPoint(2.40, 0.2772),
  BcDragPoint(2.60, 0.2745),
  BcDragPoint(2.80, 0.2745),
  BcDragPoint(3.00, 0.2763),
];

// ---------------------------------------------------------------------------
// Typical long-range .338 Lapua Magnum shot
// ICAO standard sea-level atmosphere: 15 °C, 1013.25 hPa, 0 ft
// ---------------------------------------------------------------------------

BcShot _makeShot({
  double barrelElevationRad = 0.0,
  BCLIBCFFI_IntegrationMethod method =
      BCLIBCFFI_IntegrationMethod.BCLIBCFFI_INTEGRATION_RK4,
}) => BcShot(
  bc: 0.279,
  weightGrain: 300.0,
  diameterInch: 0.338,
  lengthInch: 1.3,
  muzzleVelocityFps: 2750.0,
  sightHeightFt: 0.21 / 3.28084, // 21 cm in feet
  twistInch: 10.0,
  tempC: 15.0,
  pressureHpa: 1013.25,
  altitudeFt: 0.0,
  humidity: 0.0,
  dragTable: _g7Table,
  lookAngleRad: 0.0,
  barrelElevationRad: barrelElevationRad,
  method: method,
);

void main() {
  late BcLibC bc;

  setUpAll(() {
    bc = BcLibC.open();
  });

  // ── Utility functions ────────────────────────────────────────────────────

  group('calculateEnergy', () {
    test('300 gr @ 2750 fps ≈ 5036 ft-lb', () {
      final e = bc.calculateEnergy(300.0, 2750.0);
      expect(e, closeTo(5036, 50));
    });

    test('energy scales with v²', () {
      final e1 = bc.calculateEnergy(175.0, 2600.0);
      final e2 = bc.calculateEnergy(175.0, 1300.0);
      expect(e1 / e2, closeTo(4.0, 0.05));
    });
  });

  group('calculateOgw', () {
    test('returns positive value', () {
      final ogw = bc.calculateOgw(300.0, 2750.0);
      expect(ogw, greaterThan(0.0));
    });
  });

  group('getCorrection', () {
    test('zero offset → zero correction', () {
      expect(bc.getCorrection(1000.0, 0.0), closeTo(0.0, 1e-9));
    });

    test('positive offset at 1000 ft gives small angle (mrad)', () {
      // 1 ft offset at 1000 ft ≈ 1 mrad
      final c = bc.getCorrection(1000.0, 1.0);
      expect(c, closeTo(0.001, 0.0001));
    });
  });

  // ── findZeroAngleShot ────────────────────────────────────────────────────

  group('findZeroAngleShot', () {
    test('returns non-zero elevation for 1000 ft zero', () {
      final shot = _makeShot();
      final angle = bc.findZeroAngleShot(shot, 1000.0);
      expect(angle, greaterThan(0.0));
      expect(angle, lessThan(0.1)); // sanity: < ~5.7°
    });

    test('zero angle increases with distance', () {
      final shot = _makeShot();
      final a100 = bc.findZeroAngleShot(shot, 100.0 * 3.28084);
      final a500 = bc.findZeroAngleShot(shot, 500.0 * 3.28084);
      final a1000 = bc.findZeroAngleShot(shot, 1000.0 * 3.28084);
      expect(a500, greaterThan(a100));
      expect(a1000, greaterThan(a500));
    });
  });

  // ── findApexShot ─────────────────────────────────────────────────────────

  group('findApexShot', () {
    test('returns apex above muzzle height', () {
      final shot = _makeShot(barrelElevationRad: 0.785398); // 45°
      final apex = bc.findApexShot(shot);
      expect(apex.heightFt, greaterThan(0.0));
      expect(apex.distanceFt, greaterThan(0.0));
    });
  });

  // ── integrateShot ────────────────────────────────────────────────────────

  group('integrateShot', () {
    test('returns trajectory records with RANGE flag', () {
      final shot = _makeShot();
      final request = BcTrajectoryRequest(
        rangeLimitFt: 1000.0 * 3.28084,
        rangeStepFt: 100.0 * 3.28084,
        filterFlags: BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_RANGE.value,
      );
      final result = bc.integrateShot(shot, request);
      expect(result.trajectory, isNotEmpty);
      for (final p in result.trajectory) {
        expect(
          p.flag & BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_RANGE.value,
          isNot(0),
        );
      }
    });

    test('velocity decreases monotonically', () {
      final shot = _makeShot();
      final request = BcTrajectoryRequest(
        rangeLimitFt: 1000.0 * 3.28084,
        rangeStepFt: 50.0 * 3.28084,
        filterFlags: BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_RANGE.value,
      );
      final result = bc.integrateShot(shot, request);
      expect(result.trajectory.length, greaterThan(1));
      for (var i = 1; i < result.trajectory.length; i++) {
        expect(
          result.trajectory[i].velocityFps,
          lessThanOrEqualTo(result.trajectory[i - 1].velocityFps),
        );
      }
    });

    test('distance increases monotonically', () {
      final shot = _makeShot();
      final request = BcTrajectoryRequest(
        rangeLimitFt: 500.0 * 3.28084,
        rangeStepFt: 50.0 * 3.28084,
        filterFlags: BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_RANGE.value,
      );
      final result = bc.integrateShot(shot, request);
      for (var i = 1; i < result.trajectory.length; i++) {
        expect(
          result.trajectory[i].distanceFt,
          greaterThan(result.trajectory[i - 1].distanceFt),
        );
      }
    });

    test('EULER method also produces a trajectory', () {
      final shot = _makeShot(
        method: BCLIBCFFI_IntegrationMethod.BCLIBCFFI_INTEGRATION_EULER,
      );
      final request = BcTrajectoryRequest(
        rangeLimitFt: 500.0 * 3.28084,
        rangeStepFt: 100.0 * 3.28084,
        filterFlags: BCLIBCFFI_TrajFlag.BCLIBCFFI_TRAJ_FLAG_RANGE.value,
      );
      final result = bc.integrateShot(shot, request);
      expect(result.trajectory, isNotEmpty);
    });
  });

  // ── integrateAtShot ──────────────────────────────────────────────────────

  group('integrateAtShot', () {
    test('returns interception at a specific distance', () {
      final shot = _makeShot();
      final targetFt = 500.0 * 3.28084;
      final intercept = bc.integrateAtShot(
        shot,
        BCLIBCFFI_BaseTrajInterpKey.BCLIBCFFI_INTERP_KEY_POS_X,
        targetFt,
      );
      expect(intercept.fullData.distanceFt, closeTo(targetFt, targetFt * 0.01));
    });
  });
}
