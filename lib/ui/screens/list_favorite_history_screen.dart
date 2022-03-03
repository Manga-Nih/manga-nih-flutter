import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/core/core.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class ListFavoriteHistoryScreen extends StatefulWidget {
  final FavoriteHistorySection section;

  const ListFavoriteHistoryScreen({Key? key, required this.section})
      : super(key: key);

  @override
  _ListFavoriteHistoryScreenState createState() =>
      _ListFavoriteHistoryScreenState();
}

class _ListFavoriteHistoryScreenState extends State<ListFavoriteHistoryScreen> {
  late FavoriteMangaBloc _favoriteMangaBloc;
  late HistoryMangaBloc _historyMangaBloc;
  late FavoriteHistorySection _section;
  late List<FavoriteManga>? _listFavoriteManga;
  late List<HistoryManga>? _listHistoryManga;

  @override
  void initState() {
    // init bloc
    _favoriteMangaBloc = BlocProvider.of<FavoriteMangaBloc>(context);
    _historyMangaBloc = BlocProvider.of<HistoryMangaBloc>(context);

    // init list
    _listFavoriteManga = null;
    _listHistoryManga = null;

    // set section
    _section = widget.section;

    // fetch data
    _fetchData();

    super.initState();
  }

  void _detailMangaAction(FavoriteManga favoriteManga) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailMangaScreen(mangaEndpoint: favoriteManga.endpoint),
        ));
  }

  void _chapterAction(HistoryManga historyManga) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterScreen.fromListFavoriteHistoryManga(
            chapter: historyManga.lastChapter,
            mangaEndpoint: historyManga.endpoint,
          ),
        ));
  }

  void _fetchData() {
    if (_section == FavoriteHistorySection.favorite) {
      _favoriteMangaBloc.add(FavoriteMangaFetchList());
    }

    if (_section == FavoriteHistorySection.history) {
      _historyMangaBloc.add(HistoryMangaFetchList());
    }
  }

  void _clearHistoryAction() {
    showDialog(
      context: context,
      builder: (context) {
        return ClearHistoryDialog(
          onAccept: () {
            _historyMangaBloc.add(HistoryMangaClear());

            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: _buildHeader(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Stack(
            children: [
              Offstage(
                offstage: _section != FavoriteHistorySection.favorite,
                child: _buildFavoriteSection(),
              ),
              Offstage(
                offstage: _section != FavoriteHistorySection.history,
                child: _buildHistorySection(),
              ),
            ],
          ),
        ),
        floatingActionButton: AnimatedScale(
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticInOut,
          scale: _section == FavoriteHistorySection.history ? 1 : 0,
          child: FloatingActionButton(
            onPressed: _clearHistoryAction,
            backgroundColor: Colors.red,
            child: Icon(Icons.delete),
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
                    setState(() {
                      _section = FavoriteHistorySection.favorite;
                      _fetchData();
                    });
                  },
                  label: 'Favorite',
                  isSelected: _section == FavoriteHistorySection.favorite,
                ),
                const SizedBox(width: 15.0),
                CapsuleButton(
                  onPressed: () {
                    setState(() {
                      _section = FavoriteHistorySection.history;
                      _fetchData();
                    });
                  },
                  label: 'History',
                  isSelected: _section == FavoriteHistorySection.history,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteSection() {
    return BlocListener<FavoriteMangaBloc, FavoriteMangaState>(
      listener: (context, state) {
        if (state is FavoriteMangaFetchListSuccess) {
          setState(() => _listFavoriteManga = state.listFavoriteManga);
        }
      },
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (_listFavoriteManga != null) {
            return MangaCard<FavoriteManga>(
              manga: _listFavoriteManga![index],
              onTap: _detailMangaAction,
            );
          } else {
            return MangaCard.loading();
          }
        },
        itemCount:
            (_listFavoriteManga != null) ? _listFavoriteManga!.length : 1,
      ),
    );
  }

  Widget _buildHistorySection() {
    return BlocListener<HistoryMangaBloc, HistoryMangaState>(
      listener: (context, state) {
        if (state is HistoryMangaFetchListSuccess) {
          setState(() => _listHistoryManga = state.listHistoryManga);
        }
      },
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (_listHistoryManga != null) {
            return MangaCard<HistoryManga>(
              manga: _listHistoryManga![index],
              onTap: _chapterAction,
            );
          } else {
            return MangaCard.loading();
          }
        },
        itemCount: (_listHistoryManga != null) ? _listHistoryManga!.length : 1,
      ),
    );
  }
}
