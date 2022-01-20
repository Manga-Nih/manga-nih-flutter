import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  final Komiku _komiku = Komiku();
  final SnackbarBloc _snackbarBloc;
  final List<Manga> _listManga = [];

  MangaBloc(this._snackbarBloc) : super(MangaUninitialized());

  @override
  Stream<MangaState> mapEventToState(MangaEvent event) async* {
    if (event is MangaFetch) {
      try {
        yield MangaLoading();

        int currentPage = event.page;
        int nextPage = currentPage + 1;
        List<Manga> listManga = await _komiku.allManga(page: currentPage);

        // append new items
        _listManga.addAll(listManga);

        yield MangaFetchSuccess(listManga: _listManga, nextPage: nextPage);
      } on SocketException {
        _snackbarBloc.add(SnackbarShow.noConnection());
      } catch (e) {
        print(e);
        _snackbarBloc.add(SnackbarShow.globalError());
      }
    }
  }
}
