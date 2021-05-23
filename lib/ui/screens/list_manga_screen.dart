import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class ListMangaScreen extends StatefulWidget {
  final TypeManga typeManga;

  const ListMangaScreen({Key? key, required this.typeManga}) : super(key: key);

  @override
  _ListMangaScreenState createState() => _ListMangaScreenState();
}

class _ListMangaScreenState extends State<ListMangaScreen> {
  late ErrorBloc _errorBloc;
  late PopularMangaBloc _popularMangaBloc;
  late ManhuaBloc _manhuaBloc;
  late MangaBloc _mangaBloc;
  late ManhwaBloc _manhwaBloc;
  late TypeManga _typeManga;
  late PagingController<int, PopularManga> _pagingPopularController;
  late PagingController<int, Manga> _pagingManhuaController;
  late PagingController<int, Manga> _pagingMangaController;
  late PagingController<int, Manga> _pagingManhwaController;

  @override
  void initState() {
    // init bloc
    _errorBloc = BlocProvider.of<ErrorBloc>(context);
    _popularMangaBloc = BlocProvider.of<PopularMangaBloc>(context);
    _manhuaBloc = BlocProvider.of<ManhuaBloc>(context);
    _mangaBloc = BlocProvider.of<MangaBloc>(context);
    _manhwaBloc = BlocProvider.of<ManhwaBloc>(context);

    // init paging
    _pagingPopularController = PagingController(firstPageKey: 1);
    _pagingManhuaController = PagingController(firstPageKey: 1);
    _pagingMangaController = PagingController(firstPageKey: 1);
    _pagingManhwaController = PagingController(firstPageKey: 1);

    // re-init error to reset state
    _errorBloc.add(ErrorReInitialization());

    // type manga
    _typeManga = widget.typeManga;

    super.initState();
  }

  @override
  void dispose() {
    _pagingPopularController.dispose();
    _pagingManhuaController.dispose();
    _pagingMangaController.dispose();
    _pagingManhwaController.dispose();

    super.dispose();
  }

  void _profileAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: _buildHeader(),
        ),
        body: _buildListMangaCard(),
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
            child: HeaderProfile(onTap: _profileAction),
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 30.0,
            alignment: Alignment.center,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                CapsuleButton(
                  onPressed: () {
                    setState(() => _typeManga = TypeManga.popular);
                  },
                  label: 'Popular',
                  isSelected: _typeManga == TypeManga.popular,
                ),
                const SizedBox(width: 15.0),
                CapsuleButton(
                  onPressed: () {
                    setState(() => _typeManga = TypeManga.manhua);
                  },
                  label: 'Manhua',
                  isSelected: _typeManga == TypeManga.manhua,
                ),
                const SizedBox(width: 15.0),
                CapsuleButton(
                  onPressed: () {
                    setState(() => _typeManga = TypeManga.manga);
                  },
                  label: 'Manga',
                  isSelected: _typeManga == TypeManga.manga,
                ),
                const SizedBox(width: 15.0),
                CapsuleButton(
                  onPressed: () {
                    setState(() => _typeManga = TypeManga.manhwa);
                  },
                  label: 'Manhwa',
                  isSelected: _typeManga == TypeManga.manhwa,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListMangaCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Stack(
        children: [
          Offstage(
            child: _buildPopularManga(),
            offstage: _typeManga != TypeManga.popular,
          ),
          Offstage(
            child: _buildManhua(),
            offstage: _typeManga != TypeManga.manhua,
          ),
          Offstage(
            child: _buildManga(),
            offstage: _typeManga != TypeManga.manga,
          ),
          Offstage(
            child: _buildManhwa(),
            offstage: _typeManga != TypeManga.manhwa,
          ),
        ],
      ),
    );
  }

  Widget _buildPopularManga() {
    // if type manga selected, then trigger paging to add some item
    // addPageRequestListener
    if (_typeManga == TypeManga.popular &&
        !(_popularMangaBloc.state is PopularMangaFetchSuccess)) {
      _pagingPopularController.notifyListeners();
    }

    _pagingPopularController.addPageRequestListener((pageKey) {
      // to avoid fetch data when building widget although then type of manga not selected
      if (_typeManga == TypeManga.popular) {
        _popularMangaBloc.add(PopularMangaFetch(page: pageKey));
      }
    });

    return BlocListener<PopularMangaBloc, PopularMangaState>(
      listener: (context, state) {
        if (state is PopularMangaFetchSuccess) {
          _pagingPopularController.value = PagingState(
            nextPageKey: state.nextPage,
            itemList: state.listPopular,
          );
        }
      },
      child: PagedListView<int, PopularManga>(
        pagingController: _pagingPopularController,
        physics: BouncingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<PopularManga>(
            itemBuilder: (context, item, index) {
          PopularManga popularManga = item;

          return MangaCard<PopularManga>(manga: popularManga);
        }, newPageProgressIndicatorBuilder: (context) {
          return MangaCard(isLoading: true);
        }, firstPageProgressIndicatorBuilder: (context) {
          return MangaCard(isLoading: true);
        }),
      ),
    );
  }

  Widget _buildManhua() {
    // if type manga selected, then trigger paging to add some item
    // addPageRequestListener
    if (_typeManga == TypeManga.manhua &&
        !(_manhuaBloc.state is ManhuaFetchSuccess)) {
      _pagingManhuaController.notifyListeners();
    }

    _pagingManhuaController.addPageRequestListener((pageKey) {
      // to avoid fetch data when building widget although then type of manga not selected
      if (_typeManga == TypeManga.manhua) {
        _manhuaBloc.add(ManhuaFetch(page: pageKey));
      }
    });

    return BlocListener<ManhuaBloc, ManhuaState>(
      listener: (context, state) {
        if (state is ManhuaFetchSuccess) {
          _pagingManhuaController.value = PagingState(
            nextPageKey: state.nextPage,
            itemList: state.listManhua,
          );
        }
      },
      child: PagedListView<int, Manga>(
        pagingController: _pagingManhuaController,
        physics: BouncingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<Manga>(
            itemBuilder: (context, item, index) {
          Manga manga = item;

          return MangaCard<Manga>(manga: manga);
        }, newPageProgressIndicatorBuilder: (context) {
          return MangaCard(isLoading: true);
        }, firstPageProgressIndicatorBuilder: (context) {
          return MangaCard(isLoading: true);
        }),
      ),
    );
  }

  Widget _buildManga() {
    // if type manga selected, then trigger paging to add some item
    // addPageRequestListener
    if (_typeManga == TypeManga.manga &&
        !(_mangaBloc.state is MangaFetchSuccess)) {
      _pagingMangaController.notifyListeners();
    }

    _pagingMangaController.addPageRequestListener((pageKey) {
      // to avoid fetch data when building widget although then type of manga not selected
      if (_typeManga == TypeManga.manga) {
        _mangaBloc.add(MangaFetch(page: pageKey));
      }
    });

    return BlocListener<MangaBloc, MangaState>(
      listener: (context, state) {
        if (state is MangaFetchSuccess) {
          _pagingMangaController.value = PagingState(
            nextPageKey: state.nextPage,
            itemList: state.listManga,
          );
        }
      },
      child: PagedListView<int, Manga>(
        pagingController: _pagingMangaController,
        physics: BouncingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<Manga>(
            itemBuilder: (context, item, index) {
          Manga manga = item;

          return MangaCard<Manga>(manga: manga);
        }, newPageProgressIndicatorBuilder: (context) {
          return MangaCard(isLoading: true);
        }, firstPageProgressIndicatorBuilder: (context) {
          return MangaCard(isLoading: true);
        }),
      ),
    );
  }

  Widget _buildManhwa() {
    // if type manga selected, then trigger paging to add some item
    // addPageRequestListener
    if (_typeManga == TypeManga.manhwa &&
        !(_manhwaBloc.state is ManhwaFetchSuccess)) {
      _pagingManhwaController.notifyListeners();
    }

    _pagingManhwaController.addPageRequestListener((pageKey) {
      // to avoid fetch data when building widget although then type of manga not selected
      if (_typeManga == TypeManga.manhwa) {
        _manhwaBloc.add(ManhwaFetch(page: pageKey));
      }
    });

    return BlocListener<ManhwaBloc, ManhwaState>(
      listener: (context, state) {
        if (state is ManhwaFetchSuccess) {
          _pagingManhwaController.value = PagingState(
            nextPageKey: state.nextPage,
            itemList: state.listManhwa,
          );
        }
      },
      child: PagedListView<int, Manga>(
        pagingController: _pagingManhwaController,
        physics: BouncingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<Manga>(
            itemBuilder: (context, item, index) {
          Manga manga = item;

          return MangaCard<Manga>(manga: manga);
        }, newPageProgressIndicatorBuilder: (context) {
          return MangaCard(isLoading: true);
        }, firstPageProgressIndicatorBuilder: (context) {
          return MangaCard(isLoading: true);
        }),
      ),
    );
  }
}
