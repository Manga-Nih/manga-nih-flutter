import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class PopularMangaState extends Equatable {
  PopularMangaState();
}

class PopularMangaUninitialized extends PopularMangaState {
  @override
  List<Object?> get props => [];
}

class PopularMangaError extends PopularMangaState {
  @override
  List<Object?> get props => [];
}

class PopularMangaLoading extends PopularMangaState {
  @override
  List<Object?> get props => [];
}

class PopularMangaFetchSuccess extends PopularMangaState {
  final List<PopularManga> listPopular;

  PopularMangaFetchSuccess({required this.listPopular});

  @override
  List<Object?> get props => [listPopular];
}
