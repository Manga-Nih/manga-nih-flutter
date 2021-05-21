import 'package:equatable/equatable.dart';

abstract class MangaEvent extends Equatable {
  MangaEvent();
}

class MangaFetch extends MangaEvent {
  final int page;

  MangaFetch({required this.page});

  @override
  List<Object?> get props => [page];
}
