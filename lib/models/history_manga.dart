import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/core/core.dart';

class HistoryManga {
  final String title;
  final String type;
  final String typeImage;
  final String thumb;
  final String endpoint;
  final Chapter lastChapter;

  HistoryManga({
    required this.title,
    required this.type,
    required this.thumb,
    required this.endpoint,
    required this.lastChapter,
  }) : typeImage = typeMangaImage(type);

  factory HistoryManga.fromJson(Map<String, dynamic> map) {
    return HistoryManga(
      title: map['title'],
      type: map['type'],
      thumb: map['thumb'],
      endpoint: map['endpoint'],
      lastChapter:
          Chapter.fromJsonFirst(Map<String, String>.from(map['lastChapter'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'typeImage': typeImage,
      'thumb': thumb,
      'endpoint': endpoint,
      'lastChapter': lastChapter.toJson()
    };
  }
}
