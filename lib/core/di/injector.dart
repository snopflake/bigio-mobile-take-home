import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../routes/app_router.dart';

import '../../features/characters/data/datasources/character_remote_data_source.dart';
import '../../features/characters/data/repositories/character_repository_impl.dart';
import '../../features/characters/domain/repositories/character_repository.dart';

import '../../features/characters/domain/usecases/get_characters.dart';
import '../../features/characters/domain/usecases/get_character_detail.dart';
import '../../features/characters/domain/usecases/search_characters.dart';

import '../../features/characters/presentation/bloc/home/home_bloc.dart';
import '../../features/characters/presentation/bloc/detail/detail_bloc.dart';
import '../../features/characters/presentation/bloc/search/search_bloc.dart';

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

  // Character Use Cases
  sl.registerLazySingleton<GetCharacters>(
    () => GetCharacters(sl())
  );
  sl.registerLazySingleton<GetCharacterDetail>(
    () => GetCharacterDetail(sl())
  );
  sl.registerLazySingleton<SearchCharacters>(
    () => SearchCharacters(sl())
  );

  // Blocs
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(getCharacters: sl())
  );

  sl.registerFactory<DetailBloc>(
    () => DetailBloc(getCharacterDetail: sl())
  );

  sl.registerFactory<SearchBloc>(
    () => SearchBloc(searchCharacters: sl()),
  );
}