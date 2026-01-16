import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/character.dart';
import '../../../domain/usecases/get_character_detail.dart';
import '../../../domain/usecases/is_favorite.dart';
import '../../../domain/usecases/add_favorite.dart';
import '../../../domain/usecases/remove_favorite.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetCharacterDetail getCharacterDetail;

  // Favorites Usecases
  final IsFavorite isFavorite;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;

  DetailBloc({
    required this.getCharacterDetail,
    required this.isFavorite,
    required this.addFavorite,
    required this.removeFavorite,
  }) : super(const DetailLoading()) {
    on<DetailStarted>(_onStarted);
    on<DetailFavoriteToggled>(_onFavoriteToggled);
  }

  Future<void> _onStarted(DetailStarted event, Emitter<DetailState> emit) async {
    emit(const DetailLoading());

    final Either<Failure, dynamic> result = await getCharacterDetail(event.id);

    await result.fold(
      (failure) async => emit(DetailError(failure.message)),
      (character) async {
        if (character == null) {
          emit(const DetailEmpty());
          return;
        }

        // Load favorite status dari SQLite
        final favEither = await isFavorite(character.id);
        final isFav = favEither.getOrElse(() => false);

        emit(DetailLoaded(character: character, isFavorite: isFav));
      },
    );
  }

  Future<void> _onFavoriteToggled(
    DetailFavoriteToggled event,
    Emitter<DetailState> emit,
  ) async {
    final current = state;
    if (current is! DetailLoaded) return;

    final Character character = current.character;
    final bool nextFav = !current.isFavorite;

    emit(current.copyWith(isFavorite: nextFav));

    final Either<Failure, Unit> persistResult = nextFav
        ? await addFavorite(character)
        : await removeFavorite(character.id);

    persistResult.fold(
      (_) => emit(current), 
      (_) {}, 
    );
  }
}
