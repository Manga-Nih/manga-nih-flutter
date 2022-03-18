import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/core/constants.dart';
import 'package:manga_nih/models/models.dart';

class EmailVerificationCubit extends Cubit<UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser!;

  EmailVerificationCubit() : super(UserUninitialized()) {
    if (user.emailVerified) {
      emit(UserEmailVerified());
    } else {
      emit(UserEmailNotVerified());
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      emit(UserLoading());

      Uri uri = Uri.https(Constants.webDomain, '', {
        'time': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      await user.sendEmailVerification(
        ActionCodeSettings(
          url: uri.toString(),
          androidPackageName: Constants.androidPackage,
          dynamicLinkDomain: Constants.dynamicLink,
          handleCodeInApp: true,
          androidInstallApp: true,
          iOSBundleId: Constants.iosPackage,
        ),
      );

      emit(UserVerificationEmailSent());
    } on FirebaseAuthException catch (e) {
      log(e.toString(), name: 'EmailVerification - sendEmailVerification');

      if (e.code == 'too-many-requests') {
        SnackbarModel.custom(true, 'Terlalu banyak request, coba lagi nanti');
      } else if (e.code == 'unknown') {
        SnackbarModel.globalError();
      }

      emit(UserError());
    } catch (e) {
      log(e.toString(), name: 'EmailVerification - sendEmailVerification');

      SnackbarModel.globalError();

      emit(UserError());
    }
  }

  Future<void> verifyCode(String code) async {
    try {
      emit(UserLoading());

      await _firebaseAuth.applyActionCode(code);

      // reload user
      await user.reload();
      user = _firebaseAuth.currentUser!;

      emit(UserEmailVerified());
    } on FirebaseException catch (e) {
      log(e.toString(), name: 'EmailVerification - verifyCode');

      if (e.code == 'invalid-action-code') {
        SnackbarModel.custom(
            true, 'Invalid code, please resend verification email');
      }

      emit(UserError());
    } catch (e) {
      log(e.toString(), name: 'EmailVerification - verifyCode');

      SnackbarModel.globalError();

      emit(UserError());
    }
  }
}
