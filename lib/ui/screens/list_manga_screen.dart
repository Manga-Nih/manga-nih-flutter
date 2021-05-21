import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();

    // init bloc
    _errorBloc = BlocProvider.of<ErrorBloc>(context);
    _popularMangaBloc = BlocProvider.of<PopularMangaBloc>(context);
    _manhuaBloc = BlocProvider.of<ManhuaBloc>(context);
    _mangaBloc = BlocProvider.of<MangaBloc>(context);
    _manhwaBloc = BlocProvider.of<ManhwaBloc>(context);

    // re-init error to reset state
    _errorBloc.add(ErrorReInitialization());

    // type manga
    _typeManga = widget.typeManga;
  }

  void _profileAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<ErrorBloc, ErrorState>(
          listener: (context, state) {
            if (state is ErrorShowing) {
              showSnackbar(context, state.error.message);
            }
          },
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: _buildHeader(),
                ),
              ];
            },
            body: _buildListMangaCard(),
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
            Container(
              height: 30.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  CapsuleButton(
                    onPressed: () {
                      setState(() => _typeManga = TypeManga.popular);
                    },
                    label: 'Popular',
                  ),
                  const SizedBox(width: 15.0),
                  CapsuleButton(
                    onPressed: () {
                      setState(() => _typeManga = TypeManga.manhua);
                    },
                    label: 'Manhua',
                  ),
                  const SizedBox(width: 15.0),
                  CapsuleButton(
                    onPressed: () {
                      setState(() => _typeManga = TypeManga.manga);
                    },
                    label: 'Manga',
                  ),
                  const SizedBox(width: 15.0),
                  CapsuleButton(
                    onPressed: () {
                      setState(() => _typeManga = TypeManga.manhwa);
                    },
                    label: 'Manhwa',
                  ),
                ],
              ),
            ),
          ],
        ),
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
    // check if manga already fetch or not
    if (_typeManga == TypeManga.popular &&
        !(_popularMangaBloc.state is PopularMangaFetchSuccess)) {
      _popularMangaBloc.add(PopularMangaFetch());
    }

    return BlocBuilder<PopularMangaBloc, PopularMangaState>(
      builder: (context, state) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (state is PopularMangaFetchSuccess) {
              PopularManga popularManga = state.listPopular[index];

              return MangaCard<PopularManga>(manga: popularManga);
            }

            return MangaCard(isLoading: true);
          },
          itemCount: (state is PopularMangaFetchSuccess)
              ? state.listPopular.length
              : 4,
        );
      },
    );
  }

  Widget _buildManhua() {
    // check if manga already fetch or not
    if (_typeManga == TypeManga.manhua &&
        !(_manhuaBloc.state is ManhuaFetchSuccess)) {
      _manhuaBloc.add(ManhuaFetch());
    }

    return BlocBuilder<ManhuaBloc, ManhuaState>(
      builder: (context, state) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (state is ManhuaFetchSuccess) {
              Manga manga = state.listManhua[index];

              return MangaCard<Manga>(manga: manga);
            }

            return MangaCard(isLoading: true);
          },
          itemCount:
              (state is ManhuaFetchSuccess) ? state.listManhua.length : 4,
        );
      },
    );
  }

  Widget _buildManga() {
    // check if manga already fetch or not
    if (_typeManga == TypeManga.manga &&
        !(_mangaBloc.state is MangaFetchSuccess)) {
      _mangaBloc.add(MangaFetch());
    }

    return BlocBuilder<MangaBloc, MangaState>(
      builder: (context, state) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (state is MangaFetchSuccess) {
              Manga manga = state.listManga[index];

              return MangaCard<Manga>(manga: manga);
            }

            return MangaCard(isLoading: true);
          },
          itemCount: (state is MangaFetchSuccess) ? state.listManga.length : 4,
        );
      },
    );
  }

  Widget _buildManhwa() {
    // check if manga already fetch or not
    if (_typeManga == TypeManga.manhwa &&
        !(_manhwaBloc.state is ManhwaFetchSuccess)) {
      _manhwaBloc.add(ManhwaFetch());
    }
    return BlocBuilder<ManhwaBloc, ManhwaState>(
      builder: (context, state) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (state is ManhwaFetchSuccess) {
              Manga manga = state.listManhwa[index];

              return MangaCard<Manga>(manga: manga);
            }

            return MangaCard(isLoading: true);
          },
          itemCount:
              (state is ManhwaFetchSuccess) ? state.listManhwa.length : 4,
        );
      },
    );
  }
}
