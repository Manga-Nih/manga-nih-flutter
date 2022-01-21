import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/komiku_sdk.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class ManhwaBloc extends Bloc<ManhwaEvent, ManhwaState> {
  final Komiku _komiku = Komiku();
  final List<Manga> _listManhwa = [];

  ManhwaBloc() : super(ManhwaUninitialized());

  @override
  Stream<ManhwaState> mapEventToState(ManhwaEvent event) async* {
    if (event is ManhwaFetch) {
      try {
        yield ManhwaLoading();

        int currentPage = event.page;
        int nextPage = currentPage + 1;
        List<Manga> listManhwa = await _komiku.allManhwa(page: currentPage);

        // append new items
        _listManhwa.addAll(listManhwa);

        yield ManhwaFetchSuccess(
          listManhwa: _listManhwa,
          nextPage: nextPage,
        );
      } on SocketException catch (e) {
        log(e.toString(), name: 'ManhwaFetch - SocketException');

        SnackbarModel.noConnection();
      } catch (e) {
        log(e.toString(), name: 'ManhwaFetch - SocketException');

        SnackbarModel.globalError();
      }
    }
  }
}
