import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacterDetail {
  final CharacterRepository repository;

  const GetCharacterDetail(
    this.repository,
  );

  Future<Either<Failure, Character>> call(int id){
    return repository.getCharacterDetail(id);
  }
}