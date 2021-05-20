import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  GenreEvent();
}

class GenreFetch extends GenreEvent {
  @override
  List<Object?> get props => [];
}
