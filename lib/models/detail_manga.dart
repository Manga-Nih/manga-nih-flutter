import 'package:manga_nih/helpers/helpers.dart';
import 'package:manga_nih/models/models.dart';

class DetailManga {
  final String title;
  final String type;
  final String typeImage;
  final String author;
  final String status;
  final String endpoint;
  final String thumb;
  final String genre;
  final String synopsis;
  final List<Chapter> listChapter;

  DetailManga({
    required this.title,
    required this.type,
    required this.typeImage,
    required this.author,
    required this.status,
    required this.endpoint,
    required this.thumb,
    required this.genre,
    required this.synopsis,
    required this.listChapter,
  });

  factory DetailManga.toModel(dynamic json) {
    String genre = (json['genre_list'] as List<dynamic>)
        .map((e) => e['genre_name'])
        .join(', ');

    return DetailManga(
      title: json['title'],
      type: json['type'],
      typeImage: typeMangaImage(json['type']),
      thumb: cleanThumb(json['thumb']),
      status: json['status'],
      author: json['author'],
      endpoint: json['manga_endpoint'],
      synopsis: json['synopsis'],
      genre: genre,
      listChapter: Chapter.toList(json['chapter']),
    );
  }
}
