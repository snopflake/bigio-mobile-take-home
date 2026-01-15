import 'package:equatable/equatable.dart';

import '../../../domain/entities/character.dart';

abstract class HomeState extends Equatable{
  const HomeState();

  @override
  List<Object?> get props => [];
}

class Homeinitial extends HomeState {
  const Homeinitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Character> characters;

  const HomeLoaded(
    this.characters
  );

  @override
  List<Object?> get props => [characters];
}

class HomeEmpty extends HomeState {
  const HomeEmpty();
}

class HomeError extends HomeState {
  final String message;

  const HomeError(
    this.message
  );

  @override
  List<Object?> get props => [message];
}