import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _unset = Object();

// ── Ammo filter ───────────────────────────────────────────────────────────────

@immutable
class AmmoFilterState {
  const AmmoFilterState({
    this.vendors = const {},
    this.calibers = const {},
    this.minWeightGrain,
    this.maxWeightGrain,
  });

  final Set<String> vendors;
  final Set<double> calibers;
  final double? minWeightGrain;
  final double? maxWeightGrain;

  bool get isActive =>
      vendors.isNotEmpty ||
      calibers.isNotEmpty ||
      minWeightGrain != null ||
      maxWeightGrain != null;

  AmmoFilterState copyWith({
    Set<String>? vendors,
    Set<double>? calibers,
    Object? minWeightGrain = _unset,
    Object? maxWeightGrain = _unset,
  }) => AmmoFilterState(
    vendors: vendors ?? this.vendors,
    calibers: calibers ?? this.calibers,
    minWeightGrain: minWeightGrain == _unset
        ? this.minWeightGrain
        : minWeightGrain as double?,
    maxWeightGrain: maxWeightGrain == _unset
        ? this.maxWeightGrain
        : maxWeightGrain as double?,
  );
}

class AmmoFilterNotifier extends Notifier<AmmoFilterState> {
  AmmoFilterNotifier(this._defaultCaliberInch);
  final double? _defaultCaliberInch;

  @override
  AmmoFilterState build() => AmmoFilterState(
    calibers: _defaultCaliberInch != null ? {_defaultCaliberInch} : {},
  );

  void apply({
    required Set<String> vendors,
    required Set<double> calibers,
    double? minWeightGrain,
    double? maxWeightGrain,
  }) => state = AmmoFilterState(
    vendors: vendors,
    calibers: calibers,
    minWeightGrain: minWeightGrain,
    maxWeightGrain: maxWeightGrain,
  );
}

final ammoCollectionFilterProvider = NotifierProvider.autoDispose
    .family<AmmoFilterNotifier, AmmoFilterState, double?>(
      (arg) => AmmoFilterNotifier(arg),
    );

// ── Sight filter ──────────────────────────────────────────────────────────────

@immutable
class SightFilterState {
  const SightFilterState({
    this.vendors = const {},
    this.focalPlanes = const {},
  });

  final Set<String> vendors;
  final Set<FocalPlane> focalPlanes;

  bool get isActive => vendors.isNotEmpty || focalPlanes.isNotEmpty;

  SightFilterState copyWith({
    Set<String>? vendors,
    Set<FocalPlane>? focalPlanes,
  }) => SightFilterState(
    vendors: vendors ?? this.vendors,
    focalPlanes: focalPlanes ?? this.focalPlanes,
  );
}

class SightFilterNotifier extends Notifier<SightFilterState> {
  @override
  SightFilterState build() => const SightFilterState();

  void apply({
    required Set<String> vendors,
    required Set<FocalPlane> focalPlanes,
  }) => state = state.copyWith(vendors: vendors, focalPlanes: focalPlanes);
}

final sightCollectionFilterProvider =
    NotifierProvider.autoDispose<SightFilterNotifier, SightFilterState>(
      SightFilterNotifier.new,
    );

// ── Weapon filter ─────────────────────────────────────────────────────────────

@immutable
class WeaponFilterState {
  const WeaponFilterState({this.vendors = const {}, this.calibers = const {}});

  final Set<String> vendors;
  final Set<double> calibers;

  bool get isActive => vendors.isNotEmpty || calibers.isNotEmpty;

  WeaponFilterState copyWith({Set<String>? vendors, Set<double>? calibers}) =>
      WeaponFilterState(
        vendors: vendors ?? this.vendors,
        calibers: calibers ?? this.calibers,
      );
}

class WeaponFilterNotifier extends Notifier<WeaponFilterState> {
  WeaponFilterNotifier(this._defaultCaliberInch);
  final double? _defaultCaliberInch;

  @override
  WeaponFilterState build() => WeaponFilterState(
    calibers: _defaultCaliberInch != null ? {_defaultCaliberInch} : {},
  );

  void apply({required Set<String> vendors, required Set<double> calibers}) =>
      state = state.copyWith(vendors: vendors, calibers: calibers);
}

final weaponCollectionFilterProvider = NotifierProvider.autoDispose
    .family<WeaponFilterNotifier, WeaponFilterState, double?>(
      (arg) => WeaponFilterNotifier(arg),
    );
