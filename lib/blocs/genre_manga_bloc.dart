import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class GenreMangaBloc extends Bloc<GenreMangaEvent, GenreMangaState> {
  final SnackbarBloc _snackbarBloc;
  final List<Map<String, Set<GenreManga>>> _listGenreManga = [];

  GenreMangaBloc(this._snackbarBloc) : super(GenreMangaUninitialized());

  @override
  Stream<GenreMangaState> mapEventToState(GenreMangaEvent event) async* {
    try {
      if (event is GenreMangaFetch) {
        Genre genre = event.genre;
        int currentPage = event.page;
        int nextPage = currentPage + 1;

        List<GenreManga> listGenreManga =
            await Service.getGenreManga(genre, pageNumber: currentPage);

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
        List<GenreManga> listSelected = _listGenreManga
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
    } on SocketException {
      _snackbarBloc.add(SnackbarShow.noConnection());
    } catch (e) {
      print(e);
      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }
}
