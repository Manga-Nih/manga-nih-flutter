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

  factory FavoriteManga.fromJson(Map<String, String> map) {
    return FavoriteManga(
      title: map['title']!,
      type: map['type']!,
      thumb: map['thumb']!,
      endpoint: map['endpoint']!,
    );
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
