import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  void _profileAction(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final PopularMangaBloc popularMangaBloc =
        BlocProvider.of<PopularMangaBloc>(context);
    final RecommendedMangaBloc recommendedMangaBloc =
        BlocProvider.of<RecommendedMangaBloc>(context);
    final GenreBloc genreBloc = BlocProvider.of<GenreBloc>(context);

    // fetch popular manga
    popularMangaBloc.add(PopularMangaFetch());
    // fetch recommended manga
    recommendedMangaBloc.add(RecommendedMangaFetch());
    // fetch genre
    genreBloc.add(GenreFetch());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            _buildHeader(context),
            _buildRecommendedManga(),
            _buildPopularManga(context, popularMangaBloc),
            _buildFooter(context, genreBloc),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            HeaderProfile(onPressed: _profileAction),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search manga...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.filter_list),
                  focusColor: Colors.black,
                  contentPadding: const EdgeInsets.only(top: 15.0),
                ),
                style: Theme.of(context).textTheme.bodyText1,
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
                  : 3,
              viewportFraction: 0.8,
              scale: 0.9,
              itemBuilder: (context, index) {
                if (state is RecommendedMangaFetchSuccess) {
                  RecommendedManga recommendedManga =
                      state.listRecommended[index];

                  return RecommendedMangaCard(
                    recommendedManga: recommendedManga,
                    isLoading: false,
                  );
                }

                return RecommendedMangaCard(isLoading: true);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopularManga(
      BuildContext context, PopularMangaBloc popularMangaBloc) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Manga',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                MaterialButton(
                  child: Icon(Icons.more_horiz),
                  onPressed: () {},
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                ),
              ],
            ),
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
                        isLoading: false,
                      );
                    },
                  );
                }

                return ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MangaItem(isLoading: true);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, GenreBloc genreBloc) {
    final Size screenSize = MediaQuery.of(context).size;

    return SliverFillRemaining(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
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
              _buildRegionFlag(context),
              const SizedBox(height: 10.0),
              Container(
                height: screenSize.height,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: BlocBuilder<GenreBloc, GenreState>(
                  builder: (context, state) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: (4 / 1),
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                      ),
                      physics: BouncingScrollPhysics(),
                      itemCount: (state is GenreFetchSuccess)
                          ? state.listGenre.length
                          : 8,
                      itemBuilder: (context, index) {
                        if (state is GenreFetchSuccess) {
                          Genre genre = state.listGenre[index];
                          return GenreButton(genre: genre, isLoading: false);
                        }

                        return GenreButton(isLoading: true);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionFlag(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RegionFlag(
            pathFlag: 'images/china_flag.png',
            label: 'Manhua',
          ),
          RegionFlag(
            pathFlag: 'images/japan_flag.png',
            label: 'Manga',
          ),
          RegionFlag(
            pathFlag: 'images/korea_flag.png',
            label: 'Manhwa',
          ),
        ],
      ),
    );
  }
}
