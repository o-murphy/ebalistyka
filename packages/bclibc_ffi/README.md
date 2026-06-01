# bclibc_ffi

Dart FFI bindings for the [bclibc](https://github.com/ballistics-lab/bclibc) ballistics engine.

## Overview

This package exposes `BcLibC`, a thin Dart wrapper around the `bclibc_ffi` shared library (`libbclibc_ffi.so` / `bclibc_ffi.dll` / `libbclibc_ffi.dylib`). It mirrors the WASM bindings API surface: `findApex`, `findMaxRange`, `findZeroAngle`, `integrate`, `integrateAt`.

## Quick start

```dart
import 'package:bclibc_ffi/bclibc_ffi.dart';

final bc = BcLibC.open(); // loads the native library once

final shot = BcShot(
  bc: 0.295,
  weightGrain: 168.0,
  diameterInch: 0.308,
  lengthInch: 1.22,
  muzzleVelocityFps: 2750.0,
  sightHeightFt: 0.1148,
  twistInch: 10.0,
  tempC: 15.0,
  pressureHpa: 1013.25,
  altitudeFt: 0.0,
  dragTable: [BcDragPoint(0.0, 0.0), ...], // Mach / CD pairs
  lookAngleRad: 0.0,
  barrelElevationRad: 0.0,
);

final hit = bc.integrateShot(
  shot,
  BcTrajectoryRequest(rangeLimitFt: 3000.0, rangeStepFt: 100.0),
);

for (final pt in hit.trajectory) {
  print('${pt.distanceFt} ft  ${pt.velocityFps} fps  ${pt.heightFt} ft');
}
```

## API

### Input types

| Dart type | Description |
|---|---|
| `BcShot` | Preferred shot input (natural units). All physics conversion — atmosphere density, Coriolis trig, PCHIP drag curve, cant — is performed inside C++ via `BCLIBC_Shot::to_shot_props()`. |
| `BcShotProps` | Legacy shot input (pre-computed `BcAtmosphere`/`BcCoriolis` structs). |
| `BcTrajectoryRequest` | Step size, range limit, and `BCLIBCFFI_TrajFlag` filter bitmask. |
| `BcConfig` | Solver knobs (step multiplier, accuracy, gravity constant, etc.). |
| `BcDragPoint` | One Mach / CD entry for the drag table. |
| `BcWind` | One wind segment (velocity, direction, distance bounds). |

### Result types

| Dart type | Description |
|---|---|
| `BcTrajectoryData` | One filtered trajectory record. |
| `BcHitResult` | Full trajectory list + `BCLIBCFFI_TerminationReason`. |
| `BcInterception` | Single interpolated point from `integrateAt`. |
| `BcMaxRangeResult` | Max range (ft) + angle (rad) from `findMaxRange`. |

### `BcLibC` methods

| Method | Description |
|---|---|
| `findApexShot(BcShot)` | Highest point of trajectory |
| `findMaxRangeShot(BcShot)` | Maximum range and corresponding angle |
| `findZeroAngleShot(BcShot, distanceFt)` | Barrel elevation to zero at distance |
| `integrateShot(BcShot, BcTrajectoryRequest)` | Full filtered trajectory |
| `integrateAtShot(BcShot, key, value)` | Single interpolated point |
| `getCorrection(distanceFt, offsetFt)` | Angular correction (rad) for offset |
| `calculateEnergy(grains, fps)` | Kinetic energy (ft-lb) |
| `calculateOgw(grains, fps)` | Optimal Game Weight |

Legacy `BcShotProps`-based overloads (`findApex`, `findMaxRange`, etc.) are retained for backwards compatibility.

### Enums

| Dart enum | Description |
|---|---|
| `BCLIBCFFI_TrajFlag` | Trajectory filter flags (`BCLIBCFFI_TRAJ_FLAG_RANGE`, `BCLIBCFFI_TRAJ_FLAG_APEX`, …) |
| `BCLIBCFFI_TerminationReason` | Why integration stopped |
| `BCLIBCFFI_BaseTrajInterpKey` | Key field selector for `integrateAt` |
| `BCLIBCFFI_IntegrationMethod` | `BCLIBCFFI_INTEGRATION_RK4` (default) or `BCLIBCFFI_INTEGRATION_EULER` |

## Atmosphere and Coriolis

When using `BcShot`:
- Pass `pressureHpa: 0` for vacuum (zero drag).
- Pass `latitudeDeg: double.nan` to disable Coriolis (default `BcShot` value).
- Pass `azimuthDeg: double.nan` for flat-fire drift only.

## Regenerating bindings

After building a new version of `bclibc`:

```bash
dart run ffigen --config ffigen.yaml
```

The generated file is `lib/ffi/bclibc_bindings.g.dart`.

## Native library

The shared library must be placed where the platform can find it, or the path set via the `BCLIBC_FFI_PATH` environment variable (useful during development/testing).

| Platform | Library name |
|---|---|
| Linux | `libbclibc_ffi.so` |
| Android | `libbclibc_ffi.so` |
| macOS | `libbclibc_ffi.dylib` |
| Windows | `bclibc_ffi.dll` |
