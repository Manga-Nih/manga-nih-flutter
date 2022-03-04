import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class ManhwaState extends Equatable {
  ManhwaState();
}

class ManhwaUninitialized extends ManhwaState {
  @override
  List<Object?> get props => [];
}

class ManhwaLoading extends ManhwaState {
  @override
  List<Object?> get props => [];
}

class ManhwaError extends ManhwaState {
  @override
  List<Object?> get props => [];
}

class ManhwaFetchSuccess extends ManhwaState {
  final List<Manga> listManhwa;
  final int nextPage;

  ManhwaFetchSuccess({required this.listManhwa, required this.nextPage});

  @override
  List<Object?> get props => [listManhwa, nextPage];
}
