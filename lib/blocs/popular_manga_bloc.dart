import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class PopularMangaBloc extends Bloc<PopularMangaEvent, PopularMangaState> {
  final ErrorBloc _errorBloc;
  final List<PopularManga> _listPopular = [];

  PopularMangaBloc(this._errorBloc) : super(PopularMangaUninitialized());

  @override
  Stream<PopularMangaState> mapEventToState(PopularMangaEvent event) async* {
    if (event is PopularMangaFetch) {
      try {
        yield PopularMangaLoading();

        int currentPage = event.page;
        int nextPage = currentPage + 1;
        List<PopularManga> listPopular =
            await Service.getPopularManga(pageNumber: currentPage);

        // append new items
        _listPopular.addAll(listPopular);

        yield PopularMangaFetchSuccess(
          listPopular: _listPopular,
          nextPage: nextPage,
        );
      } on SocketException {
        _errorBloc.add(ErrorShow.noConnection());
      } catch (e) {
        print(e);
        _errorBloc.add(ErrorShow.global());
      }
    }
  }
}
