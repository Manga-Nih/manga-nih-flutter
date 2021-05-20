import 'package:manga_nih/helpers/helpers.dart';

class RecommendedManga {
  final String title;
  final String thumb;
  final String endpoint;

  RecommendedManga({
    required this.title,
    required this.thumb,
    required this.endpoint,
  });

  static List<RecommendedManga> toList(dynamic json) {
    List<RecommendedManga> listRecommended = [];

    for (var data in json) {
      listRecommended.add(RecommendedManga(
        title: data['title'],
        thumb: cleanThumb(data['thumb']),
        endpoint: data['endpoint'],
      ));
    }

    return listRecommended;
  }
}
