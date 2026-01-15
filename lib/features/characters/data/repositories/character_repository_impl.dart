
import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_data_source.dart';
import '../models/character_model.dart'; 

class CharacterRepositoryImpl implements CharacterRepository{
  final CharacterRemoteDataSource remote;

  const CharacterRepositoryImpl(
    this.remote
  );

  @override
  Future<Either<Failure, List<Character>>> getCharacters({int page = 1}) async {
    try {
      final paged = await remote.getCharacters(page: page);
      final entities = paged.results.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, Character>> getCharacterDetail(int id) async {
    try {
      final model = await remote.getCharacterDetail(id);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return const Left(UnknownFailure(message: 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, List<Character>>> searchCharacters({
    required String name,
    int page = 1,
  }) async {
    try {
      final paged = await remote.searchCharacters(name: name, page: page);
      final entities = paged.results.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on ApiException catch (e) {

      // Empty State
      if (e.statusCode == 404) {
        return const Right(<Character>[]);
      }
      return Left(_mapApiExceptionToFailure(e));

    } catch (e) {
      return const Left(UnknownFailure(message: 'Unknown error'));
    }

  }

  Failure _mapApiExceptionToFailure(ApiException e) {
    if (e.statusCode == null) {
      return NetworkFailure(
        message: e.message
      );
    } else {
      return ServerFailure(
        statusCode: e.statusCode!,
        message: e.message,
      );
    }
  }

}