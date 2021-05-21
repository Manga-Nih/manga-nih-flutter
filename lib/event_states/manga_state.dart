import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

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

  MangaFetchSuccess({required this.listManga});

  @override
  List<Object?> get props => [listManga];
}
