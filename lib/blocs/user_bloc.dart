import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _firebaseAuth;

  UserBloc()
      : this._firebaseAuth = FirebaseAuth.instance,
        super(UserUninitialized()) {
    on(_onUserFetch);
    on(_onUserUpdateProfile);
    on(_onUserLogin);
    on(_onUserRegister);

    // if login
    if (_firebaseAuth.currentUser != null) {
      this.add(UserFetch());
    }
  }

  Future<void> _onUserFetch(UserFetch event, Emitter<UserState> emit) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(UserFetchSuccess(user: user));
      }
    } catch (e) {
      emit(UserError());

      log(e.toString(), name: 'UserFetch');

      SnackbarModel.globalError();
    }
  }

  Future<void> _onUserUpdateProfile(
      UserUpdateProfile event, Emitter<UserState> emit) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(event.name);
        await user.reload();

        User updatedUser = _firebaseAuth.currentUser!;

        emit(UserFetchSuccess(user: updatedUser));
      }
    } catch (e) {
      emit(UserError());

      log(e.toString(), name: 'UserUpdateProfile');

      SnackbarModel.globalError();
    }
  }

  Future<void> _onUserLogin(UserLogin event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());

      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        emit(UserFetchSuccess(user: user));
      }
    } on FirebaseAuthException catch (e) {
      emit(UserError());

      log(e.toString(), name: 'UserLogin - FirebaseAuthException');

      if (e.code == 'user-not-found') {
        SnackbarModel.custom(true, 'Oops.. User not found');
      }

      if (e.code == 'wrong-password') {
        SnackbarModel.custom(true, 'Oops.. Wrong password');
      }
    } catch (e) {
      emit(UserError());

      log(e.toString(), name: 'UserLogin');

      SnackbarModel.globalError();
    }
  }

  Future<void> _onUserRegister(
      UserRegister event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());

      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // update name
        await user.updateDisplayName(event.name);
        await user.reload();

        User updatedUser = _firebaseAuth.currentUser!;

        emit(UserFetchSuccess(user: updatedUser));
      }
    } on FirebaseAuthException catch (e) {
      emit(UserError());

      log(e.toString(), name: 'UserRegister - FirebaseAuthException');

      if (e.code == 'email-already-in-use') {
        SnackbarModel.custom(true, 'Oops.. Email already in use');
      }
    } catch (e) {
      emit(UserError());

      log(e.toString(), name: 'UserRegister');

      SnackbarModel.globalError();
    }
  }

  Future<void> userLogout() async {
    await _firebaseAuth.signOut();
  }
}
