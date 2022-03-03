import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/core/core.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    // init firebase
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    // set persistance
    _firestore.settings = Settings(persistenceEnabled: true);

    super.initState();
  }

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
        title: Constants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.balsamiqSansTextTheme(),
        ),
        home: Builder(
          builder: (context) {
            return (_firebaseAuth.currentUser == null)
                ? LoginScreen()
                : HomeScreen();
          },
        ),
      ),
    );
  }
}
