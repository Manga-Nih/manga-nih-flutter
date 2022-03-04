import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserUninitialized extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {}

class UserFetchSuccess extends UserState {
  final User user;

  const UserFetchSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}
