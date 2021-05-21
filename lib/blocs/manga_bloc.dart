import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  final ErrorBloc _errorBloc;
  final List<Manga> _listManga = [];

  MangaBloc(this._errorBloc) : super(MangaUninitialized());

  @override
  Stream<MangaState> mapEventToState(MangaEvent event) async* {
    if (event is MangaFetch) {
      try {
        yield MangaLoading();

        int currentPage = event.page;
        int nextPage = currentPage + 1;
        List<Manga> listManga =
            await Service.getManga(TypeManga.manga, pageNumber: currentPage);

        // filter to be manga because this api fetch all manga
        listManga = listManga
            .where((element) => element.type.toLowerCase() == 'manga')
            .toList();

        // append new items
        _listManga.addAll(listManga);

        yield MangaFetchSuccess(listManga: _listManga, nextPage: nextPage);
      } on SocketException {
        _errorBloc.add(ErrorShow.noConnection());
      } catch (e) {
        print(e);
        _errorBloc.add(ErrorShow.global());
      }
    }
  }
}
