import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/favorites_repository.dart';

class IsFavorite {
  final FavoritesRepository repository;

  IsFavorite(this.repository);

  Future<Either<Failure, bool>> call(int id) {
    return repository.isFavorite(id);
  }
}