import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _firebaseDatabase;

  FeedbackBloc()
      : _firebaseAuth = FirebaseAuth.instance,
        _firebaseDatabase = FirebaseDatabase.instance,
        super(FeedbackUninitialized()) {
    on(_onFeedbackSubmit);
  }

  Future<void> _onFeedbackSubmit(
      FeedbackSubmit event, Emitter<FeedbackState> emit) async {
    try {
      emit(FeedbackLoading());

      User user = _firebaseAuth.currentUser!;
      DatabaseReference ref = _firebaseDatabase.ref('feedback');
      Map<String, dynamic> data =
          Map<String, dynamic>.from(event.feedback.toMap());

      data['user'] = {
        'id': user.uid,
        'name': user.displayName,
        'email': user.email,
      };

      ref.push().set(data);

      emit(FeedbackSubmitSuccess());
    } catch (e) {
      emit(FeedbackError());

      log(e.toString(), name: 'FeedbackSubmit');

      SnackbarModel.globalError();
    }
  }
}
