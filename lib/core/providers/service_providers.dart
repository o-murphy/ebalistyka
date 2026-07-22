import 'package:riverpod/riverpod.dart';

import 'package:ebalistyka/core/services/ballistics_service.dart';
import 'package:ebalistyka/core/services/ballistics_service_impl.dart'
    if (dart.library.js_interop)
        'package:ebalistyka/core/services/ballistics_service_impl_web.dart';

final ballisticsServiceProvider = Provider<BallisticsService>((ref) {
  return BallisticsServiceImpl();
});
