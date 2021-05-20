import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:manga_nih/constants/url.dart';
import 'package:manga_nih/models/models.dart';

class Service {
  static Uri _getUrl(String path) => Uri.parse(baseUrl + path);

  static Future<List<PopularManga>> getPopularManga(
      {int pageNumber = 1}) async {
    Uri url = _getUrl('manga/popular/$pageNumber');
    var response = await http.get(url);

    var json = jsonDecode(response.body);
    return PopularManga.toList(json['manga_list']);
  }

  static Future<List<RecommendedManga>> getRecommendedManga() async {
    Uri url = _getUrl('recommended');
    var response = await http.get(url);

    var json = jsonDecode(response.body);
    return RecommendedManga.toList(json['manga_list']);
  }

  static Future<List<Genre>> getGenre() async {
    Uri url = _getUrl('genres');
    var response = await http.get(url);

    var json = jsonDecode(response.body);
    return Genre.toList(json['list_genre']);
  }
}
