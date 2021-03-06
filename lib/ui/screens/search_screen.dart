import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchMangaBloc _searchMangaBloc;

  @override
  void initState() {
    // init bloc
    _searchMangaBloc = BlocProvider.of<SearchMangaBloc>(context);

    super.initState();
  }

  void _searchAction(String value) {
    _searchMangaBloc.add(SearchMangaFetch(keyword: value));
  }

  void _mangaCardAction(Manga searchManga) {
    Get.to(() => DetailMangaScreen(mangaEndpoint: searchManga.detailEndpoint));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(),
            _buildListManga(),
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
            const HeaderProfile(),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: TextFormField(
                onFieldSubmitted: _searchAction,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.filter_list),
                  hintText: 'Search manga...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 15.0),
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListManga() {
    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: BlocBuilder<SearchMangaBloc, SearchMangaState>(
        builder: (context, state) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (state is SearchMangaFetchSuccess) {
                  Manga searchManga = state.listSearchManga[index];

                  return MangaCard(
                    manga: searchManga,
                    onTap: _mangaCardAction,
                  );
                }

                if (state is SearchMangaUninitialized) {
                  return const SizedBox.shrink();
                }

                return const MangaCard.loading();
              },
              childCount: (state is SearchMangaFetchSuccess)
                  ? state.listSearchManga.length
                  : 1,
            ),
          );
        },
      ),
    );
  }
}
