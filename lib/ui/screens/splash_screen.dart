import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseAuth _firebaseAuth;
  late SnackbarBloc _snackbarBloc;
  late UserBloc _userBloc;
  late bool _initialized;

  @override
  void initState() {
    // init bloc
    _snackbarBloc = BlocProvider.of<SnackbarBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    // init state for firebase
    _initialized = false;

    // init firebase
    _initializeFirebase();

    super.initState();
  }

  void _initializeFirebase() async {
    try {
      await Firebase.initializeApp();

      // init firebase
      _firebaseAuth = FirebaseAuth.instance;
      _userBloc.add(UserInitialized(firebaseAuth: _firebaseAuth));

      // sleep for 2 seconds
      await Future.delayed(Duration(seconds: 2));

      setState(() => _initialized = true);
    } catch (e) {
      print(e);
      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return SafeArea(
        child: Scaffold(
          body: BlocListener<SnackbarBloc, SnackbarState>(
            listener: (context, state) {
              if (state is SnackbarShowing) {
                showSnackbar(context, state.snackbar.message);
              }
            },
            child: Center(
              child: Text('Manga nih'),
            ),
          ),
        ),
      );
    }

    if (_firebaseAuth.currentUser != null) {
      _userBloc.add(UserFetch());
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}