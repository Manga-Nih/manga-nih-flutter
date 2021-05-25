import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final SnackbarBloc _snackbarBloc;

  GenreBloc(this._snackbarBloc) : super(GenreUninitialized());

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async* {
    if (event is GenreFetch) {
      try {
        yield GenreLoading();

        List<Genre> listGenre = await Service.getGenre();

        yield GenreFetchSuccess(listGenre: listGenre);
      } on SocketException {
        _snackbarBloc.add(SnackbarShow.noConnection());
      } catch (e) {
        print(e);
        _snackbarBloc.add(SnackbarShow.globalError());
      }
    }
  }
}
