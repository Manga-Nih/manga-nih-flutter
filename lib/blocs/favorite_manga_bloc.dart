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
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        super(FavoriteMangaUninitialized()) {
    on(_onFavoriteMangaAddRemove);
    on(_onFavoriteMangaFetchList);
  }

  Future<void> _onFavoriteMangaAddRemove(
      FavoriteMangaAddRemove event, Emitter<FavoriteMangaState> emit) async {
    try {
      DocumentReference doc = _favoritesDoc;
      DocumentSnapshot snapshot = await doc.get();
      List data = (snapshot.data() as Map<String, dynamic>?)?['data'] ?? [];

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

      add(FavoriteMangaFetchList());
    } catch (e) {
      emit(FavoriteMangaError());

      log(e.toString(), name: 'FavoriteMangaAddRemove');

      SnackbarModel.globalError();
    }
  }

  Future<void> _onFavoriteMangaFetchList(
      FavoriteMangaFetchList event, Emitter<FavoriteMangaState> emit) async {
    try {
      DocumentReference doc = _favoritesDoc;
      DocumentSnapshot snapshot = await doc.get();
      List data = (snapshot.data() as Map<String, dynamic>?)?['data'] ?? [];

      List<FavoriteManga> favorites = data
          .map((e) => FavoriteManga.fromJson(Map<String, String>.from(e)))
          .toList();

      List<FavoriteManga> reverse = favorites.reversed.toList();

      emit(FavoriteMangaFetchListSuccess(listFavoriteManga: reverse));
    } catch (e) {
      emit(FavoriteMangaError());

      log(e.toString(), name: 'FavoriteMangaFetchList');

      SnackbarModel.globalError();
    }
  }

  DocumentReference get _favoritesDoc {
    User user = _firebaseAuth.currentUser!;
    CollectionReference ref = _firestore.collection(user.uid);
    return ref.doc('favorites');
  }
}
