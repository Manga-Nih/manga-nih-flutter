import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';

class ChapterImageBloc extends Bloc<ChapterImageEvent, ChapterImageState> {
  final Komiku _komiku = Komiku();
  final SnackbarBloc _snackbarBloc;

  ChapterImageBloc(this._snackbarBloc) : super(ChapterImageUninitialized());

  @override
  Stream<ChapterImageState> mapEventToState(ChapterImageEvent event) async* {
    try {
      if (event is ChapterImageFetch) {
        yield ChapterImageLoading();

        String endpoint = event.endpoint;
        ChapterDetail detail = await _komiku.chapter(chapterEndpoint: endpoint);

        yield ChapterImageFetchSuccess(chapterDetail: detail);
      }
    } on SocketException catch (e) {
      log(e.toString(), name: 'ChapterImageFetch - SocketException');

      _snackbarBloc.add(SnackbarShow.noConnection());
    } catch (e) {
      log(e.toString(), name: 'ChapterImageFetch');

      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }
}
