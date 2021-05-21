import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class PopularMangaState extends Equatable {
  PopularMangaState();
}

class PopularMangaUninitialized extends PopularMangaState {
  @override
  List<Object?> get props => [];
}

class PopularMangaLoading extends PopularMangaState {
  @override
  List<Object?> get props => [];
}

class PopularMangaFetchSuccess extends PopularMangaState {
  final List<PopularManga> listPopular;
  final int nextPage;

  PopularMangaFetchSuccess({required this.listPopular, required this.nextPage});

  @override
  List<Object?> get props => [listPopular, nextPage];
}
