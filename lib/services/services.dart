import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:manga_nih/constants/enum.dart';
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

  static Future<List<Manga>> getManga(TypeManga typeManga,
      {int pageNumber: 1}) async {
    String? temp;
    if (typeManga == TypeManga.manga) temp = 'manga/page/$pageNumber';
    if (typeManga == TypeManga.manhua) temp = '/manhua/$pageNumber';
    if (typeManga == TypeManga.manhwa) temp = '/manhwa/$pageNumber';

    Uri url = _getUrl(temp!);
    var response = await http.get(url);

    var json = jsonDecode(response.body);
    return Manga.toList(json['manga_list']);
  }

  static Future<List<GenreManga>> getGenreManga(Genre genre,
      {int pageNumber: 1}) async {
    Uri url = _getUrl('genres/${genre.endpoint}/$pageNumber');
    var response = await http.get(url);

    var json = jsonDecode(response.body);
    return GenreManga.toList(json['manga_list']);
  }

  static Future<DetailManga> getDetailManga(String endpoint) async {
    int counter = 0;
    Uri url = _getUrl('manga/detail/$endpoint');
    var response = await http.get(url);

    // api server something return empty object, try 3 time
    String title = jsonDecode(response.body)['title'].toString();
    while (true) {
      if (title.isEmpty) {
        response = await http.get(url);
        title = jsonDecode(response.body)['title'].toString();
      } else {
        break;
      }

      if (counter > 3) break;

      counter++;
    }
    if (title.isEmpty) throw Error();

    var json = jsonDecode(response.body);
    return DetailManga.toModel(json);
  }

  static Future<ChapterImage> getChapterImage(String endpoint) async {
    int counter = 0;
    Uri url = _getUrl('chapter/$endpoint');
    var response = await http.get(url);

    // api server something return empty object, try 3 time
    List listImage = jsonDecode(response.body)['chapter_image'];
    while (true) {
      if (listImage.isEmpty) {
        response = await http.get(url);
        listImage = jsonDecode(response.body)['chapter_image'];
      } else {
        break;
      }

      if (counter > 3) break;

      counter++;
    }
    if (listImage.isEmpty) throw Error();

    var json = jsonDecode(response.body);
    return ChapterImage.toModel(json);
  }

  static Future<List<SearchManga>> getSearchManga(String keyword) async {
    Uri url = _getUrl('search/$keyword');
    var response = await http.get(url);

    var json = jsonDecode(response.body);
    return SearchManga.toList(json['manga_list']);
  }
}
