import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/core/core.dart';
import 'package:manga_nih/models/models.dart';

class ForgotPasswordCubit extends Cubit<UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ForgotPasswordCubit() : super(UserUninitialized());

  Future<void> sendForgotPassword(String email) async {
    try {
      emit(UserLoading());

      Uri uri = Uri.https(Constants.webDomain, '', {
        'time': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: uri.toString(),
          androidPackageName: Constants.androidPackage,
          dynamicLinkDomain: Constants.dynamicLink,
          handleCodeInApp: true,
          androidInstallApp: true,
          iOSBundleId: Constants.iosPackage,
        ),
      );

      emit(UserForgotPasswordSend());
    } on FirebaseAuthException catch (e) {
      log(e.toString(), name: 'ForgotPasswordCubit - sendForgotPassword');

      if (e.code == 'user-not-found') {
        SnackbarModel.custom(true, 'User not found, try again');
      }

      emit(UserError());
    } catch (e) {
      log(e.toString(), name: 'ForgotPasswordCubit - sendForgotPassword');

      SnackbarModel.globalError();

      emit(UserError());
    }
  }

  Future<void> verifyCode(String code, String password) async {
    try {
      emit(UserLoading());

      await _firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: password,
      );

      emit(UserForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      log(e.toString(), name: 'ForgotPasswordCubit - verifyCode');

      if (e.code == 'invalid-action-code') {
        SnackbarModel.custom(
            true, 'Invalid code, please resend verification email');
      }

      emit(UserError());
    } catch (e) {
      log(e.toString(), name: 'ForgotPasswordCubit - verifyCode');

      SnackbarModel.globalError();

      emit(UserError());
    }
  }
}
