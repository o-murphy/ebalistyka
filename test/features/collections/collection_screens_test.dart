// Characterization tests for the weapon / sight / ammo collection screens:
// which items each shows under the filter state, and the filter badge.
import 'package:ebalistyka/core/collection/collection_parser.dart';
import 'package:ebalistyka/core/extensions/sight_extensions.dart';
import 'package:ebalistyka/core/providers/builtin_collection_provider.dart';
import 'package:ebalistyka/core/providers/filter_providers.dart';
import 'package:ebalistyka/features/home/sub_screens/ammo_collection_screen.dart';
import 'package:ebalistyka/features/home/sub_screens/sight_collection_screen.dart';
import 'package:ebalistyka/features/home/sub_screens/weapon_collection_screen.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Weapon _weapon(String name, String vendor) => Weapon()
  ..name = name
  ..vendor = vendor;

Sight _sight(String name, String vendor, FocalPlane fp) => Sight()
  ..name = name
  ..vendor = vendor
  ..focalPlane = fp;

Ammo _ammo(String name, String vendor, double caliberInch, double grain) =>
    Ammo()
      ..name = name
      ..vendor = vendor
      ..caliberInch = caliberInch
      ..weightGrain = grain;

final _collection = BuiltinCollection(
  weapons: [
    _weapon('W-one', 'Alpha'),
    _weapon('W-two', 'Alpha'),
    _weapon('W-three', 'Beta'),
  ],
  sights: [
    _sight('S-one', 'Alpha', FocalPlane.ffp),
    _sight('S-two', 'Alpha', FocalPlane.sfp),
    _sight('S-three', 'Beta', FocalPlane.sfp),
  ],
  cartridges: [
    _ammo('C-small', 'Alpha', 0.223, 55),
    _ammo('C-mid', 'Beta', 0.308, 168),
    _ammo('C-big', 'Beta', 0.308, 215),
  ],
  bullets: [
    _ammo('B-small', 'Alpha', 0.223, 55),
    _ammo('B-big', 'Beta', 0.308, 215),
  ],
);

Future<ProviderContainer> _pump(WidgetTester tester, Widget screen) async {
  await tester.binding.setSurfaceSize(const Size(500, 3000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final container = ProviderContainer(
    overrides: [
      builtinCollectionProvider.overrideWith((ref) async => _collection),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

bool _badgeVisible(WidgetTester tester) =>
    tester.widget<Badge>(find.byType(Badge)).isLabelVisible;

void _expectShown(Iterable<String> shown, Iterable<String> hidden) {
  for (final n in shown) {
    expect(find.text(n), findsWidgets, reason: '$n should be shown');
  }
  for (final n in hidden) {
    expect(find.text(n), findsNothing, reason: '$n should be hidden');
  }
}

void main() {
  group('WeaponCollectionScreen', () {
    testWidgets('shows everything, then only the chosen vendors', (t) async {
      final c = await _pump(t, const WeaponCollectionScreen());
      _expectShown(['W-one', 'W-two', 'W-three'], []);
      expect(_badgeVisible(t), isFalse);

      c
          .read(weaponCollectionFilterProvider(null).notifier)
          .apply(vendors: {'Beta'}, calibers: const {});
      await t.pumpAndSettle();
      _expectShown(['W-three'], ['W-one', 'W-two']);
      expect(_badgeVisible(t), isTrue);
    });
  });

  group('SightCollectionScreen', () {
    testWidgets('filters by vendor and focal plane together', (t) async {
      final c = await _pump(t, const SightCollectionScreen());
      _expectShown(['S-one', 'S-two', 'S-three'], []);
      expect(_badgeVisible(t), isFalse);

      c
          .read(sightCollectionFilterProvider.notifier)
          .apply(vendors: {'Alpha'}, focalPlanes: {FocalPlane.sfp});
      await t.pumpAndSettle();
      _expectShown(['S-two'], ['S-one', 'S-three']);
      expect(_badgeVisible(t), isTrue);
    });
  });

  group('AmmoCollectionScreen', () {
    testWidgets('cartridges start filtered to the given caliber', (t) async {
      await _pump(
        t,
        const AmmoCollectionScreen(filterBullet: false, caliberInch: 0.308),
      );
      _expectShown(['C-mid', 'C-big'], ['C-small']);
      // The pre-selected caliber is an active filter, so the badge shows.
      expect(_badgeVisible(t), isTrue);
    });

    testWidgets('bullets use the bullet list, weight range narrows it',
        (t) async {
      final c = await _pump(
        t,
        const AmmoCollectionScreen(filterBullet: true),
      );
      _expectShown(['B-small', 'B-big'], ['C-small', 'C-mid']);

      c
          .read(ammoCollectionFilterProvider(null).notifier)
          .apply(
            vendors: const {},
            calibers: const {},
            minWeightGrain: 100,
          );
      await t.pumpAndSettle();
      _expectShown(['B-big'], ['B-small']);
      expect(_badgeVisible(t), isTrue);
    });

    testWidgets('weight range and caliber combine', (t) async {
      final c = await _pump(
        t,
        const AmmoCollectionScreen(filterBullet: false),
      );
      c
          .read(ammoCollectionFilterProvider(null).notifier)
          .apply(
            vendors: const {},
            calibers: {0.308},
            maxWeightGrain: 200,
          );
      await t.pumpAndSettle();
      _expectShown(['C-mid'], ['C-small', 'C-big']);
    });
  });
}
