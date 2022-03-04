import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class ChapterImageState extends Equatable {
  const ChapterImageState();

  @override
  List<Object?> get props => [];
}

class ChapterImageUninitialized extends ChapterImageState {}

class ChapterImageLoading extends ChapterImageState {}

class ChapterImageError extends ChapterImageState {}

class ChapterImageFetchSuccess extends ChapterImageState {
  final ChapterDetail chapterDetail;

  const ChapterImageFetchSuccess({required this.chapterDetail});

  @override
  List<Object?> get props => [chapterDetail];
}
