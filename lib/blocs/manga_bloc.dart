import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  MangaBloc() : super(MangaUninitialized());

  @override
  Stream<MangaState> mapEventToState(MangaEvent event) async* {
    if (event is MangaFetch) {
      try {
        yield MangaLoading();

        List<Manga> listManga = await Service.getManga(TypeManga.manga);

        // filter to be manga because this api fetch all manga
        listManga = listManga
            .where((element) => element.type.toLowerCase() == 'manga')
            .toList();

        yield MangaFetchSuccess(listManga: listManga);
      } catch (e) {
        print(e);
        yield MangaError();
      }
    }
  }
}
