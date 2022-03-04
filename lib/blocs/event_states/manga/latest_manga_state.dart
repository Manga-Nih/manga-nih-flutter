import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class LatestMangaState extends Equatable {
  const LatestMangaState();

  @override
  List<Object?> get props => [];
}

class LatestMangaUninitialized extends LatestMangaState {}

class LatestMangaLoading extends LatestMangaState {}

class LatestMangaError extends LatestMangaState {}

class LatestMangaFetchSuccess extends LatestMangaState {
  final List<LatestManga> listLatest;

  const LatestMangaFetchSuccess({required this.listLatest});

  @override
  List<Object?> get props => [listLatest];
}
