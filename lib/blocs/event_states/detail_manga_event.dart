import 'package:equatable/equatable.dart';

abstract class DetailMangaEvent extends Equatable {
  DetailMangaEvent();
}

class DetailMangaFetch extends DetailMangaEvent {
  final String endpoint;

  DetailMangaFetch({required this.endpoint});

  @override
  List<Object?> get props => [endpoint];
}
