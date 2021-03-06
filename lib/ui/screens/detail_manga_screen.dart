import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/core/core.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/configs/pallette.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class DetailMangaScreen extends StatefulWidget {
  final String mangaEndpoint;

  const DetailMangaScreen({Key? key, required this.mangaEndpoint})
      : super(key: key);

  @override
  _DetailMangaScreenState createState() => _DetailMangaScreenState();
}

class _DetailMangaScreenState extends State<DetailMangaScreen> {
  late DetailMangaBloc _detailMangaBloc;
  late FavoriteMangaBloc _favoriteMangaBloc;
  late DetailMangaSection _section;
  late bool _isFavorite;

  @override
  void initState() {
    // init bloc
    _detailMangaBloc = BlocProvider.of<DetailMangaBloc>(context);
    _favoriteMangaBloc = BlocProvider.of<FavoriteMangaBloc>(context);

    // set
    _isFavorite = false;

    // avoid to fetch data again with same manga
    DetailMangaState state = _detailMangaBloc.state;
    if (state is DetailMangaFetchSuccess) {
      if (removeSlash(state.mangaDetail.endpoint) !=
          removeSlash(widget.mangaEndpoint)) {
        // fetch data
        _detailMangaBloc.add(DetailMangaFetch(endpoint: widget.mangaEndpoint));
      }
    } else {
      // fetch data
      _detailMangaBloc.add(DetailMangaFetch(endpoint: widget.mangaEndpoint));
    }

    // fetch favorite manga to check is favorite or not
    _favoriteMangaBloc.add(FavoriteMangaFetchList());

    // init section
    _section = DetailMangaSection.information;

    super.initState();
  }

  void _favoriteAction() {
    DetailMangaState detailMangaState = _detailMangaBloc.state;
    if (detailMangaState is DetailMangaFetchSuccess) {
      _favoriteMangaBloc.add(
          FavoriteMangaAddRemove(favoriteManga: detailMangaState.mangaDetail));

      // just reverse
      if (_isFavorite) {
        SnackbarModel.custom(true, 'Removed it from favorite');
      } else {
        SnackbarModel.custom(false, 'Added it to favorite');
      }
    }
  }

  void _favoriteListener(BuildContext context, FavoriteMangaState state) {
    if (state is FavoriteMangaFetchListSuccess) {
      List<FavoriteManga> list = state.listFavoriteManga
          .where((element) =>
              removeSlash(element.endpoint) ==
              removeSlash(widget.mangaEndpoint))
          .toList();

      FavoriteManga? favoriteManga = (list.isNotEmpty) ? list.first : null;
      if (favoriteManga != null) {
        setState(() => _isFavorite = true);
      } else {
        setState(() => _isFavorite = false);
      }
    }
  }

  void _informationSectionAction() {
    setState(() => _section = DetailMangaSection.information);
  }

  void _chapterSectionAction() {
    setState(() => _section = DetailMangaSection.chapter);
  }

  void _chapterAction(Chapter chapter) {
    DetailMangaState state = _detailMangaBloc.state;
    if (state is DetailMangaFetchSuccess) {
      Get.to(() => ChapterScreen.fromDetailManga(
            mangaDetail: state.mangaDetail,
            chapter: chapter,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<FavoriteMangaBloc, FavoriteMangaState>(
          listener: _favoriteListener,
          child: BlocBuilder<DetailMangaBloc, DetailMangaState>(
            builder: (context, state) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildAppBar(),
                  _buildMangaInfo(state),
                  _buildBodyContainer(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return const SliverAppBar(title: Text('Detail Manga'));
  }

  Widget _buildMangaInfo(DetailMangaState state) {
    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (state is DetailMangaFetchSuccess)
                ? DetailMangaCard(mangaDetail: state.mangaDetail)
                : const DetailMangaCard.loading(),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  (state is DetailMangaFetchSuccess)
                      ? Text(
                          state.mangaDetail.title,
                          style: Theme.of(context).textTheme.headline6,
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: double.infinity,
                            height: 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  (state is DetailMangaFetchSuccess)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'by ${state.mangaDetail.writer}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              state.mangaDetail.genre,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: double.infinity,
                            height: 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                  const SizedBox(height: 10.0),
                  (state is DetailMangaFetchSuccess)
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _favoriteAction,
                                borderRadius: BorderRadius.circular(50.0),
                                child: Ink(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Pallette.gradientStartColor,
                                        Pallette.gradientEndColor
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: const [0.5, 0.8],
                                    ),
                                  ),
                                  child: Icon(
                                    _isFavorite
                                        ? Icons.favorite_outline
                                        : Icons.favorite,
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: double.infinity,
                            height: 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContainer(DetailMangaState state) {
    final Size screenSize = MediaQuery.of(context).size;

    return SliverFillRemaining(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.all(20.0),
          height: screenSize.height,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                offset: Offset(0, -2),
              )
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
              const SizedBox(height: 30.0),
              Container(
                width: screenSize.width * 0.7,
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 7.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: _informationSectionAction,
                        color: (_section == DetailMangaSection.information)
                            ? Colors.white
                            : Colors.grey.shade300,
                        elevation: (_section == DetailMangaSection.information)
                            ? 3.0
                            : 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: const Text('Information'),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: MaterialButton(
                        onPressed: _chapterSectionAction,
                        color: (_section == DetailMangaSection.chapter)
                            ? Colors.white
                            : Colors.grey.shade300,
                        elevation: (_section == DetailMangaSection.chapter)
                            ? 3.0
                            : 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: const Text('Chapter'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: Stack(
                  children: [
                    Offstage(
                      offstage: _section != DetailMangaSection.information,
                      child: _buildInformationSection(state),
                    ),
                    Offstage(
                      offstage: _section != DetailMangaSection.chapter,
                      child: _buildChapterSection(state),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInformationSection(DetailMangaState state) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20.0),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            (state is DetailMangaFetchSuccess)
                ? Container(
                    height: 70.0,
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Status',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          state.mangaDetail.status,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 70.0,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
            (state is DetailMangaFetchSuccess)
                ? Container(
                    height: 70.0,
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Available Chapter',
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          state.mangaDetail.chapters.length.toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 70.0,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 20.0),
        (state is DetailMangaFetchSuccess)
            ? Text(
                state.mangaDetail.synopsis,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.justify,
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 30.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildChapterSection(DetailMangaState state) {
    return (state is DetailMangaFetchSuccess)
        ? BlocBuilder<HistoryMangaBloc, HistoryMangaState>(
            builder: (context, historyState) {
              HistoryManga? historyManga;
              if (historyState is HistoryMangaFetchListSuccess) {
                List<HistoryManga> list =
                    historyState.listHistoryManga.where((element) {
                  return element.endpoint == widget.mangaEndpoint;
                }).toList();
                historyManga = (list.isNotEmpty) ? list.first : null;
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 20.0),
                physics: const BouncingScrollPhysics(),
                itemCount: state.mangaDetail.chapters.length,
                itemBuilder: (context, index) {
                  Chapter chapter = state.mangaDetail.chapters[index];
                  bool isLastRead = (historyManga != null)
                      ? historyManga.lastChapter.endpoint == chapter.endpoint
                      : false;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    height: 50.0,
                    child: MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 15.0),
                      onPressed: () => _chapterAction(chapter),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.grey.shade300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              chapter.title,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          (isLastRead)
                              ? Text(
                                  'Last Read',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: Pallette.gradientEndColor),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        : ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.grey.shade300,
                  ),
                ),
              );
            },
          );
  }
}
