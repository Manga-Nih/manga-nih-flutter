import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class SearchMangaState extends Equatable {
  SearchMangaState();
}

class SearchMangaUninitialized extends SearchMangaState {
  @override
  List<Object?> get props => [];
}

class SearchMangaLoading extends SearchMangaState {
  @override
  List<Object?> get props => [];
}

class SearchMangaFetchSuccess extends SearchMangaState {
  final List<Manga> listSearchManga;

  SearchMangaFetchSuccess({required this.listSearchManga});

  @override
  List<Object?> get props => [listSearchManga];
}
