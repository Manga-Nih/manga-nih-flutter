import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';

class DetailMangaBloc extends Bloc<DetailMangaEvent, DetailMangaState> {
  final Komiku _komiku = Komiku();
  final SnackbarBloc _snackbarBloc;
  DetailMangaBloc(this._snackbarBloc) : super(DetailMangaUninitialized());

  @override
  Stream<DetailMangaState> mapEventToState(DetailMangaEvent event) async* {
    try {
      if (event is DetailMangaFetch) {
        yield DetailMangaLoading();

        MangaDetail detail =
            await _komiku.detail(detailEndpoint: event.endpoint);

        yield DetailMangaFetchSuccess(mangaDetail: detail);
      }
    } on SocketException catch (e) {
      log(e.toString(), name: 'DetailMangaFetch - SocketException');

      _snackbarBloc.add(SnackbarShow.noConnection());
    } catch (e) {
      log(e.toString(), name: 'DetailMangaFetch');

      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }
}
