import 'package:equatable/equatable.dart';
import 'package:komiku_sdk/models.dart';

abstract class ChapterImageState extends Equatable {
  ChapterImageState();
}

class ChapterImageUninitialized extends ChapterImageState {
  @override
  List<Object?> get props => [];
}

class ChapterImageLoading extends ChapterImageState {
  @override
  List<Object?> get props => [];
}

class ChapterImageError extends ChapterImageState {
  @override
  List<Object?> get props => [];
}

class ChapterImageFetchSuccess extends ChapterImageState {
  final ChapterDetail chapterDetail;

  ChapterImageFetchSuccess({required this.chapterDetail});

  @override
  List<Object?> get props => [chapterDetail];
}
