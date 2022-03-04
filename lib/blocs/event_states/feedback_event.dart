import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class FeedbackSubmit extends FeedbackEvent {
  final FeedbackModel feedback;

  const FeedbackSubmit({required this.feedback});

  @override
  List<Object> get props => [feedback];
}
