import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class FavoriteMangaState extends Equatable {
  FavoriteMangaState();
}

class FavoriteMangaUninitialized extends FavoriteMangaState {
  @override
  List<Object?> get props => [];
}

class FavoriteMangaError extends FavoriteMangaState {
  @override
  List<Object?> get props => [];
}

class FavoriteMangaFetchListSuccess extends FavoriteMangaState {
  final List<FavoriteManga> listFavoriteManga;

  FavoriteMangaFetchListSuccess({required this.listFavoriteManga});

  @override
  List<Object?> get props => [listFavoriteManga];
}
