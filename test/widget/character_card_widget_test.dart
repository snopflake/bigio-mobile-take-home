import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bigio_rick_morty/core/testing/app_keys.dart';
import 'package:bigio_rick_morty/features/characters/domain/entities/character.dart';
import 'package:bigio_rick_morty/features/characters/presentation/bloc/favorites_sync/favorites_sync_cubit.dart';
import 'package:bigio_rick_morty/features/characters/presentation/bloc/favorites_sync/favorites_sync_state.dart';
import 'package:bigio_rick_morty/features/characters/presentation/widgets/character_card.dart';

class MockFavoritesSyncCubit extends MockCubit<FavoritesSyncState>
    implements FavoritesSyncCubit {}

void main() {
  late MockFavoritesSyncCubit cubit;

  final character = Character(
    id: 1,
    name: 'Rick Sanchez',
    species: 'Human',
    gender: 'Male',
    origin: 'Earth',
    location: 'Earth',
    image: 'https://example.com/rick.png',
  );

  setUpAll(() {
    registerFallbackValue(character);
  });

  setUp(() {
    cubit = MockFavoritesSyncCubit();

    when(() => cubit.state).thenReturn(const FavoritesSyncLoaded({}));

    whenListen(
      cubit,
      Stream<FavoritesSyncState>.fromIterable([const FavoritesSyncLoaded({})]),
      initialState: const FavoritesSyncLoaded({}),
    );

    when(() => cubit.toggle(any())).thenAnswer((_) async {});
    when(() => cubit.load()).thenAnswer((_) async {});
  });

  testWidgets('CharacterCard renders and exposes favorite toggle key', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (_, __) => MaterialApp(
          home: BlocProvider<FavoritesSyncCubit>.value(
            value: cubit,
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 180,
                  height: 260,
                  child: CharacterCard(
                    key: AppKeys.characterCard(character.id),
                    character: character,
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(AppKeys.characterCard(character.id)), findsOneWidget);
    expect(find.byKey(AppKeys.favoriteToggle(character.id)), findsOneWidget);
  });
}
