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

  // static List<HistoryManga> toList(List<dynamic> values) {
  //   List<HistoryManga> list = [];

  //   for (var data in values) {
  //     list.add(HistoryManga(
  //       title: data['title'],
  //       type: data['type'],
  //       thumb: data['thumb'],
  //       endpoint: data['endpoint'],
  //       lastChapter: Chapter(
  //         title: data['lastChapter']['title'],
  //         endpoint: data['lastChapter']['endpoint'],
  //       ),
  //     ));
  //   }

  //   return list;
  // }
}
