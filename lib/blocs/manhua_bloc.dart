import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class ManhuaBloc extends Bloc<ManhuaEvent, ManhuaState> {
  final Komiku _komiku = Komiku();
  final List<Manga> _listManhua = [];

  ManhuaBloc() : super(ManhuaUninitialized()) {
    on(_onManhuaFetch);
  }

  Future<void> _onManhuaFetch(
      ManhuaFetch event, Emitter<ManhuaState> emit) async {
    try {
      emit(ManhuaLoading());

      int currentPage = event.page;
      int nextPage = currentPage + 1;
      List<Manga> listManga = await _komiku.allManhua(page: currentPage);

      // append new items
      _listManhua.addAll(listManga);

      emit(ManhuaFetchSuccess(listManhua: _listManhua, nextPage: nextPage));
    } catch (e) {
      emit(ManhuaError());

      log(e.toString(), name: 'ManhuaFetch');

      SnackbarModel.globalError();
    }
  }
}
