import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bigio_rick_morty/core/error/failure.dart';
import 'package:bigio_rick_morty/features/characters/domain/entities/character.dart';
import 'package:bigio_rick_morty/features/characters/domain/repositories/character_repository.dart';
import 'package:bigio_rick_morty/features/characters/domain/usecases/get_characters.dart';

class MockCharacterRepository extends Mock implements CharacterRepository {}

void main() {
  late CharacterRepository repo;
  late GetCharacters usecase;

  setUp(() {
    repo = MockCharacterRepository();
    usecase = GetCharacters(repo);
  });

  test('should return list of characters when repository succeeds', () async {
    final characters = <Character>[
      Character(
        id: 1,
        name: 'Rick Sanchez',
        species: 'Human',
        gender: 'Male',
        origin: 'Earth',
        location: 'Earth',
        image: 'https://example.com/rick.png',
      ),
    ];

    when(() => repo.getCharacters(page: any(named: 'page')))
        .thenAnswer((_) async => Right(characters));

    final result = await usecase(page: 1);

    expect(result, Right(characters));
    verify(() => repo.getCharacters(page: 1)).called(1);
    verifyNoMoreInteractions(repo);
  });

  test('should return Failure when repository fails', () async {
    when(() => repo.getCharacters(page: any(named: 'page'))).thenAnswer(
      (_) async => Left(const ServerFailure(message: 'error')),
    );

    final result = await usecase(page: 1);

    expect(result.isLeft(), true);
    verify(() => repo.getCharacters(page: 1)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
