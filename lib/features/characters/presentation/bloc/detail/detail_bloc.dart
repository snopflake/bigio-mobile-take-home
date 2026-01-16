import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecases/get_character_detail.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetCharacterDetail getCharacterDetail;

  DetailBloc({
    required this.getCharacterDetail,
  }) : super(const DetailLoading()) {
    on<DetailStarted>(_onStarted);
    on<DetailFavoriteToggled>(_onFavoriteToggled);
  }

  Future<void> _onStarted(DetailStarted event, Emitter<DetailState> emit) async {
    emit(const DetailLoading());

    final Either<Failure, dynamic> result = await getCharacterDetail(event.id);

    result.fold(
      (failure) => emit(DetailError(failure.message)),
      (character) async {
        if (character == null) {
          emit(const DetailEmpty());
          return;
        }

        // TODO(SQLite): await _loadFavoriteStatus(character.id)
        final isFav = false;

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

    final nextFav = !current.isFavorite;

    // Optimistic update (UX lebih bagus)
    emit(current.copyWith(isFavorite: nextFav));

    // TODO(SQLite): persist favorite status
    // final ok = await _persistFavorite(current.character, nextFav);
    // if (!ok) emit(current); // rollback kalau gagal
  }
}
