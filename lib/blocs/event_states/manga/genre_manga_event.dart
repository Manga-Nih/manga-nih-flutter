import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class GenreMangaEvent extends Equatable {
  const GenreMangaEvent();

  @override
  List<Object?> get props => [];
}

class GenreMangaFetch extends GenreMangaEvent {
  final Genre genre;
  final int page;

  const GenreMangaFetch({required this.genre, required this.page});

  @override
  List<Object?> get props => [genre, page];
}
