import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable{
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeFetchRequested extends HomeEvent {
  final int page;

  const HomeFetchRequested({
    this.page = 1,
  });

  @override
  List<Object?> get props => [page];
}