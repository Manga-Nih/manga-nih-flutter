import 'package:equatable/equatable.dart';

abstract class DetailMangaEvent extends Equatable {
  const DetailMangaEvent();

  @override
  List<Object?> get props => [];
}

class DetailMangaFetch extends DetailMangaEvent {
  final String endpoint;

  const DetailMangaFetch({required this.endpoint});

  @override
  List<Object?> get props => [endpoint];
}
