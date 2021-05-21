import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class ManhwaBloc extends Bloc<ManhwaEvent, ManhwaState> {
  final ErrorBloc _errorBloc;

  ManhwaBloc(this._errorBloc) : super(ManhwaUninitialized());

  @override
  Stream<ManhwaState> mapEventToState(ManhwaEvent event) async* {
    if (event is ManhwaFetch) {
      try {
        yield ManhwaLoading();

        List<Manga> listManhwa = await Service.getManga(TypeManga.manhwa);

        yield ManhwaFetchSuccess(listManhwa: listManhwa);
      } on SocketException {
        _errorBloc.add(ErrorShow.noConnection());
      } catch (e) {
        print(e);
        _errorBloc.add(ErrorShow.global());
      }
    }
  }
}
