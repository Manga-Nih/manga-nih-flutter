import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class MangaState extends Equatable {
  MangaState();
}

class MangaUninitialized extends MangaState {
  @override
  List<Object?> get props => [];
}

class MangaLoading extends MangaState {
  @override
  List<Object?> get props => [];
}

class MangaFetchSuccess extends MangaState {
  final List<Manga> listManga;
  final int nextPage;

  MangaFetchSuccess({
    required this.listManga,
    required this.nextPage,
  });

  @override
  List<Object?> get props => [listManga, nextPage];
}
