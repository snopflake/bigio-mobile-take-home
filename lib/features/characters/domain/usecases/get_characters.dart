import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacters {
  final CharacterRepository repository;

  const GetCharacters(
    this.repository,
  );

  Future<Either<Failure, List<Character>>> call({int page = 1}) {
    return repository.getCharacters(page: page);
  }
}