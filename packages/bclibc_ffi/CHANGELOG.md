# Changelog

## Unreleased

## 0.1.0

### Added
- `BcShot` Dart value class — user-facing shot descriptor in natural units; all physics conversion (atmosphere density, Coriolis trig, PCHIP drag curve, cant sin/cos) is performed inside C++ by `BCLIBC_Shot::to_shot_props()`
- `BcLibC.findApexShot`, `findMaxRangeShot`, `findZeroAngleShot`, `integrateShot`, `integrateAtShot` — preferred API; all physics conversion in C++
- `README.md` rewritten to document the actual package API

### Changed (**breaking** — requires updated bclibc ≥ next minor version)
- `calculator.dart`: `Calculator._toBcShotProps()` replaced with thin field mapper `_toBcShot()` — Coriolis trig and atmosphere density computation removed from Dart; all physics conversion delegated to `BCLIBC_Shot::to_shot_props()` in C++
- `bclibc_bindings.g.dart`: all native struct and enum type names renamed from `BC*` to `BCLIBCFFI_*` to match the `BCLIBCFFI_` function prefix:
  - `BCConfig` → `BCLIBCFFI_Config`, `BCAtmosphere` → `BCLIBCFFI_Atmosphere`, `BCCoriolis` → `BCLIBCFFI_Coriolis`, `BCWind` → `BCLIBCFFI_Wind`, `BCDragPoint` → `BCLIBCFFI_DragPoint`
  - `BCShotProps` → `BCLIBCFFI_ShotProps`, `BCShot` → `BCLIBCFFI_Shot`
  - `BCTrajFlag` → `BCLIBCFFI_TrajFlag` (values `BCLIBCFFI_TRAJ_FLAG_*`), `BCTerminationReason` → `BCLIBCFFI_TerminationReason`, `BCBaseTrajInterpKey` → `BCLIBCFFI_BaseTrajInterpKey`, `BCIntegrationMethod` → `BCLIBCFFI_IntegrationMethod`
  - `BCTrajectoryRequest` → `BCLIBCFFI_TrajectoryRequest`, `BCBaseTrajData` → `BCLIBCFFI_BaseTrajData`, `BCTrajectoryData` → `BCLIBCFFI_TrajectoryData`, `BCMaxRangeResult` → `BCLIBCFFI_MaxRangeResult`, `BCInterception` → `BCLIBCFFI_Interception`
  - `BCLIBCFFIError` → `BCLIBCFFI_Error`, `BCLIBCFFIStatus` → `BCLIBCFFI_Status`
- `BCLIBCFFI_Shot` struct updated: `drag_table: BCLIBCFFI_DragPoint*` replaced with separate `mach_data: Pointer<Double>` + `cd_data: Pointer<Double>` parallel arrays — matches `BCLIBC_Shot` C++ layout; `_FillNativeShot._fill` updated accordingly
- `bclibc_ffi.dart`: all enum / native-type references updated to `BCLIBCFFI_*`; `BcShotProps` / old `BcLibC.*()` API retained for backwards compatibility
- `external/bclibc` submodule: `583029b` — `BCLIBCFFI_*` rename + `BCLIBCFFI_Shot` separate arrays + `BCLIBCFFI_Error`/`BCLIBCFFI_Status`

## 0.0.1

* Initial release.
