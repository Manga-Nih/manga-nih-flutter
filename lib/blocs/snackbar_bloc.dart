import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/event_states/event_states.dart';

class SnackbarBloc extends Bloc<SnackbarEvent, SnackbarState> {
  SnackbarBloc() : super(SnackbarUninitialized());

  @override
  Stream<SnackbarState> mapEventToState(SnackbarEvent event) async* {
    if (event is SnackbarShow) {
      yield SnackbarShowing(event.snackbar);

      // re init
      yield SnackbarUninitialized();
    }
  }
}
