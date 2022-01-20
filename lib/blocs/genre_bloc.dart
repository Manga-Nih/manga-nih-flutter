import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final SnackbarBloc _snackbarBloc;

  GenreBloc(this._snackbarBloc) : super(GenreUninitialized());

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async* {
    if (event is GenreFetch) {
      try {
        yield GenreLoading();

        List<Genre> listGenre = Genre.all();

        yield GenreFetchSuccess(listGenre: listGenre);
      } on SocketException catch (e) {
        log(e.toString(), name: 'GenreFetch - SocketException');

        _snackbarBloc.add(SnackbarShow.noConnection());
      } catch (e) {
        log(e.toString(), name: 'GenreFetch');

        _snackbarBloc.add(SnackbarShow.globalError());
      }
    }
  }
}
