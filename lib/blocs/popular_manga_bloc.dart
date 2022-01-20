import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';

class PopularMangaBloc extends Bloc<PopularMangaEvent, PopularMangaState> {
  final SnackbarBloc _snackbarBloc;
  final List<PopularManga> _listPopular = [];
  final Komiku _komiku = Komiku();

  PopularMangaBloc(this._snackbarBloc) : super(PopularMangaUninitialized());

  @override
  Stream<PopularMangaState> mapEventToState(PopularMangaEvent event) async* {
    if (event is PopularMangaFetch) {
      try {
        yield PopularMangaLoading();

        List<PopularManga> listPopular = await _komiku.popular();

        // append new items
        _listPopular.addAll(listPopular);

        yield PopularMangaFetchSuccess(listPopular: _listPopular);
      } on SocketException catch (e) {
        log(e.toString(), name: 'PopularMangaFetch - SocketException');

        _snackbarBloc.add(SnackbarShow.noConnection());
      } catch (e) {
        log(e.toString(), name: 'PopularMangaFetch');

        _snackbarBloc.add(SnackbarShow.globalError());
      }
    }
  }
}
