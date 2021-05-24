import 'package:manga_nih/helpers/helpers.dart';

class SearchManga {
  final String title;
  final String type;
  final String typeImage;
  final String thumb;
  final String endpoint;
  final String uploadOn;

  SearchManga({
    required this.title,
    required this.type,
    required this.typeImage,
    required this.thumb,
    required this.endpoint,
    required this.uploadOn,
  });

  static List<SearchManga> toList(dynamic json) {
    List<SearchManga> listManga = [];

    for (var data in json) {
      listManga.add(SearchManga(
        title: data['title'],
        type: data['type'],
        typeImage: typeMangaImage(data['type']),
        thumb: cleanThumb(data['thumb']),
        endpoint: data['endpoint'],
        uploadOn: data['updated_on'],
      ));
    }

    return listManga;
  }
}
