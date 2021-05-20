import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class ManhuaBloc extends Bloc<ManhuaEvent, ManhuaState> {
  ManhuaBloc() : super(ManhuaUninitialized());

  @override
  Stream<ManhuaState> mapEventToState(ManhuaEvent event) async* {
    if (event is ManhuaFetch) {
      try {
        yield ManhuaLoading();

        List<Manga> listManga = await Service.getManga(TypeManga.manhua);

        yield ManhuaFetchSuccess(listManhua: listManga);
      } catch (e) {
        print(e);
        yield ManhuaError();
      }
    }
  }
}
