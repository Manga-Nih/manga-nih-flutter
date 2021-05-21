import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class RecommendedMangaState extends Equatable {
  RecommendedMangaState();
}

class RecommendedMangaUninitialized extends RecommendedMangaState {
  @override
  List<Object?> get props => [];
}

class RecommendedMangaLoading extends RecommendedMangaState {
  @override
  List<Object?> get props => [];
}

class RecommendedMangaFetchSuccess extends RecommendedMangaState {
  final List<RecommendedManga> listRecommended;

  RecommendedMangaFetchSuccess({required this.listRecommended});

  @override
  List<Object?> get props => [listRecommended];
}
