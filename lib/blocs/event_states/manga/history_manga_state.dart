import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class HistoryMangaState extends Equatable {
  const HistoryMangaState();

  @override
  List<Object?> get props => [];
}

class HistoryMangaUninitialized extends HistoryMangaState {}

class HistoryMangaError extends HistoryMangaState {}

class HistoryMangaFetchListSuccess extends HistoryMangaState {
  final List<HistoryManga> listHistoryManga;

  const HistoryMangaFetchListSuccess({required this.listHistoryManga});

  @override
  List<Object?> get props => [listHistoryManga];
}
