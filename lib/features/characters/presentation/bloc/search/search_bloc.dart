import 'package:bloc/bloc.dart';

import '../../../domain/usecases/search_characters.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchCharacters searchCharacters;

  SearchBloc({required this.searchCharacters}) : super(const SearchInitial()) {
    on<SearchRequested>(_onSearchRequested);
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchRequested(
    SearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(SearchLoading(query));

    final result = await searchCharacters(name: query, page: event.page);

    result.fold(
      (failure) => emit(SearchError(query: query, message: failure.message)),
      (characters) {
        if (characters.isEmpty) {
          emit(SearchEmpty(query));
        } else {
          emit(SearchLoaded(query: query, results: characters));
        }
      },
    );
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchInitial());
  }
}
