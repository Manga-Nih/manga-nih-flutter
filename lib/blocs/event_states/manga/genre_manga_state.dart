import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class GenreMangaState extends Equatable {
  const GenreMangaState();

  @override
  List<Object?> get props => [];
}

class GenreMangaUninitialized extends GenreMangaState {}

class GenreMangaLoading extends GenreMangaState {}

class GenreMangaError extends GenreMangaState {}

class GenreMangaFetchSuccess extends GenreMangaState {
  final Genre genre;
  final List<Manga> listGenreManga;
  final int nextPage;
  final bool isLastPage;

  const GenreMangaFetchSuccess({
    required this.genre,
    required this.listGenreManga,
    required this.nextPage,
    required this.isLastPage,
  });

  @override
  List<Object?> get props => [genre, listGenreManga, nextPage, isLastPage];
}
