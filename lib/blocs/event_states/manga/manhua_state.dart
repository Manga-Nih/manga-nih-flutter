import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class ManhuaState extends Equatable {
  ManhuaState();
}

class ManhuaUninitialized extends ManhuaState {
  @override
  List<Object?> get props => [];
}

class ManhuaLoading extends ManhuaState {
  @override
  List<Object?> get props => [];
}

class ManhuaFetchSuccess extends ManhuaState {
  final List<Manga> listManhua;
  final int nextPage;

  ManhuaFetchSuccess({
    required this.listManhua,
    required this.nextPage,
  });

  @override
  List<Object?> get props => [listManhua, nextPage];
}
