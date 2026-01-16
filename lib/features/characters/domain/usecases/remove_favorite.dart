import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/favorites_repository.dart';

class RemoveFavorite {
  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  Future<Either<Failure, Unit>> call(int id) {
    return repository.removeFavorite(id);
  }
}