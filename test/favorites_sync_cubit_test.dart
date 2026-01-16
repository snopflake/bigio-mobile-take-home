import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bigio_rick_morty/core/error/failure.dart';
import 'package:bigio_rick_morty/features/characters/domain/entities/character.dart';
import 'package:bigio_rick_morty/features/characters/domain/usecases/add_favorite.dart';
import 'package:bigio_rick_morty/features/characters/domain/usecases/get_favorites.dart';
import 'package:bigio_rick_morty/features/characters/domain/usecases/remove_favorite.dart';
import 'package:bigio_rick_morty/features/characters/presentation/bloc/favorites_sync/favorites_sync_cubit.dart';
import 'package:bigio_rick_morty/features/characters/presentation/bloc/favorites_sync/favorites_sync_state.dart';

class MockGetFavorites extends Mock implements GetFavorites {}

class MockAddFavorite extends Mock implements AddFavorite {}

class MockRemoveFavorite extends Mock implements RemoveFavorite {}

void main() {
  late MockGetFavorites getFavorites;
  late MockAddFavorite addFavorite;
  late MockRemoveFavorite removeFavorite;

  FavoritesSyncCubit buildCubit() => FavoritesSyncCubit(
        getFavorites: getFavorites,
        addFavorite: addFavorite,
        removeFavorite: removeFavorite,
      );

  // Dummy Object
  final morty = Character(
    id: 2,
    name: 'Morty Smith',
    species: 'Human',
    gender: 'Male',
    origin: 'Earth',
    location: 'Earth',
    image: 'https://example.com/morty.png',
  );

  setUpAll(() {
    registerFallbackValue(Character(
      id: 999,
      name: 'dummy',
      species: 'dummy',
      gender: 'dummy',
      origin: 'dummy',
      location: 'dummy',
      image: 'dummy',
    ));
  });

  setUp(() {
    getFavorites = MockGetFavorites();
    addFavorite = MockAddFavorite();
    removeFavorite = MockRemoveFavorite();
  });

  group('FavoritesSyncCubit', () {
    blocTest<FavoritesSyncCubit, FavoritesSyncState>(
      'load() emits [Loading, Loaded] when getFavorites succeeds',
      build: () {
        when(() => getFavorites()).thenAnswer((_) async => Right([morty]));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const FavoritesSyncLoading(),
        FavoritesSyncLoaded({morty.id}),
      ],
      verify: (_) {
        verify(() => getFavorites()).called(1);
        verifyNoMoreInteractions(getFavorites);
      },
    );

    blocTest<FavoritesSyncCubit, FavoritesSyncState>(
      'toggle() adds favorite id and calls AddFavorite when not favorite',
      build: () {
        when(() => addFavorite(any())).thenAnswer((_) async => const Right(unit));
        return buildCubit();
      },
      seed: () => const FavoritesSyncLoaded({}),
      act: (cubit) => cubit.toggle(morty),
      expect: () => [
        FavoritesSyncLoaded({morty.id}),
      ],
      verify: (_) {
        verify(() => addFavorite(morty)).called(1);
        verifyNever(() => removeFavorite(any()));
      },
    );

    blocTest<FavoritesSyncCubit, FavoritesSyncState>(
      'toggle() rolls back when AddFavorite fails',
      build: () {
          when(() => addFavorite(any())).thenAnswer(
            (_) async => Left(const ServerFailure(message: 'db error'))
          );
        return buildCubit();
      },
      seed: () => const FavoritesSyncLoaded({}),
      act: (cubit) => cubit.toggle(morty),
      expect: () => [
        FavoritesSyncLoaded({morty.id}),
        const FavoritesSyncLoaded({}),
      ],
      verify: (_) {
        verify(() => addFavorite(morty)).called(1);
      },
    );
  });
}
