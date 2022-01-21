import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class FavoriteMangaEvent extends Equatable {
  FavoriteMangaEvent();
}

class FavoriteMangaAddRemove extends FavoriteMangaEvent {
  final MangaDetail favoriteManga;

  FavoriteMangaAddRemove({required this.favoriteManga});

  @override
  List<Object?> get props => [favoriteManga];
}

class FavoriteMangaFetchList extends FavoriteMangaEvent {
  FavoriteMangaFetchList();

  @override
  List<Object?> get props => [];
}
