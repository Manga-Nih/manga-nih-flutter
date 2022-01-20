import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class LatestMangaState extends Equatable {
  LatestMangaState();
}

class LatestMangaUninitialized extends LatestMangaState {
  @override
  List<Object?> get props => [];
}

class LatestMangaLoading extends LatestMangaState {
  @override
  List<Object?> get props => [];
}

class LatestMangaFetchSuccess extends LatestMangaState {
  final List<LatestManga> listLatest;

  LatestMangaFetchSuccess({required this.listLatest});

  @override
  List<Object?> get props => [listLatest];
}
