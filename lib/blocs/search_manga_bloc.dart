import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class SearchMangaBloc extends Bloc<SearchMangaEvent, SearchMangaState> {
  final Komiku _komiku = Komiku.instance;

  SearchMangaBloc() : super(SearchMangaUninitialized()) {
    on(_onSearchMangaFetch);
  }

  Future<void> _onSearchMangaFetch(
      SearchMangaFetch event, Emitter<SearchMangaState> emit) async {
    try {
      emit(SearchMangaLoading());

      List<Manga> listSearchManga =
          await _komiku.search(keyword: event.keyword);

      emit(SearchMangaFetchSuccess(listSearchManga: listSearchManga));
    } catch (e) {
      emit(SearchMangaError());

      log(e.toString(), name: 'SearchMangaFetch');

      SnackbarModel.globalError();
    }
  }
}
