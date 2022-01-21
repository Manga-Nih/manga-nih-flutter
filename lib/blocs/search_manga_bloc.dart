import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class SearchMangaBloc extends Bloc<SearchMangaEvent, SearchMangaState> {
  final Komiku _komiku = Komiku();

  SearchMangaBloc() : super(SearchMangaUninitialized());

  @override
  Stream<SearchMangaState> mapEventToState(SearchMangaEvent event) async* {
    try {
      if (event is SearchMangaFetch) {
        yield SearchMangaLoading();

        List<Manga> listSearchManga =
            await _komiku.search(keyword: event.keyword);

        yield SearchMangaFetchSuccess(listSearchManga: listSearchManga);
      }
    } on SocketException catch (e) {
      log(e.toString(), name: 'SearchMangaState - SocketException');

      SnackbarModel.noConnection();
    } catch (e) {
      log(e.toString(), name: 'SearchMangaState');

      SnackbarModel.globalError();
    }
  }
}
