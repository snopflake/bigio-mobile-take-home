import 'package:sqflite/sqflite.dart';

import '../../../../core/local_db/app_database.dart';
import '../models/favorite_character_model.dart';

abstract class FavoritesLocalDataSource {
  Future<void> upsert(FavoriteCharacterModel model);
  Future<void> remove(int id);
  Future<bool> isFavorite(int id);
  Future<List<FavoriteCharacterModel>> getAll();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final AppDatabase db;

  FavoritesLocalDataSourceImpl(this.db);

  static const _table = 'favorites';

  @override
  Future<void> upsert(FavoriteCharacterModel model) async {
    final database = await db.database;
    await database.insert(
      _table,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> remove(int id) async {
    final database = await db.database;
    await database.delete(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<bool> isFavorite(int id) async {
    final database = await db.database;
    final res = await database.query(
      _table,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  @override
  Future<List<FavoriteCharacterModel>> getAll() async {
    final database = await db.database;
    final res = await database.query(
      _table,
      orderBy: 'created_at DESC',
    );

    return res
        .map((e) => FavoriteCharacterModel.fromMap(e))
        .toList(growable: false);
  }
}
