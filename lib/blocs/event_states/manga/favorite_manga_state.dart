import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class FavoriteMangaState extends Equatable {
  const FavoriteMangaState();

  @override
  List<Object?> get props => [];
}

class FavoriteMangaUninitialized extends FavoriteMangaState {}

class FavoriteMangaError extends FavoriteMangaState {}

class FavoriteMangaFetchListSuccess extends FavoriteMangaState {
  final List<FavoriteManga> listFavoriteManga;

  const FavoriteMangaFetchListSuccess({required this.listFavoriteManga});

  @override
  List<Object?> get props => [listFavoriteManga];
}
