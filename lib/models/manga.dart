import 'package:manga_nih/helpers/helpers.dart';

class Manga {
  final String title;
  final String type;
  final String typeImage;
  final String thumb;
  final String endpoint;
  final String uploadOn;
  final String chapter;

  Manga({
    required this.title,
    required this.type,
    required this.typeImage,
    required this.thumb,
    required this.endpoint,
    required this.uploadOn,
    required this.chapter,
  });

  static List<Manga> toList(dynamic json) {
    List<Manga> listManga = [];

    for (var data in json) {
      listManga.add(Manga(
        title: data['title'],
        type: data['type'],
        typeImage: typeMangaImage(data['type']),
        thumb: cleanThumb(data['thumb']),
        endpoint: data['endpoint'],
        uploadOn: 'Update ' + data['updated_on'] + ' lalu',
        chapter: data['chapter'],
      ));
    }

    return listManga;
  }
}
