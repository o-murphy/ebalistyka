import 'dart:developer' as developer;

import 'package:ob_dump_reader_flutter/ob_dump_reader_flutter.dart';
import 'package:ebalistyka/ob_migrate/generated/schema.g.dart' as schema;

// const ammoEntityId = 1; // from schema.json

// Future<void> main() async {
//   // Walks data.mdb, calling this callback once per stored ObjectBox object
//   // with its raw (still-undecoded) FlatBuffers bytes — see [ObRecord].
//   await readObjectBoxRecords('/path/to/objectbox/dir', (record) {
//     if (record.entityId == ammoEntityId) {
//       final ammo = schema.Ammo(
//         record.data,
//       ); // flatc-generated class decodes the bytes
//       developer.log('${ammo.name}: ${ammo.bcG1}');
//       // ... insert into whatever your new database is.
//     }
//   });
// }

// ignore: unused_element
final Map<int, Type> _idToEntity = {
  1: schema.Ammo,
  2: schema.ConvertorsState,
  3: schema.GeneralSettings,
  4: schema.Owner,
  5: schema.Profile,
  6: schema.Sight,
  7: schema.TablesSettings,
  8: schema.UnitSettings,
  9: schema.Weapon,
  11: schema.ShootingConditions,
  12: schema.ReticleSettings,
};

Future<void> migrateFuncTemplate() async {
  await readObjectBoxRecords('/path/to/objectbox/dir', (record) {
    // Перевіряємо, чи є такий ID у нашій мапі
    final entityType = _idToEntity[record.entityId];
    if (entityType == null) return; // Пропускаємо невідомі сутності

    // Розподіляємо детектування за типами або ID
    switch (record.entityId) {
      case 1:
        final ammo = schema.Ammo(record.data);
        developer.log('Ammo -> ${ammo.name}: ${ammo.bcG1}');
        // Зберігайте у нову БД...
        break;

      case 2:
        final convertors = schema.ConvertorsState(record.data);
        developer.log('ConvertorsState -> ID: ${convertors.id}');
        break;

      case 3:
        final settings = schema.GeneralSettings(record.data);
        developer.log('GeneralSettings -> Theme: ${settings.themeMode}');
        break;

      case 4:
        final owner = schema.Owner(record.data);
        developer.log('Owner -> Token: ${owner.token}');
        break;

      case 5:
        final profile = schema.Profile(record.data);
        developer.log('Profile -> Name: ${profile.name}');
        break;

      case 6:
        final sight = schema.Sight(record.data);
        developer.log('Sight -> Name: ${sight.name}');
        break;

      case 7:
        final tables = schema.TablesSettings(record.data);
        developer.log('TablesSettings -> Zeros: ${tables.showZeros}');
        break;

      case 8:
        final units = schema.UnitSettings(record.data);
        developer.log('UnitSettings -> Distance: ${units.distance}');
        break;

      case 9:
        final weapon = schema.Weapon(record.data);
        developer.log('Weapon -> ${weapon.name}: ${weapon.caliberName}');
        break;

      case 11:
        final conditions = schema.ShootingConditions(record.data);
        developer.log(
          'ShootingConditions -> Distance: ${conditions.distanceMeter}',
        );
        break;

      case 12:
        final reticle = schema.ReticleSettings(record.data);
        developer.log('ReticleSettings -> ID: ${reticle.id}');
        break;

      default:
        developer.log('Unknown entity ID: ${record.entityId}');
    }
  });
}
