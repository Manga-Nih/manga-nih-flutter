import 'package:equatable/equatable.dart';
import 'package:manga_nih/helpers/helpers.dart';

class GenreManga extends Equatable {
  final String title;
  final String type;
  final String typeImage;
  final String thumb;
  final String endpoint;

  GenreManga({
    required this.title,
    required this.type,
    required this.typeImage,
    required this.thumb,
    required this.endpoint,
  });

  static List<GenreManga> toList(dynamic json) {
    List<GenreManga> listManga = [];

    for (var data in json) {
      listManga.add(GenreManga(
        title: data['title'],
        type: data['type'],
        typeImage: typeMangaImage(data['type']),
        thumb: cleanThumb(data['thumb']),
        endpoint: data['endpoint'],
      ));
    }

    return listManga;
  }

  @override
  List<Object?> get props => [title, type, typeImage, thumb, endpoint];
}
