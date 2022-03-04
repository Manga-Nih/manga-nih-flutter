import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class HistoryMangaBloc extends Bloc<HistoryMangaEvent, HistoryMangaState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  HistoryMangaBloc()
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        super(HistoryMangaUninitialized()) {
    on(_onHistoryMangaAdd);
    on(_onHistoryMangaClear);
    on(_onHistoryMangaFetchList);
  }

  Future<void> _onHistoryMangaAdd(
      HistoryMangaAdd event, Emitter<HistoryMangaState> emit) async {
    try {
      DocumentReference doc = _historiesDoc;
      DocumentSnapshot snapshot = await doc.get();
      List data = (snapshot.data() as Map<String, dynamic>?)?['data'] ?? [];

      HistoryManga history = event.historyManga;
      bool isExist = data.firstWhere(
            (element) => element['endpoint'] == event.historyManga.endpoint,
            orElse: () => null,
          ) !=
          null;

      if (isExist) {
        // update last chapter
        Map<String, dynamic> curData = data.firstWhere(
            (element) => element['endpoint'] == event.historyManga.endpoint);

        curData['lastChapter'] = history.lastChapter.toJson();

        doc.update({'data': data});
      } else {
        data.add(history.toJson());
        doc.set({'data': data});
      }

      add(HistoryMangaFetchList());
    } catch (e) {
      emit(HistoryMangaError());

      log(e.toString(), name: 'HistoryMangaAdd');

      SnackbarModel.globalError();
    }
  }

  Future<void> _onHistoryMangaClear(
      HistoryMangaClear event, Emitter<HistoryMangaState> emit) async {
    try {
      DocumentReference doc = _historiesDoc;
      await doc.delete();

      add(HistoryMangaFetchList());
    } catch (e) {
      emit(HistoryMangaError());

      log(e.toString(), name: 'HistoryMangaClear');

      SnackbarModel.globalError();
    }
  }

  Future<void> _onHistoryMangaFetchList(
      HistoryMangaFetchList event, Emitter<HistoryMangaState> emit) async {
    try {
      DocumentReference doc = _historiesDoc;
      DocumentSnapshot snapshot = await doc.get();
      List data = (snapshot.data() as Map<String, dynamic>?)?['data'] ?? [];

      List<HistoryManga> histories = data
          .map((e) => HistoryManga.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      List<HistoryManga> reverse = histories.reversed.toList();

      emit(HistoryMangaFetchListSuccess(listHistoryManga: reverse));
    } catch (e) {
      emit(HistoryMangaError());

      log(e.toString(), name: 'HistoryMangaFetchList');

      SnackbarModel.globalError();
    }
  }

  DocumentReference get _historiesDoc {
    User user = _firebaseAuth.currentUser!;
    CollectionReference ref = _firestore.collection(user.uid);
    return ref.doc('histories');
  }
}
