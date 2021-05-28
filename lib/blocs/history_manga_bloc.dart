import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class HistoryMangaBloc extends Bloc<HistoryMangaEvent, HistoryMangaState> {
  final SnackbarBloc _snackbarBloc;
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseAuth _firebaseAuth;

  HistoryMangaBloc(this._snackbarBloc)
      : this._firebaseAuth = FirebaseAuth.instance,
        this._firebaseDatabase = FirebaseDatabase.instance,
        super(HistoryMangaUninitialized());

  @override
  Stream<HistoryMangaState> mapEventToState(HistoryMangaEvent event) async* {
    try {
      if (event is HistoryMangaAdd) {
        // get child by value
        DataSnapshot data = await _historiesReference
            .orderByChild('endpoint')
            .equalTo(event.historyManga.endpoint)
            .once();

        // if don't exist
        if (data.value == null) {
          await _historiesReference.push().set({
            "title": event.historyManga.title,
            "type": event.historyManga.type,
            "typeImage": event.historyManga.typeImage,
            "thumb": event.historyManga.thumb,
            "endpoint": event.historyManga.endpoint,
            "lastChapter": {
              "title": event.historyManga.lastChapter.title,
              "endpoint": event.historyManga.lastChapter.endpoint,
            }
          });
        } else {
          // get key from list item
          Map<dynamic, dynamic> map = data.value;
          String key = map.keys.first;

          // update last chapter
          await _historiesReference.child(key).child('lastChapter').update({
            "title": event.historyManga.lastChapter.title,
            "endpoint": event.historyManga.lastChapter.endpoint,
          });
        }

        this.add(HistoryMangaFetchList());
      }

      if (event is HistoryMangaFetchList) {
        DataSnapshot dataSnapshot = await _historiesReference.once();
        List<HistoryManga> list = [];
        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> map = dataSnapshot.value;
          list = HistoryManga.toList(map.values.toList());
        }

        yield HistoryMangaFetchListSuccess(listHistoryManga: list);
      }
    } catch (e) {
      print(e);
      _snackbarBloc.add(SnackbarShow.globalError());
    }
  }

  DatabaseReference get _historiesReference {
    DatabaseReference databaseReference = _firebaseDatabase.reference();
    User user = _firebaseAuth.currentUser!;
    DatabaseReference favorites =
        databaseReference.child(user.uid).child('histories');

    return favorites;
  }
}
