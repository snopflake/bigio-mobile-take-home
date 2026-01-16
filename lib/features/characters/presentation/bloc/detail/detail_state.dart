import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

abstract class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object?> get props => [];
}

class DetailLoading extends DetailState {
  const DetailLoading();
}

class DetailEmpty extends DetailState {
  const DetailEmpty();
}

class DetailError extends DetailState {
  final String message;
  const DetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class DetailLoaded extends DetailState {
  final Character character;
  final bool isFavorite;

  const DetailLoaded({
    required this.character,
    required this.isFavorite,
  });

  DetailLoaded copyWith({
    Character? character,
    bool? isFavorite,
  }) {
    return DetailLoaded(
      character: character ?? this.character,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [character, isFavorite];
}
