import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class LatestMangaBloc extends Bloc<LatestMangaEvent, LatestMangaState> {
  final Komiku _komiku = Komiku();

  LatestMangaBloc() : super(LatestMangaUninitialized());

  @override
  Stream<LatestMangaState> mapEventToState(LatestMangaEvent event) async* {
    if (event is LatestMangaFetch) {
      try {
        yield LatestMangaLoading();

        List<LatestManga> listLatest = await _komiku.latest();

        yield LatestMangaFetchSuccess(listLatest: listLatest);
      } on SocketException catch (e) {
        log(e.toString(), name: 'LatestMangaFetch - SocketException');

        SnackbarModel.noConnection();
      } catch (e) {
        log(e.toString(), name: 'LatestMangaFetch');

        SnackbarModel.globalError();
      }
    }
  }
}
