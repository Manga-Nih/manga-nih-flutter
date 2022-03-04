import 'package:equatable/equatable.dart';

abstract class ManhwaEvent extends Equatable {
  const ManhwaEvent();

  @override
  List<Object?> get props => [];
}

class ManhwaFetch extends ManhwaEvent {
  final int page;

  const ManhwaFetch({required this.page});

  @override
  List<Object?> get props => [page];
}
