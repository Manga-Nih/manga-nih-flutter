import 'package:equatable/equatable.dart';

abstract class PopularMangaEvent extends Equatable {
  PopularMangaEvent();
}

class PopularMangaFetch extends PopularMangaEvent {
  @override
  List<Object?> get props => [];
}
