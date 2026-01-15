import 'package:bloc/bloc.dart';

import '../../../domain/usecases/get_characters.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCharacters getCharacters;

  HomeBloc({required this.getCharacters}) : super(const Homeinitial()) {
    on<HomeFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    HomeFetchRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final result = await getCharacters(page: event.page);

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (characters) {
        if (characters.isEmpty) {
           emit(const HomeEmpty());
         } else {
          emit(HomeLoaded(characters));
         }
       }
     );
  }
}