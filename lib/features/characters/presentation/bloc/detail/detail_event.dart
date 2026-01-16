import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object?> get props => [];
}

class DetailStarted extends DetailEvent {
  final int id;
  const DetailStarted(this.id);

  @override
  List<Object?> get props => [id];
}

class DetailFavoriteToggled extends DetailEvent {
  const DetailFavoriteToggled();
}
