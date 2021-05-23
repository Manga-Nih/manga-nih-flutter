import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class DetailMangaState extends Equatable {
  DetailMangaState();
}

class DetailMangaUninitialized extends DetailMangaState {
  @override
  List<Object?> get props => [];
}

class DetailMangaLoading extends DetailMangaState {
  @override
  List<Object?> get props => [];
}

class DetailMangaFetchSuccess extends DetailMangaState {
  final DetailManga detailManga;

  DetailMangaFetchSuccess({required this.detailManga});

  @override
  List<Object?> get props => [detailManga];
}
