import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class GenreMangaEvent extends Equatable {
  GenreMangaEvent();
}

class GenreMangaFetch extends GenreMangaEvent {
  final Genre genre;
  final int page;

  GenreMangaFetch({required this.genre, required this.page});

  @override
  List<Object?> get props => [genre, page];
}
