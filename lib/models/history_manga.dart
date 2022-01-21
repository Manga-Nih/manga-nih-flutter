import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/helpers/helpers.dart';

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
  }) : this.typeImage = typeMangaImage(type);

  static List<HistoryManga> fromJson(List<Map<String, dynamic>> values) {
    List<HistoryManga> list = [];

    for (var data in values) {
      list.add(HistoryManga(
        title: data['title'],
        type: data['type'],
        thumb: data['thumb'],
        endpoint: data['endpoint'],
        lastChapter: Chapter.fromJsonFirst(
            Map<String, String>.from(data['lastChapter'])),
      ));
    }

    return list;
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
