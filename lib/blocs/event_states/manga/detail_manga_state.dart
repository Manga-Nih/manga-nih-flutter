import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class DetailMangaState extends Equatable {
  const DetailMangaState();

  @override
  List<Object?> get props => [];
}

class DetailMangaUninitialized extends DetailMangaState {}

class DetailMangaLoading extends DetailMangaState {}

class DetailMangaError extends DetailMangaState {}

class DetailMangaFetchSuccess extends DetailMangaState {
  final MangaDetail mangaDetail;

  const DetailMangaFetchSuccess({required this.mangaDetail});

  @override
  List<Object?> get props => [mangaDetail];
}
