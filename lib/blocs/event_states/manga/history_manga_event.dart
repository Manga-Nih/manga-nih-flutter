import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class HistoryMangaEvent extends Equatable {
  const HistoryMangaEvent();

  @override
  List<Object?> get props => [];
}

class HistoryMangaClear extends HistoryMangaEvent {}

class HistoryMangaFetchList extends HistoryMangaEvent {}

class HistoryMangaAdd extends HistoryMangaEvent {
  final HistoryManga historyManga;

  const HistoryMangaAdd({required this.historyManga});

  @override
  List<Object?> get props => [historyManga];
}
