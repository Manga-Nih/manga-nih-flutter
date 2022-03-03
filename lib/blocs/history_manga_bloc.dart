import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class HistoryMangaBloc extends Bloc<HistoryMangaEvent, HistoryMangaState> {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseAuth _firebaseAuth;

  HistoryMangaBloc()
      : this._firebaseAuth = FirebaseAuth.instance,
        this._firebaseDatabase = FirebaseDatabase.instance,
        super(HistoryMangaUninitialized());

  @override
  Stream<HistoryMangaState> mapEventToState(HistoryMangaEvent event) async* {
    try {
      if (event is HistoryMangaAdd) {
        // get child by value
        DatabaseEvent databaseEvent = await _historiesReference
            .orderByChild('endpoint')
            .equalTo(event.historyManga.endpoint)
            .once();
        DataSnapshot data = databaseEvent.snapshot;
        HistoryManga history = event.historyManga;

        // if don't exist
        if (data.value == null) {
          await _historiesReference.push().set(history.toJson());
        } else {
          // get key from list item
          Map<dynamic, dynamic> map = data.value as Map<dynamic, dynamic>;
          String key = map.keys.first;

          // update last chapter
          await _historiesReference
              .child(key)
              .child('lastChapter')
              .update(history.lastChapter.toJson());
        }

        this.add(HistoryMangaFetchList());
      }

      if (event is HistoryMangaClear) {
        try {
          DatabaseReference ref = _historiesReference;
          await ref.remove();

          this.add(HistoryMangaFetchList());
        } catch (e) {
          log(e.toString(), name: 'HistoryMangaClear');

          SnackbarModel.globalError();
        }
      }

      if (event is HistoryMangaFetchList) {
        DatabaseEvent databaseEvent = await _historiesReference.once();
        DataSnapshot dataSnapshot = databaseEvent.snapshot;
        List<HistoryManga> list = [];

        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> map =
              dataSnapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> values =
              map.values.map((e) => Map<String, dynamic>.from(e)).toList();

          list = HistoryManga.fromJson(values);
        }

        yield HistoryMangaFetchListSuccess(listHistoryManga: list);
      }
    } catch (e) {
      log(e.toString(), name: 'HistoryMangaAdd');

      SnackbarModel.globalError();
    }
  }

  DatabaseReference get _historiesReference {
    DatabaseReference databaseReference = _firebaseDatabase.ref();
    User user = _firebaseAuth.currentUser!;
    return databaseReference.child(user.uid).child('histories');
  }
}
