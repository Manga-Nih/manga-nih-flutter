import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';

class FavoriteMangaBloc extends Bloc<FavoriteMangaEvent, FavoriteMangaState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FavoriteMangaBloc()
      : this._firebaseAuth = FirebaseAuth.instance,
        this._firestore = FirebaseFirestore.instance,
        super(FavoriteMangaUninitialized());

  @override
  Stream<FavoriteMangaState> mapEventToState(FavoriteMangaEvent event) async* {
    try {
      if (event is FavoriteMangaAddRemove) {
        DocumentReference doc = _favoritesDoc;
        DocumentSnapshot snapshot = await doc.get();
        List data = (snapshot.data() as Map<String, dynamic>)['data'] ?? [];

        MangaDetail detail = event.favoriteManga;
        FavoriteManga favoriteManga = FavoriteManga(
          title: detail.title,
          type: detail.typeName,
          thumb: detail.thumb,
          endpoint: detail.endpoint,
        );

        bool isExist = data.firstWhere(
              (element) => element['endpoint'] == event.favoriteManga.endpoint,
              orElse: () => null,
            ) !=
            null;

        if (isExist) {
          // delete
          data.removeWhere(
              (element) => element['endpoint'] == event.favoriteManga.endpoint);

          doc.update({'data': data});
        } else {
          data.add(favoriteManga.toJson());
          doc.set({'data': data});
        }

        this.add(FavoriteMangaFetchList());
      }

      if (event is FavoriteMangaFetchList) {
        DocumentReference doc = _favoritesDoc;
        DocumentSnapshot snapshot = await doc.get();
        List data = (snapshot.data() as Map<String, dynamic>?)?['data'] ?? [];

        List<FavoriteManga> favorites = data
            .map((e) => FavoriteManga.fromJson(Map<String, String>.from(e)))
            .toList();

        List<FavoriteManga> reverse = favorites.reversed.toList();

        yield FavoriteMangaFetchListSuccess(listFavoriteManga: reverse);
      }
    } catch (e) {
      log(e.toString(), name: 'FavoriteMangaAddRemove');

      SnackbarModel.globalError();
    }
  }

  DocumentReference get _favoritesDoc {
    User user = _firebaseAuth.currentUser!;
    CollectionReference ref = _firestore.collection(user.uid);
    return ref.doc('favorites');
  }
}
