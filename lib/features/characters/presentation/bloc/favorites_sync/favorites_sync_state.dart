import 'package:equatable/equatable.dart';

abstract class FavoritesSyncState extends Equatable {
  const FavoritesSyncState();

  @override
  List<Object?> get props => [];
}

class FavoritesSyncLoading extends FavoritesSyncState {
  const FavoritesSyncLoading();
}

class FavoritesSyncLoaded extends FavoritesSyncState {
  final Set<int> ids;

  const FavoritesSyncLoaded(this.ids);

  bool isFav(int id) => ids.contains(id);

  @override
  List<Object?> get props {
    final sorted = ids.toList()..sort();
    return [sorted];
  }
}

class FavoritesSyncError extends FavoritesSyncState {
  final String message;

  const FavoritesSyncError(this.message);

  @override
  List<Object?> get props => [message];
}
