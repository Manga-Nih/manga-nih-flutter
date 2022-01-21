import 'package:equatable/equatable.dart';

abstract class PopularMangaEvent extends Equatable {
  PopularMangaEvent();
}

class PopularMangaFetch extends PopularMangaEvent {
  final int page;

  PopularMangaFetch({this.page = 1});

  @override
  List<Object?> get props => [page];
}
