import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/event_states/event_states.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SnackbarBloc _snackbarBloc;
  final FirebaseAuth _firebaseAuth;

  UserBloc(this._snackbarBloc)
      : this._firebaseAuth = FirebaseAuth.instance,
        super(UserUninitialized());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    try {
      if (event is UserFetch) {
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          yield UserFetchSuccess(name: user.displayName!);
        }
      }

      if (event is UserLogin) {
        yield UserLoading();

        UserCredential userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        User? user = userCredential.user;

        if (user != null) {
          yield UserFetchSuccess(name: user.displayName!);
        }
      }

      if (event is UserRegister) {
        yield UserLoading();

        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        User? user = userCredential.user;

        if (user != null) {
          // update name
          await user.updateProfile(displayName: event.name);
        }

        yield UserFetchSuccess(name: event.name);
      }
    } catch (e) {
      print(e);

      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        _snackbarBloc.add(SnackbarShow.custom(true, 'Oops.. User not found'));
      }
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        _snackbarBloc
            .add(SnackbarShow.custom(true, 'Oops.. Email already in use'));
      } else {
        _snackbarBloc.add(SnackbarShow.globalError());
      }

      yield UserError();
    }
  }

  Future<void> userLogout() async {
    await _firebaseAuth.signOut();
  }
}
