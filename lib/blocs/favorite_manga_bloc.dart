import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class FavoriteMangaBloc extends Bloc<FavoriteMangaEvent, FavoriteMangaState> {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseAuth _firebaseAuth;

  FavoriteMangaBloc()
      : this._firebaseAuth = FirebaseAuth.instance,
        this._firebaseDatabase = FirebaseDatabase.instance,
        super(FavoriteMangaUninitialized());

  @override
  Stream<FavoriteMangaState> mapEventToState(FavoriteMangaEvent event) async* {
    try {
      if (event is FavoriteMangaAddRemove) {
        // get child by value
        DatabaseEvent databaseEvent = await _favoritesReference
            .orderByChild('endpoint')
            .equalTo(event.favoriteManga.endpoint)
            .once();
        DataSnapshot data = databaseEvent.snapshot;

        MangaDetail detail = event.favoriteManga;
        FavoriteManga favoriteManga = FavoriteManga(
          title: detail.title,
          type: detail.typeName,
          thumb: detail.thumb,
          endpoint: detail.endpoint,
        );

        // if don't exist
        if (data.value == null) {
          await _favoritesReference.push().set(favoriteManga.toJson());
        } else {
          // get key from list item
          Map<dynamic, dynamic> map = data.value as Map<dynamic, dynamic>;
          String key = map.keys.first;
          await _favoritesReference.child(key).remove();
        }

        this.add(FavoriteMangaFetchList());
      }

      if (event is FavoriteMangaFetchList) {
        DatabaseEvent databaseEvent = await _favoritesReference.once();
        DataSnapshot dataSnapshot = databaseEvent.snapshot;
        List<FavoriteManga> list = [];

        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> map =
              dataSnapshot.value as Map<dynamic, dynamic>;
          List<Map<String, String>> values =
              map.values.map((e) => Map<String, String>.from(e)).toList();
          list = FavoriteManga.fromJson(values);
        }

        yield FavoriteMangaFetchListSuccess(listFavoriteManga: list);
      }
    } catch (e) {
      log(e.toString(), name: 'FavoriteMangaAddRemove');

      SnackbarModel.globalError();
    }
  }

  DatabaseReference get _favoritesReference {
    DatabaseReference databaseReference = _firebaseDatabase.reference();
    User user = _firebaseAuth.currentUser!;
    DatabaseReference favorites =
        databaseReference.child(user.uid).child('favorites');

    return favorites;
  }
}
