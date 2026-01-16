import 'package:bloc/bloc.dart';

import '../../../domain/entities/character.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/remove_favorite.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final RemoveFavorite removeFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.removeFavorite,
  }) : super(const FavoritesLoading()) {
    on<FavoritesFetchRequested>(_onFetch);
    on<FavoriteRemoved>(_onRemove);
  }

  Future<void> _onFetch(
    FavoritesFetchRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    final result = await getFavorites();

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (list) {
        if (list.isEmpty) {
          emit(const FavoritesEmpty());
        } else {
          emit(FavoritesLoaded(list));
        }
      },
    );
  }

  Future<void> _onRemove(
    FavoriteRemoved event,
    Emitter<FavoritesState> emit,
  ) async {
    final current = state;
    if (current is! FavoritesLoaded) return;

    final next = List<Character>.from(current.favorites)
      ..removeWhere((c) => c.id == event.id);

    emit(next.isEmpty ? const FavoritesEmpty() : FavoritesLoaded(next));

    final res = await removeFavorite(event.id);

    res.fold(
      (_) => emit(current),
      (_) {},
    );
  }
}
