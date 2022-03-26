import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class ChapterScreen extends StatefulWidget {
  final Chapter chapter;
  final MangaDetail? mangaDetail;
  final String? mangaEndpoint;

  const ChapterScreen.fromDetailManga({
    Key? key,
    required this.chapter,
    required this.mangaDetail,
  })  : mangaEndpoint = null,
        super(key: key);

  const ChapterScreen.fromListFavoriteHistoryManga({
    Key? key,
    required this.chapter,
    required this.mangaEndpoint,
  })  : mangaDetail = null,
        super(key: key);

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final ValueNotifier<bool> _visibleNotifier = ValueNotifier(true);
  final ScrollController _scrollController = ScrollController();
  final TransformationController _transformationController =
      TransformationController();
  late DetailMangaBloc _detailMangaBloc;
  late ChapterImageBloc _chapterImageBloc;
  late HistoryMangaBloc _historyMangaBloc;
  late List<Chapter> _listChapter;
  late MangaDetail? _curManga;
  late Chapter _curChapter;
  late int _curIndexChapter;
  late bool _isHasPrev;
  late bool _isHasNext;
  late bool _isZoomed;

  @override
  void initState() {
    // init blocs
    _detailMangaBloc = BlocProvider.of<DetailMangaBloc>(context);
    _chapterImageBloc = BlocProvider.of<ChapterImageBloc>(context);
    _historyMangaBloc = BlocProvider.of<HistoryMangaBloc>(context);

    // set
    _isZoomed = false;
    _isHasNext = false;
    _isHasPrev = false;
    _curManga = widget.mangaDetail;
    _curChapter = widget.chapter;

    // check if has previous or next chapter
    // if not null from DetailMangaScreen
    // if null from ListFavoriteHistoryScreen
    if (_curManga != null) {
      _isHavePrevNextChapter();
      _addHistory();
    } else {
      // fetch detail manga to get prev and next chapter
      _detailMangaBloc.add(DetailMangaFetch(endpoint: widget.mangaEndpoint!));
    }

    // avoid to fetch data again with same chapter
    ChapterImageState chapterImageState = _chapterImageBloc.state;
    if (chapterImageState is ChapterImageFetchSuccess) {
      if (chapterImageState.chapterDetail.endpoint != _curChapter.endpoint) {
        // fetch data image
        _chapterImageBloc
            .add(ChapterImageFetch(endpoint: _curChapter.endpoint));
      }
    } else {
      // fetch data image
      _chapterImageBloc.add(ChapterImageFetch(endpoint: _curChapter.endpoint));
    }

    // set controller to handle visibility app bar and bottom bar
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _visibleNotifier.value = false;
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _visibleNotifier.value = true;
      }
    });

    _transformationController.addListener(() {
      double scale = _transformationController.value.entry(0, 0);
      _isZoomed = scale != 1.0;
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _transformationController.dispose();

    super.dispose();
  }

  void _isHavePrevNextChapter() {
    int length = _curManga!.chapters.length;
    _listChapter = _curManga!.chapters;
    _curIndexChapter =
        _listChapter.indexWhere((element) => element == _curChapter);

    // reset
    _isHasNext = false;
    _isHasPrev = false;

    // manage is manga has previous/next chapter
    if (_curIndexChapter != 0) _isHasNext = true;
    if (_curIndexChapter != (length - 1)) _isHasPrev = true;
    // to trigger rebuild widget
    setState(() {});
  }

  // if from DetailManga save add to history
  // if from ListFavoriteHistory don't save to history
  void _addHistory() {
    // store last chapter
    HistoryManga historyManga = HistoryManga(
      title: _curManga!.title,
      type: _curManga!.typeName,
      thumb: _curManga!.thumb,
      endpoint: _curManga!.endpoint,
      lastChapter: _curChapter,
    );
    _historyMangaBloc.add(HistoryMangaAdd(historyManga: historyManga));
  }

  void _chapterChangeListener(BuildContext context, ChapterImageState state) {
    // update chapter when prev or next
    if (state is ChapterImageFetchSuccess) {
      // check if _curChapter don't equal, to avoid re build prev and next chapter
      if (_curChapter.endpoint != state.chapterDetail.endpoint) {
        // get title from detail manga list chapter
        Chapter chapter = _curManga!.chapters
            .where(
                (element) => element.endpoint == state.chapterDetail.endpoint)
            .first;

        _curChapter = chapter;
        _isHavePrevNextChapter();
        _addHistory();
      }
    }
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

  void _zoomAction(TapDownDetails details) {
    double x = -1 * details.globalPosition.dx;
    double y = -1 * details.globalPosition.dy;

    if (_isZoomed) {
      Matrix4 matrix = Matrix4.identity().scaled(1.0, 1.0, 1.0);
      _transformationController.value = matrix;
    } else {
      // scale x and y to 2.0 base on maxScale InteractiveViewer
      Matrix4 matrix = Matrix4.identity().scaled(2.0, 2.0, 1.0);
      // multiply 0.5 to get x and y value before scaled
      matrix.translate(x * 0.5, y * 0.5);
      _transformationController.value = matrix;
    }
  }

  void _panAction(PointerMoveEvent mouseEvent) {
    if (_isZoomed) {
      Matrix4 matrix4 = _transformationController.value;
      double screenWidth = MediaQuery.of(context).size.width;
      double newSwipeVal = matrix4.getRow(0).a + mouseEvent.delta.dx;

      // prevent user swipe out of screen
      if (newSwipeVal <= 0 && newSwipeVal >= (screenWidth * -1)) {
        matrix4.setEntry(0, 3, newSwipeVal);

        _transformationController.value = matrix4;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<DetailMangaBloc, DetailMangaState>(
          listener: (context, state) {
            // fetch data if from ListFavoriteHistoryManga
            if (state is DetailMangaFetchSuccess) {
              _curManga = state.mangaDetail;
              _isHavePrevNextChapter();
            }
          },
          child: BlocConsumer<ChapterImageBloc, ChapterImageState>(
            listener: _chapterChangeListener,
            builder: (context, state) {
              return Stack(
                children: [
                  Listener(
                    onPointerMove: _panAction,
                    child: GestureDetector(
                      onDoubleTap: () {},
                      onDoubleTapDown: _zoomAction,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: 0.5,
                        maxScale: 2,
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: Colors.white,
                          child: _buildChapters(state),
                        ),
                      ),
                    ),
                  ),
                  _buildHeader(state),
                  _buildFooter(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChapters(ChapterImageState state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: (state is ChapterImageFetchSuccess)
          ? state.chapterDetail.images.length
          : 1,
      itemBuilder: (context, index) {
        if (state is ChapterImageFetchSuccess) {
          List<ChapterImage> images = state.chapterDetail.images;

          return CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: images[index].image,
            placeholder: (context, url) => Wrap(
              alignment: WrapAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: const CircularProgressIndicator(),
                )
              ],
            ),
          );
        }

        return Wrap(
          alignment: WrapAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  Widget _buildHeader(ChapterImageState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
          valueListenable: _visibleNotifier,
          builder: (context, isVisible, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isVisible ? 60.0 : 0.0,
              child: Container(
                color: Colors.white60,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    (state is ChapterImageFetchSuccess)
                        ? _curChapter.title
                        : '',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildFooter(ChapterImageState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
          valueListenable: _visibleNotifier,
          builder: (context, isVisible, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isVisible ? 60.0 : 0.0,
              child: Container(
                color: Colors.white60,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isHasPrev && (state is ChapterImageFetchSuccess)
                        ? MaterialButton(
                            onPressed: _prevAction,
                            child: Row(
                              children: [
                                const Icon(Icons.chevron_left),
                                const SizedBox(width: 3.0),
                                Text(
                                  'Previous',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    _isHasNext && (state is ChapterImageFetchSuccess)
                        ? MaterialButton(
                            onPressed: _nextAction,
                            child: Row(
                              children: [
                                Text(
                                  'Next',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                const SizedBox(width: 3.0),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
