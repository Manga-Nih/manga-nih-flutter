import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class DetailMangaBloc extends Bloc<DetailMangaEvent, DetailMangaState> {
  final Komiku _komiku = Komiku();

  DetailMangaBloc() : super(DetailMangaUninitialized()) {
    on(_onDetailMangaFetch);
  }

  Future<void> _onDetailMangaFetch(
      DetailMangaFetch event, Emitter<DetailMangaState> emit) async {
    try {
      emit(DetailMangaLoading());

      MangaDetail detail = await _komiku.detail(detailEndpoint: event.endpoint);

      emit(DetailMangaFetchSuccess(mangaDetail: detail));
    } catch (e) {
      emit(DetailMangaError());

      log(e.toString(), name: 'DetailMangaFetch');

      SnackbarModel.globalError();
    }
  }
}
