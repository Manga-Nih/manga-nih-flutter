import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

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

class ManhwaFetchSuccess extends ManhwaState {
  final List<Manga> listManhwa;

  ManhwaFetchSuccess({required this.listManhwa});

  @override
  List<Object?> get props => [listManhwa];
}
