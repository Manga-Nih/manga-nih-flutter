import 'package:equatable/equatable.dart';

class SnackbarModel extends Equatable {
  final String message;
  final bool isError;

  SnackbarModel(this.isError, this.message);

  factory SnackbarModel.noConnection() {
    return SnackbarModel(true, 'Oops... check your internet connection');
  }

  factory SnackbarModel.globalError() {
    return SnackbarModel(true, 'Oops... something wrong');
  }

  factory SnackbarModel.custom(bool isError, String message) {
    return SnackbarModel(isError, message);
  }

  @override
  List<Object?> get props => [message];
}
