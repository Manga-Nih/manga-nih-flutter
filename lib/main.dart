import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/ui/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ErrorBloc _errorBloc = ErrorBloc();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<ErrorBloc>(create: (_) => _errorBloc),
        BlocProvider<PopularMangaBloc>(
            create: (_) => PopularMangaBloc(_errorBloc)),
        BlocProvider<RecommendedMangaBloc>(
            create: (_) => RecommendedMangaBloc(_errorBloc)),
        BlocProvider<GenreBloc>(create: (_) => GenreBloc(_errorBloc)),
        BlocProvider<ManhuaBloc>(create: (_) => ManhuaBloc(_errorBloc)),
        BlocProvider<MangaBloc>(create: (_) => MangaBloc(_errorBloc)),
        BlocProvider<ManhwaBloc>(create: (_) => ManhwaBloc(_errorBloc)),
      ],
      child: MaterialApp(
        title: 'Manga nih',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.grey,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
