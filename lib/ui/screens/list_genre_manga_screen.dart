import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
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
  late GenreMangaBloc _genreMangaBloc;
  late GenreBloc _genreBloc;
  late Genre _genre;
  late List<Map<Genre, PagingController<int, GenreManga>>>
      _listPagingController = [];
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
    _listPagingController.forEach((element) => element.values.first.dispose());

    super.dispose();
  }

  void _addPagingController() {
    // avoid adding duplicate paging with same genre
    if (_listPagingController
        .where((element) => element.keys.first.endpoint == _genre.endpoint)
        .isEmpty) {
      PagingController<int, GenreManga> pagingController =
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

  void _profileAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  void _genreAction(Genre genre) {
    setState(() {
      _genre = genre;
      _addPagingController();
    });
  }

  void _mangaAction(GenreManga genreManga) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailMangaScreen(mangaEndpoint: genreManga.endpoint),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: _buildHeader(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Stack(
            children: _listPagingController.map((e) {
              Genre genre = e.keys.first;
              PagingController<int, GenreManga> pagingController =
                  e.values.first;

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
                  child: PagedListView<int, GenreManga>(
                    pagingController: pagingController,
                    physics: BouncingScrollPhysics(),
                    builderDelegate: PagedChildBuilderDelegate<GenreManga>(
                        itemBuilder: (context, item, index) {
                      GenreManga genreManga = item;

                      return MangaCard<GenreManga>(
                        manga: genreManga,
                        onTap: _mangaAction,
                      );
                    }, newPageProgressIndicatorBuilder: (context) {
                      return MangaCard.loading();
                    }, firstPageProgressIndicatorBuilder: (context) {
                      return MangaCard.loading();
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
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserFetchSuccess) {
                  return HeaderProfile(
                    name: state.name,
                    onTap: _profileAction,
                  );
                }
                return HeaderProfile.defaultValue(onTap: _profileAction);
              },
            ),
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

                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
