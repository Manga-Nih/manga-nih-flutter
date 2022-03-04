import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListGenreManga extends StatefulWidget {
  final Genre genre;

  const ListGenreManga({Key? key, required this.genre}) : super(key: key);

  @override
  _ListGenreMangaState createState() => _ListGenreMangaState();
}

class _ListGenreMangaState extends State<ListGenreManga> {
  final List<Map<Genre, PagingController<int, Manga>>> _listPagingController =
      [];
  late GenreMangaBloc _genreMangaBloc;
  late GenreBloc _genreBloc;
  late Genre _genre;
  late ItemScrollController _genreScrollController;

  @override
  void initState() {
    // init bloc
    _genreMangaBloc = BlocProvider.of<GenreMangaBloc>(context);
    _genreBloc = BlocProvider.of<GenreBloc>(context);

    // init scroll controller
    _genreScrollController = ItemScrollController();

    // init state genre
    _genre = widget.genre;

    // scroll to selected genre
    GenreState genreState = _genreBloc.state;
    if (genreState is GenreFetchSuccess) {
      int genreIndex =
          genreState.listGenre.indexWhere((element) => element == widget.genre);

      // execute when build function complete
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _genreScrollController.scrollTo(
          index: genreIndex,
          duration: const Duration(seconds: 1),
        );
      });
    }

    // add initial paging
    _addPagingController();

    super.initState();
  }

  @override
  void dispose() {
    for (var element in _listPagingController) {
      element.values.first.dispose();
    }

    super.dispose();
  }

  void _addPagingController() {
    // avoid adding duplicate paging with same genre
    if (_listPagingController
        .where((element) => element.keys.first.endpoint == _genre.endpoint)
        .isEmpty) {
      PagingController<int, Manga> pagingController =
          PagingController(firstPageKey: 1)
            ..addPageRequestListener((pageKey) {
              // fetch genre manga
              _fetchManga(pageKey);
            });

      _listPagingController.add({_genre: pagingController});
    }
  }

  void _fetchManga(int page) {
    _genreMangaBloc.add(GenreMangaFetch(genre: _genre, page: page));
  }

  void _genreAction(Genre genre) {
    setState(() {
      _genre = genre;
      _addPagingController();
    });
  }

  void _mangaAction(Manga genreManga) {
    Get.to(() => DetailMangaScreen(mangaEndpoint: genreManga.detailEndpoint));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: _buildHeader(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Stack(
            children: _listPagingController.map((e) {
              Genre genre = e.keys.first;
              PagingController<int, Manga> pagingController = e.values.first;

              return Offstage(
                offstage: genre.endpoint != _genre.endpoint,
                child: BlocListener<GenreMangaBloc, GenreMangaState>(
                  listener: (context, state) {
                    if (state is GenreMangaFetchSuccess) {
                      // to avoid apply list genre manga in all paging controller
                      if (genre == state.genre) {
                        if (state.isLastPage) {
                          // to trigger last page
                          pagingController.appendLastPage([]);
                        } else {
                          pagingController.value = PagingState(
                            nextPageKey: state.nextPage,
                            itemList: state.listGenreManga,
                          );
                        }
                      }
                    }
                  },
                  child: PagedListView<int, Manga>(
                    pagingController: pagingController,
                    physics: const BouncingScrollPhysics(),
                    builderDelegate: PagedChildBuilderDelegate<Manga>(
                        itemBuilder: (context, item, index) {
                      Manga genreManga = item;

                      return MangaCard(
                        manga: genreManga,
                        onTap: _mangaAction,
                      );
                    }, newPageProgressIndicatorBuilder: (context) {
                      return const MangaCard.loading();
                    }, firstPageProgressIndicatorBuilder: (context) {
                      return const MangaCard.loading();
                    }),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: HeaderProfile(),
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 30.0,
            alignment: Alignment.center,
            child: BlocBuilder<GenreBloc, GenreState>(
              builder: (context, state) {
                if (state is GenreFetchSuccess) {
                  return ScrollablePositionedList.builder(
                    scrollDirection: Axis.horizontal,
                    itemScrollController: _genreScrollController,
                    itemCount: state.listGenre.length,
                    itemBuilder: (context, index) {
                      Genre genre = state.listGenre[index];
                      return CapsuleButton(
                        label: genre.name,
                        isSelected: genre == _genre,
                        onPressed: () => _genreAction(genre),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
