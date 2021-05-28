import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class FavoriteHistoryScreen extends StatefulWidget {
  final FavoriteHistorySection section;

  const FavoriteHistoryScreen({Key? key, required this.section})
      : super(key: key);

  @override
  _FavoriteHistoryScreenState createState() => _FavoriteHistoryScreenState();
}

class _FavoriteHistoryScreenState extends State<FavoriteHistoryScreen> {
  late FavoriteMangaBloc _favoriteMangaBloc;
  late HistoryMangaBloc _historyMangaBloc;
  late FavoriteHistorySection _section;
  late List<FavoriteManga> _listFavoriteManga;
  late List<HistoryManga> _listHistoryManga;

  @override
  void initState() {
    // init bloc
    _favoriteMangaBloc = BlocProvider.of<FavoriteMangaBloc>(context);
    _historyMangaBloc = BlocProvider.of<HistoryMangaBloc>(context);

    // init list
    _listFavoriteManga = [];
    _listHistoryManga = [];

    // set section
    _section = widget.section;

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
          builder: (context) =>
              ChapterScreen(chapter: historyManga.lastChapter),
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

  @override
  Widget build(BuildContext context) {
    // get list data when capsule button selected
    _fetchData();

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
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
                    setState(() => _section = FavoriteHistorySection.favorite);
                  },
                  label: 'Favorite',
                  isSelected: _section == FavoriteHistorySection.favorite,
                ),
                const SizedBox(width: 15.0),
                CapsuleButton(
                  onPressed: () {
                    setState(() => _section = FavoriteHistorySection.history);
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
        itemBuilder: (context, index) {
          return MangaCard<FavoriteManga>(
            manga: _listFavoriteManga[index],
            onTap: _detailMangaAction,
          );
        },
        itemCount: _listFavoriteManga.length,
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
        itemBuilder: (context, index) {
          return MangaCard<HistoryManga>(
            manga: _listHistoryManga[index],
            onTap: _chapterAction,
          );
        },
        itemCount: _listHistoryManga.length,
      ),
    );
  }
}
