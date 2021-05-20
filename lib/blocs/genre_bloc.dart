import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreUninitialized());

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async* {
    if (event is GenreFetch) {
      try {
        yield GenreLoading();

        List<Genre> listGenre = await Service.getGenre();

        yield GenreFetchSuccess(listGenre: listGenre);
      } catch (e) {
        print(e);
        yield GenreError();
      }
    }
  }
}
