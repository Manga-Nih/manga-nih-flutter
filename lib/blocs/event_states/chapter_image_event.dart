import 'package:equatable/equatable.dart';

abstract class ChapterImageEvent extends Equatable {
  const ChapterImageEvent();

  @override
  List<Object?> get props => [];
}

class ChapterImageFetch extends ChapterImageEvent {
  final String endpoint;

  const ChapterImageFetch({required this.endpoint});

  @override
  List<Object?> get props => [endpoint];
}
