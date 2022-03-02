import 'package:manga_nih/core/core.dart';

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

  static List<FavoriteManga> fromJson(List<Map<String, String>> values) {
    List<FavoriteManga> list = [];

    for (Map<String, String> data in values) {
      list.add(FavoriteManga(
        title: data['title']!,
        type: data['type']!,
        thumb: data['thumb']!,
        endpoint: data['endpoint']!,
      ));
    }

    return list;
  }

  Map<String, String> toJson() {
    return {
      'title': title,
      'type': type,
      'thumb': thumb,
      'endpoint': endpoint,
    };
  }
}
