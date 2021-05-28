import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class HistoryMangaState extends Equatable {
  HistoryMangaState();
}

class HistoryMangaUninitialized extends HistoryMangaState {
  @override
  List<Object?> get props => [];
}

class HistoryMangaFetchListSuccess extends HistoryMangaState {
  final List<HistoryManga> listHistoryManga;

  HistoryMangaFetchListSuccess({required this.listHistoryManga});

  @override
  List<Object?> get props => [listHistoryManga];
}
