class Chapter {
  final String title;
  final String endpoint;

  Chapter({required this.title, required this.endpoint});

  static List<Chapter> toList(dynamic json) {
    List<Chapter> listChapter = [];

    for (var data in json) {
      listChapter.add(Chapter(
        title: data['chapter_title'],
        endpoint: data['chapter_endpoint'],
      ));
    }

    return listChapter;
  }
}
