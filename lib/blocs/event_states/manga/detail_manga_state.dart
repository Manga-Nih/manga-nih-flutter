import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

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

class DetailMangaError extends DetailMangaState {
  @override
  List<Object?> get props => [];
}

class DetailMangaFetchSuccess extends DetailMangaState {
  final MangaDetail mangaDetail;

  DetailMangaFetchSuccess({required this.mangaDetail});

  @override
  List<Object?> get props => [mangaDetail];
}
