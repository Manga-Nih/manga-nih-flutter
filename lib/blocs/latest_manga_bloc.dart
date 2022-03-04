import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class LatestMangaBloc extends Bloc<LatestMangaEvent, LatestMangaState> {
  final Komiku _komiku = Komiku();

  LatestMangaBloc() : super(LatestMangaUninitialized()) {
    on(_onLatestMangaEvent);
  }

  Future<void> _onLatestMangaEvent(
      LatestMangaEvent event, Emitter<LatestMangaState> emit) async {
    try {
      emit(LatestMangaLoading());

      List<LatestManga> listLatest = await _komiku.latest();

      emit(LatestMangaFetchSuccess(listLatest: listLatest));
    } catch (e) {
      emit(LatestMangaError());

      log(e.toString(), name: 'LatestMangaFetch');

      SnackbarModel.globalError();
    }
  }
}
