import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/services/services.dart';

class ManhwaBloc extends Bloc<ManhwaEvent, ManhwaState> {
  final Komiku _komiku = Komiku();
  final SnackbarBloc _snackbarBloc;
  final List<Manga> _listManhwa = [];

  ManhwaBloc(this._snackbarBloc) : super(ManhwaUninitialized());

  @override
  Stream<ManhwaState> mapEventToState(ManhwaEvent event) async* {
    if (event is ManhwaFetch) {
      try {
        yield ManhwaLoading();

        int currentPage = event.page;
        int nextPage = currentPage + 1;
        List<Manga> listManhwa = await _komiku.allManhwa(page: currentPage);

        // append new items
        _listManhwa.addAll(listManhwa);

        yield ManhwaFetchSuccess(
          listManhwa: _listManhwa,
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
