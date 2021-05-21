import 'package:equatable/equatable.dart';

abstract class ManhuaEvent extends Equatable {
  ManhuaEvent();
}

class ManhuaFetch extends ManhuaEvent {
  final int page;

  ManhuaFetch({required this.page});

  @override
  List<Object?> get props => [page];
}
