import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';

class SearchMangaBloc extends Bloc<SearchMangaEvent, SearchMangaState> {
  final Komiku _komiku = Komiku();
  final SnackbarBloc _snackbarBloc;

  SearchMangaBloc(this._snackbarBloc) : super(SearchMangaUninitialized());

  @override
  Stream<SearchMangaState> mapEventToState(SearchMangaEvent event) async* {
    try {
      if (event is SearchMangaFetch) {
        yield SearchMangaLoading();

        List<Manga> listSearchManga =
            await _komiku.search(keyword: event.keyword);

        yield SearchMangaFetchSuccess(listSearchManga: listSearchManga);
      }
    } on SocketException catch (e) {
      log(e.toString(), name: 'SearchMangaState - SocketException');

      _snackbarBloc.add(SnackbarShow.noConnection());
    } catch (e) {
      log(e.toString(), name: 'SearchMangaState');

      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }
}
