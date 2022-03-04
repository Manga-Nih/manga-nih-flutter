import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FeedbackUninitialized extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackError extends FeedbackState {}

class FeedbackSubmitSuccess extends FeedbackState {}
