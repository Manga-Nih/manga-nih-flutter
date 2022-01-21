import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/ui/screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SnackbarBloc _snackbarBloc = SnackbarBloc();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<SnackbarBloc>(create: (_) => _snackbarBloc),
        BlocProvider<UserBloc>(create: (_) => UserBloc(_snackbarBloc)),
        BlocProvider<PopularMangaBloc>(
            create: (_) => PopularMangaBloc(_snackbarBloc)),
        BlocProvider<LatestMangaBloc>(
            create: (_) => LatestMangaBloc(_snackbarBloc)),
        BlocProvider<GenreBloc>(create: (_) => GenreBloc(_snackbarBloc)),
        BlocProvider<ManhuaBloc>(create: (_) => ManhuaBloc(_snackbarBloc)),
        BlocProvider<MangaBloc>(create: (_) => MangaBloc(_snackbarBloc)),
        BlocProvider<ManhwaBloc>(create: (_) => ManhwaBloc(_snackbarBloc)),
        BlocProvider<GenreMangaBloc>(
            create: (_) => GenreMangaBloc(_snackbarBloc)),
        BlocProvider<DetailMangaBloc>(
            create: (_) => DetailMangaBloc(_snackbarBloc)),
        BlocProvider<ChapterImageBloc>(
            create: (_) => ChapterImageBloc(_snackbarBloc)),
        BlocProvider<SearchMangaBloc>(
            create: (_) => SearchMangaBloc(_snackbarBloc)),
        BlocProvider<FavoriteMangaBloc>(
            create: (_) => FavoriteMangaBloc(_snackbarBloc)),
        BlocProvider<HistoryMangaBloc>(
            create: (_) => HistoryMangaBloc(_snackbarBloc)),
      ],
      child: GetMaterialApp(
        title: 'Manga nih',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
