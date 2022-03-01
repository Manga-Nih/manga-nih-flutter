import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/constants/word.dart';
import 'package:manga_nih/ui/screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        BlocProvider<UserBloc>(create: (_) => UserBloc()),
        BlocProvider<PopularMangaBloc>(create: (_) => PopularMangaBloc()),
        BlocProvider<LatestMangaBloc>(create: (_) => LatestMangaBloc()),
        BlocProvider<GenreBloc>(create: (_) => GenreBloc()),
        BlocProvider<ManhuaBloc>(create: (_) => ManhuaBloc()),
        BlocProvider<MangaBloc>(create: (_) => MangaBloc()),
        BlocProvider<ManhwaBloc>(create: (_) => ManhwaBloc()),
        BlocProvider<GenreMangaBloc>(create: (_) => GenreMangaBloc()),
        BlocProvider<DetailMangaBloc>(create: (_) => DetailMangaBloc()),
        BlocProvider<ChapterImageBloc>(create: (_) => ChapterImageBloc()),
        BlocProvider<SearchMangaBloc>(create: (_) => SearchMangaBloc()),
        BlocProvider<FavoriteMangaBloc>(create: (_) => FavoriteMangaBloc()),
        BlocProvider<HistoryMangaBloc>(create: (_) => HistoryMangaBloc()),
      ],
      child: GetMaterialApp(
        title: Word.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.balsamiqSansTextTheme(),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
