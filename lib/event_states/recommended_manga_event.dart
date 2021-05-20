import 'package:equatable/equatable.dart';

abstract class RecommendedMangaEvent extends Equatable {
  RecommendedMangaEvent();
}

class RecommendedMangaFetch extends RecommendedMangaEvent {
  @override
  List<Object?> get props => [];
}
