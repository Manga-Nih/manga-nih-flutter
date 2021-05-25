import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  UserState();
}

class UserUninitialized extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserError extends UserState {
  @override
  List<Object?> get props => [];
}

class UserFetchSuccess extends UserState {
  final String name;

  UserFetchSuccess({required this.name});

  @override
  List<Object?> get props => [name];
}
