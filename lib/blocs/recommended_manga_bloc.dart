import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/services/services.dart';

class RecommendedMangaBloc
    extends Bloc<RecommendedMangaEvent, RecommendedMangaState> {
  RecommendedMangaBloc() : super(RecommendedMangaUninitialized());

  @override
  Stream<RecommendedMangaState> mapEventToState(
      RecommendedMangaEvent event) async* {
    if (event is RecommendedMangaFetch) {
      try {
        yield RecommendedMangaLoading();

        List<RecommendedManga> listRecommended =
            await Service.getRecommendedManga();

        yield RecommendedMangaFetchSuccess(listRecommended: listRecommended);
      } catch (e) {
        print(e);
        yield RecommendedMangaError();
      }
    }
  }
}
