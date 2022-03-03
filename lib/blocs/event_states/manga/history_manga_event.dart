import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class HistoryMangaEvent extends Equatable {
  HistoryMangaEvent();
}

class HistoryMangaAdd extends HistoryMangaEvent {
  final HistoryManga historyManga;

  HistoryMangaAdd({required this.historyManga});

  @override
  List<Object?> get props => [historyManga];
}

class HistoryMangaClear extends HistoryMangaEvent {
  @override
  List<Object?> get props => [];
}

class HistoryMangaFetchList extends HistoryMangaEvent {
  HistoryMangaFetchList();

  @override
  List<Object?> get props => [];
}
