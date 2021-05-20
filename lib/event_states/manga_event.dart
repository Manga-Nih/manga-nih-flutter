import 'package:equatable/equatable.dart';

abstract class MangaEvent extends Equatable {
  MangaEvent();
}

class MangaFetch extends MangaEvent {
  @override
  List<Object?> get props => [];
}
