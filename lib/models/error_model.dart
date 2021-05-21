import 'package:equatable/equatable.dart';

class ErrorModel extends Equatable {
  final String message;

  ErrorModel(this.message);

  factory ErrorModel.noConnection() {
    return ErrorModel('Oops... check your internet connection');
  }

  factory ErrorModel.global() {
    return ErrorModel('Oops... something wrong');
  }

  factory ErrorModel.custom(String message) {
    return ErrorModel(message);
  }

  @override
  List<Object?> get props => [message];
}
