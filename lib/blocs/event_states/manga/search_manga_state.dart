import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class SearchMangaState extends Equatable {
  const SearchMangaState();

  @override
  List<Object?> get props => [];
}

class SearchMangaUninitialized extends SearchMangaState {}

class SearchMangaLoading extends SearchMangaState {}

class SearchMangaError extends SearchMangaState {}

class SearchMangaFetchSuccess extends SearchMangaState {
  final List<Manga> listSearchManga;

  const SearchMangaFetchSuccess({required this.listSearchManga});

  @override
  List<Object?> get props => [listSearchManga];
}
