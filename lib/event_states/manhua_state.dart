import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class ManhuaState extends Equatable {
  ManhuaState();
}

class ManhuaUninitialized extends ManhuaState {
  @override
  List<Object?> get props => [];
}

class ManhuaError extends ManhuaState {
  @override
  List<Object?> get props => [];
}

class ManhuaLoading extends ManhuaState {
  @override
  List<Object?> get props => [];
}

class ManhuaFetchSuccess extends ManhuaState {
  final List<Manga> listManhua;

  ManhuaFetchSuccess({required this.listManhua});

  @override
  List<Object?> get props => [listManhua];
}
