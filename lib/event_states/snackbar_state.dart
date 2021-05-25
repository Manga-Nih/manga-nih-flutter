import 'package:equatable/equatable.dart';
import 'package:manga_nih/models/models.dart';

abstract class SnackbarState extends Equatable {
  SnackbarState();
}

class SnackbarUninitialized extends SnackbarState {
  @override
  List<Object?> get props => [];
}

class SnackbarShowing extends SnackbarState {
  final SnackbarModel snackbar;

  SnackbarShowing(this.snackbar);

  @override
  List<Object?> get props => [snackbar];
}
