import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/character.dart';

abstract class CharacterRepository {
  Future<Either<Failure, List<Character>>> getCharacters({int page = 1});
  Future<Either<Failure, Character>> getCharacterDetail(int id);
  Future<Either<Failure, List<Character>>> searchCharacters({
    required String name,
    int page = 1,
  });
}