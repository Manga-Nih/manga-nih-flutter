import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class ManhwaState extends Equatable {
  const ManhwaState();

  @override
  List<Object?> get props => [];
}

class ManhwaUninitialized extends ManhwaState {}

class ManhwaLoading extends ManhwaState {}

class ManhwaError extends ManhwaState {}

class ManhwaFetchSuccess extends ManhwaState {
  final List<Manga> listManhwa;
  final int nextPage;

  const ManhwaFetchSuccess({
    required this.listManhwa,
    required this.nextPage,
  });

  @override
  List<Object?> get props => [listManhwa, nextPage];
}
