import 'package:equatable/equatable.dart';

abstract class LatestMangaEvent extends Equatable {
  const LatestMangaEvent();

  @override
  List<Object?> get props => [];
}

class LatestMangaFetch extends LatestMangaEvent {}
