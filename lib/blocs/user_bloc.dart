import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SnackbarBloc _snackbarBloc;
  final FirebaseAuth _firebaseAuth;

  UserBloc(this._snackbarBloc)
      : this._firebaseAuth = FirebaseAuth.instance,
        super(UserUninitialized()) {
    // if login
    if (_firebaseAuth.currentUser != null) {
      this.add(UserFetch());
    }
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    try {
      if (event is UserFetch) {
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          yield UserFetchSuccess(user: user);
        }
      }

      if (event is UserUpdateProfile) {
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          await user.updateProfile(displayName: event.name);

          yield UserFetchSuccess(user: user);
        }
      }

      if (event is UserLogin) {
        yield UserLoading();

        UserCredential userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        User? user = userCredential.user;

        if (user != null) {
          yield UserFetchSuccess(user: user);
        }
      }

      if (event is UserRegister) {
        yield UserLoading();

        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        User? user = userCredential.user;

        if (user != null) {
          // update name
          await user.updateProfile(displayName: event.name);

          yield UserFetchSuccess(user: user);
        }
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString(), name: 'UserBloc - FirebaseAuthException');

      if (e.code == 'user-not-found') {
        _snackbarBloc.add(SnackbarShow.custom(true, 'Oops.. User not found'));
      }
      if (e.code == 'email-already-in-use') {
        _snackbarBloc
            .add(SnackbarShow.custom(true, 'Oops.. Email already in use'));
      }
      if (e.code == 'wrong-password') {
        _snackbarBloc.add(SnackbarShow.custom(true, 'Oops.. Wrong password'));
      }

      yield UserError();
    } catch (e) {
      log(e.toString(), name: 'UserBloc');

      _snackbarBloc.add(SnackbarShow.globalError());

      yield UserError();
    }
  }

  Future<void> userLogout() async {
    await _firebaseAuth.signOut();
  }
}
