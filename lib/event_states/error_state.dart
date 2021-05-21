import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class ErrorState extends Equatable {
  ErrorState();
}

class ErrorUninitialized extends ErrorState {
  @override
  List<Object?> get props => [];
}

class ErrorShowing extends ErrorState {
  final ErrorModel error;

  ErrorShowing(this.error);

  @override
  List<Object?> get props => [error];
}
