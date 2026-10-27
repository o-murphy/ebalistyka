import 'dart:io';

import 'package:ebalistyka/core/collection/collection_cache.dart';
import 'package:ebalistyka/shared/constants/app_info.dart';
import 'package:path_provider/path_provider.dart';

CollectionCache createCollectionCache() => _FileCollectionCache();

class _FileCollectionCache implements CollectionCache {
  Future<File> _file() async {
    final appSupport = await getApplicationSupportDirectory();
    return File('${appSupport.path}/$collectionFile');
  }

  @override
  Future<String?> read() async {
    final file = await _file();
    if (!await file.exists()) return null;
    return file.readAsString();
  }

  @override
  Future<void> write(String json) async {
    await (await _file()).writeAsString(json);
  }
}
