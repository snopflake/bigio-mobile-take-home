import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../routes/app_router.dart';

import '../../features/characters/data/datasources/character_remote_data_source.dart';
import '../../features/characters/data/repositories/character_repository_impl.dart';
import '../../features/characters/domain/repositories/character_repository.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  _registerCore();
}

void _registerCore() {
  // Router
  sl.registerLazySingleton<AppRouter>(() => AppRouter());

  // Network
  sl.registerLazySingleton<Dio>(() => DioClient.create());

  // Data Sources
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(sl()),
  );

  // Character Repositories
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(sl()),
  );
}