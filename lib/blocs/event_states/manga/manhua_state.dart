import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class ManhuaState extends Equatable {
  const ManhuaState();

  @override
  List<Object?> get props => [];
}

class ManhuaUninitialized extends ManhuaState {}

class ManhuaLoading extends ManhuaState {}

class ManhuaError extends ManhuaState {}

class ManhuaFetchSuccess extends ManhuaState {
  final List<Manga> listManhua;
  final int nextPage;

  const ManhuaFetchSuccess({
    required this.listManhua,
    required this.nextPage,
  });

  @override
  List<Object?> get props => [listManhua, nextPage];
}
