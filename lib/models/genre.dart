import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final String name;
  final String endpoint;

  Genre({
    required this.name,
    required this.endpoint,
  });

  static List<Genre> toList(dynamic json) {
    List<Genre> listGenre = [];

    for (var data in json) {
      listGenre.add(Genre(
        name: data['genre_name'],
        endpoint: data['endpoint'],
      ));
    }

    return listGenre;
  }

  @override
  List<Object?> get props => [name, endpoint];
}
