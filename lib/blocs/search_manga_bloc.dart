import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class SearchMangaBloc extends Bloc<SearchMangaEvent, SearchMangaState> {
  final SnackbarBloc _snackbarBloc;

  SearchMangaBloc(this._snackbarBloc) : super(SearchMangaUninitialized());

  @override
  Stream<SearchMangaState> mapEventToState(SearchMangaEvent event) async* {
    try {
      if (event is SearchMangaFetch) {
        yield SearchMangaLoading();

        List<SearchManga> listSearchManga =
            await Service.getSearchManga(event.keyword);

        yield SearchMangaFetchSuccess(listSearchManga: listSearchManga);
      }
    } on SocketException {
      _snackbarBloc.add(SnackbarShow.noConnection());
    } catch (e) {
      print(e);
      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }
}
