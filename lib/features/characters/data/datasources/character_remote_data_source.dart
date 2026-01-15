import 'package:dio/dio.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/network/endpoints.dart';
import '../models/character_model.dart';
import '../models/paged_character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<PagedCharacterModel> getCharacters({int page = 1});
  Future<CharacterModel> getCharacterDetail(int id);
  Future<PagedCharacterModel> searchCharacters({
    required String name,
    int page = 1,
  });
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl(this.dio);

  @override
  Future<PagedCharacterModel> getCharacters({int page = 1}) async {
    try {
      final response = await dio.get(
        Endpoints.characters,
        queryParameters: {'page': page}
      );

      return PagedCharacterModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException(
        message: _extractMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<CharacterModel> getCharacterDetail(int id) async {
    try {
      final response = await dio.get('${Endpoints.characters}/$id');
      return CharacterModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException(
        message: _extractMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PagedCharacterModel> searchCharacters({
    required String name,
    int page = 1,
  }) async {
    try {
      final response = await dio.get(
        Endpoints.characters,
        queryParameters: {
          'name': name,
          'page': page,
        },
      );
      return PagedCharacterModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException(
        message: _extractMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  String _extractMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    // Fallback
    return e.message ?? 'Something went wrong';
  }
}

