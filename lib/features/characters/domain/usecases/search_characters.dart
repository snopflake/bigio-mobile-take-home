import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';

class SearchCharacters {
  final CharacterRepository repository;

  const SearchCharacters(
    this.repository,
  );

  Future<Either<Failure, List<Character>>> call({
    required String name,
    int page = 1,
  }) {
    return repository.searchCharacters(
      name: name,
      page: page,
    );
  }
}