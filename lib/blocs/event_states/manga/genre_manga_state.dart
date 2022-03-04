import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class GenreMangaState extends Equatable {
  GenreMangaState();
}

class GenreMangaUninitialized extends GenreMangaState {
  @override
  List<Object?> get props => [];
}

class GenreMangaLoading extends GenreMangaState {
  @override
  List<Object?> get props => [];
}

class GenreMangaError extends GenreMangaState {
  @override
  List<Object?> get props => [];
}

class GenreMangaFetchSuccess extends GenreMangaState {
  final Genre genre;
  final List<Manga> listGenreManga;
  final int nextPage;
  final bool isLastPage;

  GenreMangaFetchSuccess({
    required this.genre,
    required this.listGenreManga,
    required this.nextPage,
    required this.isLastPage,
  });

  @override
  List<Object?> get props => [genre, listGenreManga, nextPage, isLastPage];
}
