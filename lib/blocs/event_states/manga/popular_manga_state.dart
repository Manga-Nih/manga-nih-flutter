import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class PopularMangaState extends Equatable {
  const PopularMangaState();

  @override
  List<Object?> get props => [];
}

class PopularMangaUninitialized extends PopularMangaState {}

class PopularMangaLoading extends PopularMangaState {}

class PopularMangaError extends PopularMangaState {}

class PopularMangaFetchSuccess extends PopularMangaState {
  final List<PopularManga> listPopular;

  const PopularMangaFetchSuccess({required this.listPopular});

  @override
  List<Object?> get props => [listPopular];
}
