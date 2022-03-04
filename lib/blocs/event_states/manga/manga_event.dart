import 'package:equatable/equatable.dart';

abstract class MangaEvent extends Equatable {
  const MangaEvent();

  @override
  List<Object?> get props => [];
}

class MangaFetch extends MangaEvent {
  final int page;

  const MangaFetch({required this.page});

  @override
  List<Object?> get props => [page];
}
