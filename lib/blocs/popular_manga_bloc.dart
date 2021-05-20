import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class PopularMangaBloc extends Bloc<PopularMangaEvent, PopularMangaState> {
  PopularMangaBloc() : super(PopularMangaUninitialized());

  @override
  Stream<PopularMangaState> mapEventToState(PopularMangaEvent event) async* {
    if (event is PopularMangaFetch) {
      try {
        yield PopularMangaLoading();

        List<PopularManga> listPopular = await Service.getPopularManga();

        yield PopularMangaFetchSuccess(listPopular: listPopular);
      } catch (e) {
        print(e);
        yield PopularMangaError();
      }
    }
  }
}
