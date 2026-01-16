import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/character.dart';
import '../../../domain/usecases/add_favorite.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/remove_favorite.dart';
import 'favorites_sync_state.dart';

class FavoritesSyncCubit extends Cubit<FavoritesSyncState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;

  FavoritesSyncCubit({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
  }) : super(const FavoritesSyncLoading());

  Future<void> load() async {
    emit(const FavoritesSyncLoading());

    final result = await getFavorites();
    result.fold(
      (failure) => emit(FavoritesSyncError(failure.message)),
      (favorites) => emit(FavoritesSyncLoaded(
        favorites.map((c) => c.id).toSet(),
      )),
    );
  }

  Future<void> toggle(Character character) async {
    final current = state;
    if (current is! FavoritesSyncLoaded) return;

    final next = Set<int>.from(current.ids);
    final wasFav = next.contains(character.id);

    if (wasFav) {
      next.remove(character.id);
    } else {
      next.add(character.id);
    }
    emit(FavoritesSyncLoaded(next));

    final persistResult = wasFav
        ? await removeFavorite(character.id)
        : await addFavorite(character);

    persistResult.fold(
      (_) => emit(current),
      (_) {},
    );
  }

  bool isFav(int id) {
    final s = state;
    return s is FavoritesSyncLoaded ? s.isFav(id) : false;
  }
}
