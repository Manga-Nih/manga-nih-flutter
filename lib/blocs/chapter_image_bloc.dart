import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class ChapterImageBloc extends Bloc<ChapterImageEvent, ChapterImageState> {
  final SnackbarBloc _snackbarBloc;

  ChapterImageBloc(this._snackbarBloc) : super(ChapterImageUninitialized());

  @override
  Stream<ChapterImageState> mapEventToState(ChapterImageEvent event) async* {
    try {
      if (event is ChapterImageFetch) {
        yield ChapterImageLoading();

        String endpoint = event.endpoint;
        ChapterImage chapterImage = await Service.getChapterImage(endpoint);

        yield ChapterImageFetchSuccess(chapterImage: chapterImage);
      }
    } on SocketException {
      _snackbarBloc.add(SnackbarShow.noConnection());
    } catch (e) {
      print(e);
      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }
}
