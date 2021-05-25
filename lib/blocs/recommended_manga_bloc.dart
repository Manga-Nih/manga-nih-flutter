import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class RecommendedMangaBloc
    extends Bloc<RecommendedMangaEvent, RecommendedMangaState> {
  final SnackbarBloc _snackbarBloc;

  RecommendedMangaBloc(this._snackbarBloc)
      : super(RecommendedMangaUninitialized());

  @override
  Stream<RecommendedMangaState> mapEventToState(
      RecommendedMangaEvent event) async* {
    if (event is RecommendedMangaFetch) {
      try {
        yield RecommendedMangaLoading();

        List<RecommendedManga> listRecommended =
            await Service.getRecommendedManga();

        yield RecommendedMangaFetchSuccess(listRecommended: listRecommended);
      } on SocketException {
        _snackbarBloc.add(SnackbarShow.noConnection());
      } catch (e) {
        print(e);
        _snackbarBloc.add(SnackbarShow.globalError());
      }
    }
  }
}
