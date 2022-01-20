import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';

class ManhuaBloc extends Bloc<ManhuaEvent, ManhuaState> {
  final Komiku _komiku = Komiku();
  final SnackbarBloc _snackbarBloc;
  final List<Manga> _listManhua = [];

  ManhuaBloc(this._snackbarBloc) : super(ManhuaUninitialized());

  @override
  Stream<ManhuaState> mapEventToState(ManhuaEvent event) async* {
    if (event is ManhuaFetch) {
      try {
        yield ManhuaLoading();

        int currentPage = event.page;
        int nextPage = currentPage + 1;
        List<Manga> listManga = await _komiku.allManhua(page: currentPage);

        // append new items
        _listManhua.addAll(listManga);

        yield ManhuaFetchSuccess(
          listManhua: _listManhua,
          nextPage: nextPage,
        );
      } on SocketException {
        _snackbarBloc.add(SnackbarShow.noConnection());
      } catch (e) {
        print(e);
        _snackbarBloc.add(SnackbarShow.globalError());
      }
    }
  }
}
