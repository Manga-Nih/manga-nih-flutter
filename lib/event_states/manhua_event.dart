import 'package:equatable/equatable.dart';

abstract class ManhuaEvent extends Equatable {
  ManhuaEvent();
}

class ManhuaFetch extends ManhuaEvent {
  @override
  List<Object?> get props => [];
}
