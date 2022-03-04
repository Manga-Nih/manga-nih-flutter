import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class FavoriteMangaEvent extends Equatable {
  const FavoriteMangaEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteMangaAddRemove extends FavoriteMangaEvent {
  final MangaDetail favoriteManga;

  const FavoriteMangaAddRemove({required this.favoriteManga});

  @override
  List<Object?> get props => [favoriteManga];
}

class FavoriteMangaFetchList extends FavoriteMangaEvent {}
