import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:komiku_sdk/enum.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PopularMangaBloc _popularMangaBloc;
  late LatestMangaBloc _latestMangaBloc;
  late GenreBloc _genreBloc;

  @override
  void initState() {
    // init bloc
    _popularMangaBloc = BlocProvider.of<PopularMangaBloc>(context);
    _latestMangaBloc = BlocProvider.of<LatestMangaBloc>(context);
    _genreBloc = BlocProvider.of<GenreBloc>(context);

    // fetch popular manga
    _popularMangaBloc.add(PopularMangaFetch());
    // fetch latest manga
    _latestMangaBloc.add(LatestMangaFetch());
    // fetch genre
    _genreBloc.add(GenreFetch());

    super.initState();
  }

  void _searchAction() {
    Get.to(() => SearchScreen());
  }

  void _popularLatestMangaItemAction(dynamic manga) {
    Get.to(() => DetailMangaScreen(mangaEndpoint: manga.detailEndpoint));
  }

  void _manhuaAction() {
    Get.to(() => ListMangaScreen(mangaType: MangaType.manhua));
  }

  void _mangaAction() {
    Get.to(() => ListMangaScreen(mangaType: MangaType.manga));
  }

  void _manhwaAction() {
    Get.to(() => ListMangaScreen(mangaType: MangaType.manhwa));
  }

  void _genreAction(Genre genre) {
    Get.to(() => ListGenreManga(genre: genre));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            _buildHeader(),
            _buildPopularManga(),
            _buildLatestManga(),
            _buildRegionFlag(),
            _buildGenre(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            HeaderProfile(),
            const SizedBox(height: 20.0),
            MaterialButton(
              onPressed: _searchAction,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: Colors.grey.shade200,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade700),
                  const SizedBox(width: 10.0),
                  Text(
                    'Search manga...',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey.shade700),
                  ),
                  const Spacer(),
                  Icon(Icons.filter_list, color: Colors.grey.shade700),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularManga() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
            child: Text(
              'Popular Manga',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            height: 200.0,
            child: BlocBuilder<PopularMangaBloc, PopularMangaState>(
              builder: (context, state) {
                if (state is PopularMangaFetchSuccess) {
                  return ListView.builder(
                    itemCount: state.listPopular.length,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      PopularManga popularManga = state.listPopular[index];

                      return MangaItem<PopularManga>(
                        popularLatestManga: popularManga,
                        onTap: _popularLatestMangaItemAction,
                      );
                    },
                  );
                }

                return ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MangaItem.loading();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestManga() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 20.0),
            child: Text(
              'Latest Manga',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            height: 200.0,
            child: BlocBuilder<LatestMangaBloc, LatestMangaState>(
              builder: (context, state) {
                if (state is LatestMangaFetchSuccess) {
                  return ListView.builder(
                    itemCount: state.listLatest.length,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      LatestManga latestManga = state.listLatest[index];

                      return MangaItem<LatestManga>(
                        popularLatestManga: latestManga,
                        onTap: _popularLatestMangaItemAction,
                      );
                    },
                  );
                }

                return ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MangaItem.loading();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionFlag() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegionFlag(
              pathFlag: 'images/china_flag.png',
              label: 'Manhua',
              onTap: _manhuaAction,
            ),
            RegionFlag(
              pathFlag: 'images/japan_flag.png',
              label: 'Manga',
              onTap: _mangaAction,
            ),
            RegionFlag(
              pathFlag: 'images/korea_flag.png',
              label: 'Manhwa',
              onTap: _manhwaAction,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenre() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      sliver: SliverToBoxAdapter(
        child: BlocBuilder<GenreBloc, GenreState>(
          builder: (context, state) {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (3 / 1),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount:
                  (state is GenreFetchSuccess) ? state.listGenre.length : 9,
              itemBuilder: (context, index) {
                if (state is GenreFetchSuccess) {
                  Genre genre = state.listGenre[index];
                  return GenreButton(
                    genre: genre,
                    onPressed: _genreAction,
                  );
                }

                return GenreButton.loading();
              },
            );
          },
        ),
      ),
    );
  }
}
