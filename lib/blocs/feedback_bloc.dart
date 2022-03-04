import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FeedbackBloc()
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        super(FeedbackUninitialized()) {
    on(_onFeedbackSubmit);
  }

  Future<void> _onFeedbackSubmit(
      FeedbackSubmit event, Emitter<FeedbackState> emit) async {
    try {
      emit(FeedbackLoading());

      User user = _firebaseAuth.currentUser!;
      CollectionReference ref = _firestore.collection(user.uid);
      DocumentReference doc = ref.doc('feedback');
      DocumentSnapshot snapshot = await doc.get();
      List data = (snapshot.data() as Map<String, dynamic>?)?['data'] ?? [];

      data.add(event.feedback.toMap());
      doc.set({'data': data});

      emit(FeedbackSubmitSuccess());
    } catch (e) {
      emit(FeedbackError());

      log(e.toString(), name: 'FeedbackSubmit');

      SnackbarModel.globalError();
    }
  }
}
