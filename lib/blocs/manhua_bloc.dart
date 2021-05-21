import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class ManhuaBloc extends Bloc<ManhuaEvent, ManhuaState> {
  final ErrorBloc _errorBloc;
  final List<Manga> _listManhua = [];

  ManhuaBloc(this._errorBloc) : super(ManhuaUninitialized());

  @override
  Stream<ManhuaState> mapEventToState(ManhuaEvent event) async* {
    if (event is ManhuaFetch) {
      try {
        yield ManhuaLoading();

        int currentPage = event.page;
        int nextPage = currentPage + 1;
        List<Manga> listManga =
            await Service.getManga(TypeManga.manhua, pageNumber: currentPage);

        // append new items
        _listManhua.addAll(listManga);

        yield ManhuaFetchSuccess(
          listManhua: _listManhua,
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
