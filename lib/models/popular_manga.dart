import 'package:manga_nih/helpers/helpers.dart';

class PopularManga {
  final String title;
  final String type;
  final String typeImage;
  final String thumb;
  final String endpoint;
  final String uploadOn;

  PopularManga({
    required this.title,
    required this.type,
    required this.typeImage,
    required this.thumb,
    required this.endpoint,
    required this.uploadOn,
  });

  static List<PopularManga> toList(dynamic json) {
    List<PopularManga> listManga = [];

    for (var data in json) {
      listManga.add(PopularManga(
        title: data['title'],
        type: data['type'],
        typeImage: typeMangaImage(data['type']),
        thumb: cleanThumb(data['thumb']),
        endpoint: data['endpoint'],
        uploadOn: data['upload_on'],
      ));
    }

    return listManga;
  }
}
