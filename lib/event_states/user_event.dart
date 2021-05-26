import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserEvent extends Equatable {
  UserEvent();
}

class UserInitialized extends UserEvent {
  final FirebaseAuth firebaseAuth;

  UserInitialized({required this.firebaseAuth});

  @override
  List<Object?> get props => [firebaseAuth];
}

class UserFetch extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UserUpdateProfile extends UserEvent {
  final String name;

  UserUpdateProfile({required this.name});

  @override
  List<Object?> get props => [name];
}

class UserLogin extends UserEvent {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class UserRegister extends UserEvent {
  final String name;
  final String email;
  final String password;

  UserRegister({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
