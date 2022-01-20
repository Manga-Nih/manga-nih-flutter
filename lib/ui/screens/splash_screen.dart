import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseAuth _firebaseAuth;
  late FirebaseDatabase _firebaseDatabase;
  late SnackbarBloc _snackbarBloc;
  late bool _initialized;

  @override
  void initState() {
    // init bloc
    _snackbarBloc = BlocProvider.of<SnackbarBloc>(context);

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
      _firebaseDatabase = FirebaseDatabase.instance;

      // set persistance
      await _firebaseDatabase.setPersistenceEnabled(true);

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
    return SafeArea(
      child: Scaffold(
        body: BlocListener<SnackbarBloc, SnackbarState>(
          listener: (context, state) {
            if (state is SnackbarShowing) {
              showSnackbar(
                context,
                state.snackbar.message,
                isError: state.snackbar.isError,
              );
            }
          },
          child: _buildChild(),
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (!_initialized) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Text('Manga nih'),
          ),
        ),
      );
    }

    return (_firebaseAuth.currentUser == null) ? LoginScreen() : HomeScreen();
  }
}
