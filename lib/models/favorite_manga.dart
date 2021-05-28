import 'package:manga_nih/helpers/helpers.dart';

class FavoriteManga {
  final String title;
  final String type;
  final String typeImage;
  final String thumb;
  final String endpoint;

  FavoriteManga({
    required this.title,
    required this.type,
    required this.thumb,
    required this.endpoint,
  }) : this.typeImage = typeMangaImage(type);

  static List<FavoriteManga> toList(List<dynamic> values) {
    List<FavoriteManga> list = [];

    for (var data in values) {
      list.add(FavoriteManga(
        title: data['title'],
        type: data['type'],
        thumb: data['thumb'],
        endpoint: data['endpoint'],
      ));
    }

    return list;
  }
}
