import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserInitialized extends UserEvent {
  final FirebaseAuth firebaseAuth;

  const UserInitialized({required this.firebaseAuth});

  @override
  List<Object?> get props => [firebaseAuth];
}

class UserFetch extends UserEvent {}

class UserUpdateProfile extends UserEvent {
  final String name;
  final File? image;

  const UserUpdateProfile({required this.name, required this.image});

  @override
  List<Object?> get props => [name, image];
}

class UserLogin extends UserEvent {
  final String email;
  final String password;

  const UserLogin({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class UserRegister extends UserEvent {
  final String name;
  final String email;
  final String password;

  const UserRegister({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
