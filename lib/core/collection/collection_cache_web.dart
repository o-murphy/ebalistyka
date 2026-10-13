// ignore_for_file: implementation_imports
// `IndexedDbMsgStore` isn't exported from `ebc_db.dart`'s main barrel (it
// imports `dart:js_interop`, unavailable on the VM) — deep import, same as
// `app_bootstrap_web.dart`.

import 'dart:convert';
import 'dart:typed_data';

import 'package:ebalistyka/core/collection/collection_cache.dart';
import 'package:ebc_db/src/persistence/indexed_db_msg_store.dart';

CollectionCache createCollectionCache() => _IndexedDbCollectionCache();

class _IndexedDbCollectionCache implements CollectionCache {
  // Same database/object store as `settings`/`profiles`, new key.
  final _store = IndexedDbMsgStore<String>(
    'collection',
    encode: (s) => Uint8List.fromList(utf8.encode(s)),
    decode: utf8.decode,
  );

  @override
  Future<String?> read() async {
    final bytes = await _store.readBytes();
    return bytes == null ? null : utf8.decode(bytes);
  }

  @override
  Future<void> write(String json) => _store.save(json);
}
