import 'package:equatable/equatable.dart';

abstract class ManhwaEvent extends Equatable {
  ManhwaEvent();
}

class ManhwaFetch extends ManhwaEvent {
  @override
  List<Object?> get props => [];
}
