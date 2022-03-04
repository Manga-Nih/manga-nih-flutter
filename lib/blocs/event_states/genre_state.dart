import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object?> get props => [];
}

class GenreUninitialized extends GenreState {}

class GenreLoading extends GenreState {}

class GenreError extends GenreState {}

class GenreFetchSuccess extends GenreState {
  final List<Genre> listGenre;

  const GenreFetchSuccess({required this.listGenre});

  @override
  List<Object?> get props => [listGenre];
}
