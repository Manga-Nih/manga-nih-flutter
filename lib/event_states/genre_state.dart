import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class GenreState extends Equatable {
  GenreState();
}

class GenreUninitialized extends GenreState {
  @override
  List<Object?> get props => [];
}

class GenreLoading extends GenreState {
  @override
  List<Object?> get props => [];
}

class GenreFetchSuccess extends GenreState {
  final List<Genre> listGenre;

  GenreFetchSuccess({required this.listGenre});

  @override
  List<Object?> get props => [listGenre];
}
