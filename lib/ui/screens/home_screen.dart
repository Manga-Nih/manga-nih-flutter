import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PopularMangaBloc _popularMangaBloc;
  late RecommendedMangaBloc _recommendedMangaBloc;
  late GenreBloc _genreBloc;

  @override
  void initState() {
    // init bloc
    _popularMangaBloc = BlocProvider.of<PopularMangaBloc>(context);
    _recommendedMangaBloc = BlocProvider.of<RecommendedMangaBloc>(context);
    _genreBloc = BlocProvider.of<GenreBloc>(context);

    // fetch popular manga
    _popularMangaBloc.add(PopularMangaFetch());
    // fetch recommended manga
    _recommendedMangaBloc.add(RecommendedMangaFetch());
    // fetch genre
    _genreBloc.add(GenreFetch());

    super.initState();
  }

  void _profileAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  void _searchAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchScreen()));
  }

  void _recommendedMangaItemAction(RecommendedManga manga) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailMangaScreen(mangaEndpoint: manga.endpoint),
        ));
  }

  void _popularMangaItemAction(PopularManga popularManga) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailMangaScreen(mangaEndpoint: popularManga.endpoint),
        ));
  }

  void _popularMangaAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMangaScreen(typeManga: TypeManga.popular),
        ));
  }

  void _manhuaAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMangaScreen(typeManga: TypeManga.manhua),
        ));
  }

  void _mangaAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMangaScreen(typeManga: TypeManga.manga),
        ));
  }

  void _manhwaAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMangaScreen(typeManga: TypeManga.manhwa),
        ));
  }

  void _genreAction(Genre genre) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListGenreManga(genre: genre),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<SnackbarBloc, SnackbarState>(
          listener: (context, state) {
            if (state is SnackbarShowing) {
              showSnackbar(
                context,
                state.snackbar.message,
                isError: state.snackbar.isError,
              );
            }
          },
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _buildHeader(),
              _buildRecommendedManga(),
              _buildPopularManga(),
              _buildFooter(),
            ],
          ),
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
            HeaderProfile(onTap: _profileAction),
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

  Widget _buildRecommendedManga() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200.0,
        margin: const EdgeInsets.only(top: 10.0),
        child: BlocBuilder<RecommendedMangaBloc, RecommendedMangaState>(
          builder: (context, state) {
            return Swiper(
              itemCount: (state is RecommendedMangaFetchSuccess)
                  ? state.listRecommended.length
                  : 1,
              physics: (state is RecommendedMangaFetchSuccess)
                  ? null
                  : NeverScrollableScrollPhysics(),
              viewportFraction: 0.8,
              scale: 0.9,
              itemBuilder: (context, index) {
                if (state is RecommendedMangaFetchSuccess) {
                  RecommendedManga recommendedManga =
                      state.listRecommended[index];

                  return RecommendedMangaCard(
                    recommendedManga: recommendedManga,
                    onTap: _recommendedMangaItemAction,
                  );
                }

                return RecommendedMangaCard.loading();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopularManga() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Manga',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                MaterialButton(
                  child: Icon(Icons.more_horiz),
                  onPressed: _popularMangaAction,
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                ),
              ],
            ),
            Container(
              height: 200.0,
              child: BlocBuilder<PopularMangaBloc, PopularMangaState>(
                builder: (context, state) {
                  if (state is PopularMangaFetchSuccess) {
                    return ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        PopularManga popularManga = state.listPopular[index];

                        return MangaItem(
                          popularManga: popularManga,
                          onTap: _popularMangaItemAction,
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
      ),
    );
  }

  Widget _buildFooter() {
    final Size screenSize = MediaQuery.of(context).size;

    return SliverFillRemaining(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: screenSize.height,
          margin: const EdgeInsets.only(top: 20.0),
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 50.0,
                height: 6.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              const SizedBox(height: 5.0),
              _buildRegionFlag(),
              const SizedBox(height: 10.0),
              Expanded(
                child: BlocBuilder<GenreBloc, GenreState>(
                  builder: (context, state) {
                    return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 50.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: (3 / 1),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: (state is GenreFetchSuccess)
                          ? state.listGenre.length
                          : 9,
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
            ],
          ),
          // child: ListView(
          //   shrinkWrap: true,
          //   // physics: NeverScrollableScrollPhysics(),
          //   children: [
          //     Container(
          //       width: 50.0,
          //       height: 6.0,
          //       decoration: BoxDecoration(
          //         color: Colors.grey.shade400,
          //         borderRadius: BorderRadius.circular(50.0),
          //       ),
          //     ),
          //     const SizedBox(height: 5.0),
          //     _buildRegionFlag(),
          //     const SizedBox(height: 10.0),
          //     BlocBuilder<GenreBloc, GenreState>(
          //       builder: (context, state) {
          //         return GridView.builder(
          //           physics: BouncingScrollPhysics(),
          //           padding: const EdgeInsets.only(
          //               left: 10.0, right: 10.0, bottom: 10.0),
          //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //             crossAxisCount: 3,
          //             childAspectRatio: (3 / 1),
          //             crossAxisSpacing: 10.0,
          //             mainAxisSpacing: 10.0,
          //           ),
          //           itemCount: (state is GenreFetchSuccess)
          //               ? state.listGenre.length
          //               : 9,
          //           itemBuilder: (context, index) {
          //             if (state is GenreFetchSuccess) {
          //               Genre genre = state.listGenre[index];
          //               return GenreButton(
          //                 genre: genre,
          //                 onPressed: _genreAction,
          //               );
          //             }

          //             return GenreButton.loading();
          //           },
          //         );
          //       },
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _buildRegionFlag() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
    );
  }
}
