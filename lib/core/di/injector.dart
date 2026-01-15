import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../routes/app_router.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  _registerCore();
}

void _registerCore() {
  // Router
  sl.registerLazySingleton<AppRouter>(() => AppRouter());

  // Network
  sl.registerLazySingleton<Dio>(() => DioClient.create());
}