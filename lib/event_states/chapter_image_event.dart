import 'package:equatable/equatable.dart';

abstract class ChapterImageEvent extends Equatable {
  ChapterImageEvent();
}

class ChapterImageFetch extends ChapterImageEvent {
  final String endpoint;

  ChapterImageFetch({required this.endpoint});

  @override
  List<Object?> get props => [];
}
