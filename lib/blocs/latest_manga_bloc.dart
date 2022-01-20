import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';

class LatestMangaBloc extends Bloc<LatestMangaEvent, LatestMangaState> {
  final Komiku _komiku = Komiku();
  final SnackbarBloc _snackbarBloc;

  LatestMangaBloc(this._snackbarBloc) : super(LatestMangaUninitialized());

  @override
  Stream<LatestMangaState> mapEventToState(LatestMangaEvent event) async* {
    if (event is LatestMangaFetch) {
      try {
        yield LatestMangaLoading();

        List<LatestManga> listLatest = await _komiku.latest();

        yield LatestMangaFetchSuccess(listLatest: listLatest);
      } on SocketException catch (e) {
        log(e.toString(), name: 'LatestMangaFetch - SocketException');

        _snackbarBloc.add(SnackbarShow.noConnection());
      } catch (e) {
        log(e.toString(), name: 'LatestMangaFetch');

        _snackbarBloc.add(SnackbarShow.globalError());
      }
    }
  }
}
