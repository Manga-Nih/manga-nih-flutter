import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class ChapterScreen extends StatefulWidget {
  final Chapter chapter;

  const ChapterScreen({Key? key, required this.chapter}) : super(key: key);

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  late DetailMangaBloc _detailMangaBloc;
  late ChapterImageBloc _chapterImageBloc;
  late HistoryMangaBloc _historyMangaBloc;
  late ScrollController _scrollController;
  late TransformationController _transformationController;
  late int _curIndexChapter;
  late List<Chapter> _listChapter;
  late bool _isVisible;
  late bool _isHasPrev;
  late bool _isHasNext;
  late bool _isZoomed;

  @override
  void initState() {
    // init blocs
    _detailMangaBloc = BlocProvider.of<DetailMangaBloc>(context);
    _chapterImageBloc = BlocProvider.of<ChapterImageBloc>(context);
    _historyMangaBloc = BlocProvider.of<HistoryMangaBloc>(context);

    // init controller
    _scrollController = ScrollController();
    _transformationController = TransformationController();

    // set
    _isVisible = true;
    _isZoomed = false;
    _isHasNext = false;
    _isHasPrev = false;

    // check if has previous or next chapter
    DetailMangaState state = _detailMangaBloc.state;
    if (state is DetailMangaFetchSuccess) {
      int length = state.detailManga.listChapter.length;
      _listChapter = state.detailManga.listChapter;
      _curIndexChapter =
          _listChapter.indexWhere((element) => element == widget.chapter);

      // manage is manga has previous/next chapter
      if (_curIndexChapter != 0) _isHasNext = true;
      if (_curIndexChapter != (length - 1)) _isHasPrev = true;

      // store last chapter
      HistoryManga historyManga = HistoryManga(
        title: state.detailManga.title,
        type: state.detailManga.type,
        thumb: state.detailManga.thumb,
        endpoint: state.detailManga.endpoint,
        lastChapter: widget.chapter,
      );
      _historyMangaBloc.add(HistoryMangaAdd(historyManga: historyManga));
    }

    // avoid to fetch data again with same chapter
    ChapterImageState chapterImageState = _chapterImageBloc.state;
    if (chapterImageState is ChapterImageFetchSuccess) {
      if (chapterImageState.chapterImage.endpoint != widget.chapter.endpoint) {
        // fetch data image
        _chapterImageBloc
            .add(ChapterImageFetch(endpoint: widget.chapter.endpoint));
      }
    } else {
      // fetch data image
      _chapterImageBloc
          .add(ChapterImageFetch(endpoint: widget.chapter.endpoint));
    }

    // set controller to handle visibility app bar and bottom bar
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() => _isVisible = false);
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() => _isVisible = true);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _transformationController.dispose();

    super.dispose();
  }

  void _prevAction() {
    int prevIndex = _curIndexChapter + 1;
    Chapter prevChapter = _listChapter[prevIndex];
    _chapterImageBloc.add(ChapterImageFetch(endpoint: prevChapter.endpoint));
  }

  void _nextAction() {
    int nextIndex = _curIndexChapter - 1;
    Chapter nextChapter = _listChapter[nextIndex];
    _chapterImageBloc.add(ChapterImageFetch(endpoint: nextChapter.endpoint));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<ChapterImageBloc, ChapterImageState>(
              builder: (context, state) {
                return GestureDetector(
                  onDoubleTap: () {},
                  onDoubleTapDown: (details) {
                    double x = -1 * details.globalPosition.dx;
                    double y = -1 * details.globalPosition.dy;

                    if (_isZoomed) {
                      Matrix4 matrix = Matrix4.identity().scaled(1.0, 1.0, 1.0);
                      _transformationController.value = matrix;
                      _isZoomed = false;
                    } else {
                      // scale x and y to 2.0 base on maxScale InteractiveViewer
                      Matrix4 matrix = Matrix4.identity().scaled(2.0, 2.0, 1.0);
                      // multiply 0.5 to get x and y value before scaled
                      matrix.translate(x * 0.5, y * 0.5);
                      _transformationController.value = matrix;
                      _isZoomed = true;
                    }
                  },
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.5,
                    maxScale: 2,
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.white,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: (state is ChapterImageFetchSuccess)
                            ? state.chapterImage.listImage.length
                            : 1,
                        itemBuilder: (context, index) {
                          if (state is ChapterImageFetchSuccess) {
                            List<String> urls = state.chapterImage.listImage;
                            return CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: urls[index],
                              placeholder: (context, url) => Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: CircularProgressIndicator(),
                                  )
                                ],
                              ),
                            );
                          }

                          return Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: _isVisible ? 60.0 : 0.0,
                child: Container(
                  color: Colors.white60,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      widget.chapter.title,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: _isVisible ? 60.0 : 0.0,
                child: Container(
                  color: Colors.white60,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isHasPrev
                          ? BlocBuilder<ChapterImageBloc, ChapterImageState>(
                              builder: (context, state) {
                                return MaterialButton(
                                  onPressed: (state is ChapterImageFetchSuccess)
                                      ? _prevAction
                                      : () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.chevron_left),
                                      const SizedBox(width: 3.0),
                                      Text(
                                        'Previous',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : SizedBox.shrink(),
                      _isHasNext
                          ? BlocBuilder<ChapterImageBloc, ChapterImageState>(
                              builder: (context, state) {
                                return MaterialButton(
                                  onPressed: (state is ChapterImageFetchSuccess)
                                      ? _nextAction
                                      : () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        'Next',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      const SizedBox(width: 3.0),
                                      Icon(Icons.chevron_right),
                                    ],
                                  ),
                                );
                              },
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
