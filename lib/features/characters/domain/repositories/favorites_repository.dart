import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/character.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Character>>> getFavorites();
  Future<Either<Failure, bool>> isFavorite(int id);
  Future<Either<Failure, Unit>> addFavorite(Character character);
  Future<Either<Failure, Unit>> removeFavorite(int id);
}