import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class ChapterImageBloc extends Bloc<ChapterImageEvent, ChapterImageState> {
  final Komiku _komiku = Komiku();

  ChapterImageBloc() : super(ChapterImageUninitialized());

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

      SnackbarModel.noConnection();
    } catch (e) {
      log(e.toString(), name: 'ChapterImageFetch');

      SnackbarModel.globalError();
    }
  }
}
