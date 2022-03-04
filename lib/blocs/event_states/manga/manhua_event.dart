import 'package:equatable/equatable.dart';

abstract class ManhuaEvent extends Equatable {
  const ManhuaEvent();

  @override
  List<Object?> get props => [];
}

class ManhuaFetch extends ManhuaEvent {
  final int page;

  const ManhuaFetch({required this.page});

  @override
  List<Object?> get props => [page];
}
