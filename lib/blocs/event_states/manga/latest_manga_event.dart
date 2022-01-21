import 'package:equatable/equatable.dart';

abstract class LatestMangaEvent extends Equatable {
  LatestMangaEvent();
}

class LatestMangaFetch extends LatestMangaEvent {
  @override
  List<Object?> get props => [];
}
