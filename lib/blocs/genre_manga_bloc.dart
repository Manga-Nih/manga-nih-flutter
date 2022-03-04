import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class GenreMangaBloc extends Bloc<GenreMangaEvent, GenreMangaState> {
  final Komiku _komiku = Komiku();
  final List<Map<String, Set<Manga>>> _listGenreManga = [];

  GenreMangaBloc() : super(GenreMangaUninitialized()) {
    on(_onGenreMangaFetch);
  }

  Future<void> _onGenreMangaFetch(
      GenreMangaFetch event, Emitter<GenreMangaState> emit) async {
    try {
      Genre genre = event.genre;
      int currentPage = event.page;
      int nextPage = currentPage + 1;

      List<Manga> listGenreManga = await _komiku.allMangaByGenre(
          page: currentPage, genreEndpoint: genre.endpoint);

      // append to list
      // check if genre already exist or not
      if (_listGenreManga
          .where((element) => element.keys.first == genre.endpoint)
          .isEmpty) {
        // why set, to avoid duplicate data
        _listGenreManga.add({genre.endpoint: listGenreManga.toSet()});
      } else {
        // why set, to avoid duplicate data
        _listGenreManga
            .where((element) => element.keys.first == genre.endpoint)
            .first
            .values
            .first
            .addAll(listGenreManga.toSet());
      }

      // get list manga base on genre while fetch
      // key is genre.endpoint
      List<Manga> listSelected = _listGenreManga
          .where((element) => element.keys.first == genre.endpoint)
          .first // get first filtered element
          .values // get values from map
          .first // get first
          .toList(); // convert to list

      emit(GenreMangaFetchSuccess(
        genre: genre,
        listGenreManga: listSelected,
        nextPage: nextPage,
        isLastPage: listGenreManga.isEmpty, // if list empty or last page
      ));
    } catch (e) {
      emit(GenreMangaError());

      log(e.toString(), name: 'GenreMangaFetch');

      SnackbarModel.globalError();
    }
  }
}
