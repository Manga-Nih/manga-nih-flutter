import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

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

class ChapterImageFetchSuccess extends ChapterImageState {
  final ChapterImage chapterImage;

  ChapterImageFetchSuccess({required this.chapterImage});

  @override
  List<Object?> get props => [chapterImage];
}
