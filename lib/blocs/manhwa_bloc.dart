import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class ManhwaBloc extends Bloc<ManhwaEvent, ManhwaState> {
  final Komiku _komiku = Komiku();
  final List<Manga> _listManhwa = [];

  ManhwaBloc() : super(ManhwaUninitialized()) {
    on(_onManhwaFetch);
  }

  Future<void> _onManhwaFetch(
      ManhwaFetch event, Emitter<ManhwaState> emit) async {
    try {
      emit(ManhwaLoading());

      int currentPage = event.page;
      int nextPage = currentPage + 1;
      List<Manga> listManhwa = await _komiku.allManhwa(page: currentPage);

      // append new items
      _listManhwa.addAll(listManhwa);

      emit(ManhwaFetchSuccess(listManhwa: _listManhwa, nextPage: nextPage));
    } catch (e) {
      emit(ManhwaError());

      log(e.toString(), name: 'ManhwaFetch');

      SnackbarModel.globalError();
    }
  }
}
