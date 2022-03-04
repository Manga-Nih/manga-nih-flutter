import 'package:equatable/equatable.dart';

abstract class SearchMangaEvent extends Equatable {
  const SearchMangaEvent();

  @override
  List<Object?> get props => [];
}

class SearchMangaFetch extends SearchMangaEvent {
  final String keyword;

  const SearchMangaFetch({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}
