import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';

class GenreMangaBloc extends Bloc<GenreMangaEvent, GenreMangaState> {
  final Komiku _komiku = Komiku();
  final SnackbarBloc _snackbarBloc;
  final List<Map<String, Set<Manga>>> _listGenreManga = [];

  GenreMangaBloc(this._snackbarBloc) : super(GenreMangaUninitialized());

  @override
  Stream<GenreMangaState> mapEventToState(GenreMangaEvent event) async* {
    try {
      if (event is GenreMangaFetch) {
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

        yield GenreMangaFetchSuccess(
          genre: genre,
          listGenreManga: listSelected,
          nextPage: nextPage,
          isLastPage: listGenreManga.isEmpty, // if list empty or last page
        );
      }
    } on SocketException catch (e) {
      log(e.toString(), name: 'GenreMangaFetch');

      _snackbarBloc.add(SnackbarShow.noConnection());
    } catch (e) {
      log(e.toString(), name: 'GenreMangaFetch - SocketException');

      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }
}
