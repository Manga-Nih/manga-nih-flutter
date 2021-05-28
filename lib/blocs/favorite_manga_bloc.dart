import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/helpers/helpers.dart';
import 'package:manga_nih/models/models.dart';

class FavoriteMangaBloc extends Bloc<FavoriteMangaEvent, FavoriteMangaState> {
  final SnackbarBloc _snackbarBloc;
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseAuth _firebaseAuth;

  FavoriteMangaBloc(this._snackbarBloc)
      : this._firebaseAuth = FirebaseAuth.instance,
        this._firebaseDatabase = FirebaseDatabase.instance,
        super(FavoriteMangaUninitialized());

  @override
  Stream<FavoriteMangaState> mapEventToState(FavoriteMangaEvent event) async* {
    try {
      if (event is FavoriteMangaFetch) {
        // get child by value
        DataSnapshot data = await _favoritesReference
            .orderByChild('endpoint')
            .equalTo(removeSlash(event.endpoint))
            .once();

        if (data.value == null) {
          yield FavoriteMangaNotExist();
        } else {
          yield FavoriteMangaExist();
        }
      }

      if (event is FavoriteMangaAddRemove) {
        // get child by value
        DataSnapshot data = await _favoritesReference
            .orderByChild('endpoint')
            .equalTo(event.favoriteManga.endpoint)
            .once();

        // if don't exist
        if (data.value == null) {
          await _favoritesReference.push().set({
            "title": event.favoriteManga.title,
            "endpoint": event.favoriteManga.endpoint,
            "type": event.favoriteManga.type,
            "typeImage": event.favoriteManga.typeImage,
            "thumb": event.favoriteManga.thumb,
          });

          yield FavoriteMangaExist();
        } else {
          // get key from list item
          Map<dynamic, dynamic> map = data.value;
          String key = map.keys.first;
          await _favoritesReference.child(key).remove();

          yield FavoriteMangaNotExist();
        }
      }

      if (event is FavoriteMangaFetchList) {
        DataSnapshot dataSnapshot = await _favoritesReference.once();
        List<FavoriteManga> list = [];
        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> map = dataSnapshot.value;
          list = FavoriteManga.toList(map.values.toList());
        }

        yield FavoriteMangaFetchListSuccess(listFavoriteManga: list);
      }
    } catch (e) {
      print(e);
      _snackbarBloc.add(SnackbarShow.globalError());
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
