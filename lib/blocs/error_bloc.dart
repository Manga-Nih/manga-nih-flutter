import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/event_states/event_states.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc() : super(ErrorUninitialized());

  @override
  Stream<ErrorState> mapEventToState(ErrorEvent event) async* {
    if (event is ErrorReInitialization) {
      yield ErrorUninitialized();
    }

    if (event is ErrorShow) {
      yield ErrorShowing(event.error);
    }
  }
}
