import 'package:equatable/equatable.dart';

abstract class PopularMangaEvent extends Equatable {
  const PopularMangaEvent();

  @override
  List<Object?> get props => [];
}

class PopularMangaFetch extends PopularMangaEvent {
  final int page;

  const PopularMangaFetch({this.page = 1});

  @override
  List<Object?> get props => [page];
}
