import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreUninitialized());

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async* {
    if (event is GenreFetch) {
      try {
        yield GenreLoading();

        List<Genre> listGenre = Genre.all();

        yield GenreFetchSuccess(listGenre: listGenre);
      } on SocketException catch (e) {
        log(e.toString(), name: 'GenreFetch - SocketException');

        SnackbarModel.noConnection();
      } catch (e) {
        log(e.toString(), name: 'GenreFetch');

        SnackbarModel.globalError();
      }
    }
  }
}
