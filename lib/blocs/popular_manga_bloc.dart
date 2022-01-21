import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class PopularMangaBloc extends Bloc<PopularMangaEvent, PopularMangaState> {
  final Komiku _komiku = Komiku();
  final List<PopularManga> _listPopular = [];

  PopularMangaBloc() : super(PopularMangaUninitialized());

  @override
  Stream<PopularMangaState> mapEventToState(PopularMangaEvent event) async* {
    if (event is PopularMangaFetch) {
      try {
        yield PopularMangaLoading();

        List<PopularManga> listPopular = await _komiku.popular();

        // append new items
        _listPopular.addAll(listPopular);

        yield PopularMangaFetchSuccess(listPopular: _listPopular);
      } on SocketException catch (e) {
        log(e.toString(), name: 'PopularMangaFetch - SocketException');

        SnackbarModel.noConnection();
      } catch (e) {
        log(e.toString(), name: 'PopularMangaFetch');

        SnackbarModel.globalError();
      }
    }
  }
}
