import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  final Komiku _komiku = Komiku();
  final List<Manga> _listManga = [];

  MangaBloc() : super(MangaUninitialized()) {
    on(_onMangaFetch);
  }

  Future<void> _onMangaFetch(MangaFetch event, Emitter<MangaState> emit) async {
    try {
      emit(MangaLoading());

      int currentPage = event.page;
      int nextPage = currentPage + 1;
      List<Manga> listManga = await _komiku.allManga(page: currentPage);

      // append new items
      _listManga.addAll(listManga);

      emit(MangaFetchSuccess(listManga: _listManga, nextPage: nextPage));
    } catch (e) {
      emit(MangaError());

      log(e.toString(), name: 'MangaFetch');

      SnackbarModel.globalError();
    }
  }
}
