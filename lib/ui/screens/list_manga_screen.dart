import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:komiku_sdk/enum.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class ListMangaScreen extends StatefulWidget {
  final MangaType mangaType;

  const ListMangaScreen({Key? key, required this.mangaType}) : super(key: key);

  @override
  _ListMangaScreenState createState() => _ListMangaScreenState();
}

class _ListMangaScreenState extends State<ListMangaScreen> {
  late ManhuaBloc _manhuaBloc;
  late MangaBloc _mangaBloc;
  late ManhwaBloc _manhwaBloc;
  late MangaType _mangaType;
  late PagingController<int, PopularManga> _pagingPopularController;
  late PagingController<int, Manga> _pagingManhuaController;
  late PagingController<int, Manga> _pagingMangaController;
  late PagingController<int, Manga> _pagingManhwaController;

  @override
  void initState() {
    // init bloc
    _manhuaBloc = BlocProvider.of<ManhuaBloc>(context);
    _mangaBloc = BlocProvider.of<MangaBloc>(context);
    _manhwaBloc = BlocProvider.of<ManhwaBloc>(context);

    // init paging
    _pagingPopularController = PagingController(firstPageKey: 1);
    _pagingManhuaController = PagingController(firstPageKey: 1);
    _pagingMangaController = PagingController(firstPageKey: 1);
    _pagingManhwaController = PagingController(firstPageKey: 1);

    // type manga
    _mangaType = widget.mangaType;

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

  void _mangaAction(Manga manga) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailMangaScreen(mangaEndpoint: manga.detailEndpoint),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: _buildHeader(),
        ),
        body: _buildListMangaCard(),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: HeaderProfile(),
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
                    setState(() => _mangaType = MangaType.manhua);
                  },
                  label: 'Manhua',
                  isSelected: _mangaType == MangaType.manhua,
                ),
                const SizedBox(width: 15.0),
                CapsuleButton(
                  onPressed: () {
                    setState(() => _mangaType = MangaType.manga);
                  },
                  label: 'Manga',
                  isSelected: _mangaType == MangaType.manga,
                ),
                const SizedBox(width: 15.0),
                CapsuleButton(
                  onPressed: () {
                    setState(() => _mangaType = MangaType.manhwa);
                  },
                  label: 'Manhwa',
                  isSelected: _mangaType == MangaType.manhwa,
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
              child: _buildManhua(), offstage: _mangaType != MangaType.manhua),
          Offstage(
            child: _buildManga(),
            offstage: _mangaType != MangaType.manga,
          ),
          Offstage(
            child: _buildManhwa(),
            offstage: _mangaType != MangaType.manhwa,
          ),
        ],
      ),
    );
  }

  Widget _buildManhua() {
    // if type manga selected, then trigger paging to add some item
    // addPageRequestListener
    if (_mangaType == MangaType.manhua &&
        !(_manhuaBloc.state is ManhuaFetchSuccess)) {
      _pagingManhuaController.notifyListeners();
    }

    _pagingManhuaController.addPageRequestListener((pageKey) {
      // to avoid fetch data when building widget although then type of manga not selected
      if (_mangaType == MangaType.manhua) {
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

          return MangaCard(
            manga: manga,
            onTap: _mangaAction,
          );
        }, newPageProgressIndicatorBuilder: (context) {
          return MangaCard.loading();
        }, firstPageProgressIndicatorBuilder: (context) {
          return MangaCard.loading();
        }),
      ),
    );
  }

  Widget _buildManga() {
    // if type manga selected, then trigger paging to add some item
    // addPageRequestListener
    if (_mangaType == MangaType.manga &&
        !(_mangaBloc.state is MangaFetchSuccess)) {
      _pagingMangaController.notifyListeners();
    }

    _pagingMangaController.addPageRequestListener((pageKey) {
      // to avoid fetch data when building widget although then type of manga not selected
      if (_mangaType == MangaType.manga) {
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

          return MangaCard(
            manga: manga,
            onTap: _mangaAction,
          );
        }, newPageProgressIndicatorBuilder: (context) {
          return MangaCard.loading();
        }, firstPageProgressIndicatorBuilder: (context) {
          return MangaCard.loading();
        }),
      ),
    );
  }

  Widget _buildManhwa() {
    // if type manga selected, then trigger paging to add some item
    // addPageRequestListener
    if (_mangaType == MangaType.manhwa &&
        !(_manhwaBloc.state is ManhwaFetchSuccess)) {
      _pagingManhwaController.notifyListeners();
    }

    _pagingManhwaController.addPageRequestListener((pageKey) {
      // to avoid fetch data when building widget although then type of manga not selected
      if (_mangaType == MangaType.manhwa) {
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

          return MangaCard(
            manga: manga,
            onTap: _mangaAction,
          );
        }, newPageProgressIndicatorBuilder: (context) {
          return MangaCard.loading();
        }, firstPageProgressIndicatorBuilder: (context) {
          return MangaCard.loading();
        }),
      ),
    );
  }
}
