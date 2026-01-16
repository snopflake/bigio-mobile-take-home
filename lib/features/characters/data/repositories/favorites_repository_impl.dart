import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';
import '../models/favorite_character_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource local;

  FavoritesRepositoryImpl(this.local);

  @override
  Future<Either<Failure, List<Character>>> getFavorites() async {
    try {
      final models = await local.getAll();
      final entities = models.map((e) => e.toEntity()).toList(growable: false);
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int id) async {
    try {
      final res = await local.isFavorite(id);
      return Right(res);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addFavorite(Character character) async {
    try {
      final model = FavoriteCharacterModel.fromEntity(character);
      await local.upsert(model);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite(int id) async {
    try {
      await local.remove(id);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
