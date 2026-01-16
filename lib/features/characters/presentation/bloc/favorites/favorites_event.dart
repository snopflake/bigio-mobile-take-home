import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesFetchRequested extends FavoritesEvent {
  const FavoritesFetchRequested();
}

class FavoriteRemoved extends FavoritesEvent {
  final int id;
  const FavoriteRemoved(this.id);

  @override
  List<Object?> get props => [id];
}
