import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class ErrorEvent extends Equatable {
  ErrorEvent();
}

class ErrorShow extends ErrorEvent {
  final ErrorModel error;

  ErrorShow(this.error);

  factory ErrorShow.noConnection() {
    return ErrorShow(ErrorModel.noConnection());
  }

  factory ErrorShow.global() {
    return ErrorShow(ErrorModel.global());
  }

  @override
  List<Object?> get props => [error];
}
