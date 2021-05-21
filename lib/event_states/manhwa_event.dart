import 'package:equatable/equatable.dart';

abstract class ManhwaEvent extends Equatable {
  ManhwaEvent();
}

class ManhwaFetch extends ManhwaEvent {
  final int page;

  ManhwaFetch({required this.page});

  @override
  List<Object?> get props => [page];
}
