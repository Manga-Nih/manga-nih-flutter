import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class ChapterImageBloc extends Bloc<ChapterImageEvent, ChapterImageState> {
  final Komiku _komiku = Komiku();

  ChapterImageBloc() : super(ChapterImageUninitialized()) {
    on(_onChapterImageFetch);
  }

  Future<void> _onChapterImageFetch(
      ChapterImageFetch event, Emitter<ChapterImageState> emit) async {
    try {
      emit(ChapterImageLoading());

      String endpoint = event.endpoint;
      ChapterDetail detail = await _komiku.chapter(chapterEndpoint: endpoint);

      emit(ChapterImageFetchSuccess(chapterDetail: detail));
    } catch (e) {
      emit(ChapterImageError());

      log(e.toString(), name: 'ChapterImageFetch');

      SnackbarModel.globalError();
    }
  }
}
