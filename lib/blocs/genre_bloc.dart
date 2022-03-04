import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreUninitialized()) {
    on(_onGenreFetch);
  }

  Future<void> _onGenreFetch(GenreFetch event, Emitter<GenreState> emit) async {
    try {
      emit(GenreLoading());

      List<Genre> listGenre = Genre.all();

      emit(GenreFetchSuccess(listGenre: listGenre));
    } catch (e) {
      emit(GenreError());

      log(e.toString(), name: 'GenreFetch');

      SnackbarModel.globalError();
    }
  }
}
