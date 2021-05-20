import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class ManhwaBloc extends Bloc<ManhwaEvent, ManhwaState> {
  ManhwaBloc() : super(ManhwaUninitialized());

  @override
  Stream<ManhwaState> mapEventToState(ManhwaEvent event) async* {
    if (event is ManhwaFetch) {
      try {
        yield ManhwaLoading();

        List<Manga> listManhwa = await Service.getManga(TypeManga.manhwa);

        yield ManhwaFetchSuccess(listManhwa: listManhwa);
      } catch (e) {
        print(e);
        yield ManhwaError();
      }
    }
  }
}
