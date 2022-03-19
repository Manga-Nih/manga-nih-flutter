import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class PopularMangaBloc extends Bloc<PopularMangaEvent, PopularMangaState> {
  final Komiku _komiku = Komiku.instance;
  final List<PopularManga> _listPopular = [];

  PopularMangaBloc() : super(PopularMangaUninitialized()) {
    on(_onPopularMangaFetch);
  }

  Future<void> _onPopularMangaFetch(
      PopularMangaFetch event, Emitter<PopularMangaState> emit) async {
    try {
      emit(PopularMangaLoading());

      List<PopularManga> listPopular = await _komiku.popular();

      // append new items
      _listPopular.addAll(listPopular);

      emit(PopularMangaFetchSuccess(listPopular: _listPopular));
    } catch (e) {
      emit(PopularMangaError());

      log(e.toString(), name: 'PopularMangaFetch');

      SnackbarModel.globalError();
    }
  }
}
