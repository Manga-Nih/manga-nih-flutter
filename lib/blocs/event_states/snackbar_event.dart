import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class SnackbarEvent extends Equatable {
  SnackbarEvent();
}

class SnackbarShow extends SnackbarEvent {
  final SnackbarModel snackbar;

  SnackbarShow(this.snackbar);

  factory SnackbarShow.noConnection() {
    return SnackbarShow(SnackbarModel.noConnection());
  }

  factory SnackbarShow.globalError() {
    return SnackbarShow(SnackbarModel.globalError());
  }

  factory SnackbarShow.custom(bool isError, String message) {
    return SnackbarShow(SnackbarModel.custom(isError, message));
  }

  @override
  List<Object?> get props => [snackbar];
}
