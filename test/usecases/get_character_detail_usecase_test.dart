import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bigio_rick_morty/core/error/failure.dart';
import 'package:bigio_rick_morty/features/characters/domain/entities/character.dart';
import 'package:bigio_rick_morty/features/characters/domain/repositories/character_repository.dart';
import 'package:bigio_rick_morty/features/characters/domain/usecases/get_character_detail.dart';

class MockCharacterRepository extends Mock implements CharacterRepository {}

void main() {
  late CharacterRepository repo;
  late GetCharacterDetail usecase;

  setUp(() {
    repo = MockCharacterRepository();
    usecase = GetCharacterDetail(repo);
  });

  test('should return character detail when repository succeeds', () async {
    final character = Character(
      id: 1,
      name: 'Rick Sanchez',
      species: 'Human',
      gender: 'Male',
      origin: 'Earth',
      location: 'Earth',
      image: 'https://example.com/rick.png',
    );

    when(() => repo.getCharacterDetail(any()))
        .thenAnswer((_) async => Right(character));

    final result = await usecase(1);

    expect(result, Right(character));
    verify(() => repo.getCharacterDetail(1)).called(1);
    verifyNoMoreInteractions(repo);
  });

  test('should return Failure when repository fails', () async {
    when(() => repo.getCharacterDetail(any())).thenAnswer(
      (_) async => Left(const ServerFailure(message: 'error')),
    );

    final result = await usecase(1);

    expect(result.isLeft(), true);
    verify(() => repo.getCharacterDetail(1)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
