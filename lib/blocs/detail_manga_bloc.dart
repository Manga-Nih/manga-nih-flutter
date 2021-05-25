import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class DetailMangaBloc extends Bloc<DetailMangaEvent, DetailMangaState> {
  final SnackbarBloc _snackbarBloc;
  DetailMangaBloc(this._snackbarBloc) : super(DetailMangaUninitialized());

  @override
  Stream<DetailMangaState> mapEventToState(DetailMangaEvent event) async* {
    try {
      if (event is DetailMangaFetch) {
        yield DetailMangaLoading();

        DetailManga detailManga = await Service.getDetailManga(event.endpoint);

        yield DetailMangaFetchSuccess(detailManga: detailManga);
      }
    } on SocketException {
      _snackbarBloc.add(SnackbarShow.noConnection());
    } catch (e) {
      print(e);
      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }
}
