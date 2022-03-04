import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class MangaState extends Equatable {
  const MangaState();

  @override
  List<Object?> get props => [];
}

class MangaUninitialized extends MangaState {}

class MangaLoading extends MangaState {}

class MangaError extends MangaState {}

class MangaFetchSuccess extends MangaState {
  final List<Manga> listManga;
  final int nextPage;

  const MangaFetchSuccess({
    required this.listManga,
    required this.nextPage,
  });

  @override
  List<Object?> get props => [listManga, nextPage];
}
