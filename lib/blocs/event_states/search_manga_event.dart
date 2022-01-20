import 'package:equatable/equatable.dart';

abstract class SearchMangaEvent extends Equatable {
  SearchMangaEvent();
}

class SearchMangaFetch extends SearchMangaEvent {
  final String keyword;

  SearchMangaFetch({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}
