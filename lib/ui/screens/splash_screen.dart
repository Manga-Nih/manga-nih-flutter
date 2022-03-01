import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:manga_nih/constants/word.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/screens/screens.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseAuth _firebaseAuth;
  late FirebaseDatabase _firebaseDatabase;
  late bool _initialized;

  @override
  void initState() {
    // init state for firebase
    _initialized = false;

    // init firebase
    _initializeFirebase();

    super.initState();
  }

  void _initializeFirebase() async {
    try {
      // init firebase
      _firebaseAuth = FirebaseAuth.instance;
      _firebaseDatabase = FirebaseDatabase.instance;

      // set persistance
      _firebaseDatabase.setPersistenceEnabled(true);

      // sleep for 2 seconds
      await Future.delayed(Duration(seconds: 2));

      setState(() => _initialized = true);
    } catch (e) {
      log(e.toString(), name: 'FirebaseError');

      SnackbarModel.globalError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (!_initialized) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Text(Word.appName),
          ),
        ),
      );
    }

    return (_firebaseAuth.currentUser == null) ? LoginScreen() : HomeScreen();
  }
}
