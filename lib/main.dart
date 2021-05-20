import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularMangaBloc>(create: (context) => PopularMangaBloc()),
        BlocProvider<RecommendedMangaBloc>(
            create: (context) => RecommendedMangaBloc()),
        BlocProvider<GenreBloc>(create: (context) => GenreBloc()),
        BlocProvider<ManhuaBloc>(create: (context) => ManhuaBloc()),
        BlocProvider<MangaBloc>(create: (context) => MangaBloc()),
        BlocProvider<ManhwaBloc>(create: (context) => ManhwaBloc()),
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
