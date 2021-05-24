class ChapterImage {
  final String endpoint;
  final List<String> listImage;

  ChapterImage({required this.endpoint, required this.listImage});

  factory ChapterImage.toModel(dynamic json) {
    List<String> listImage = [];

    for (var data in json['chapter_image']) {
      listImage.add(data['chapter_image_link']);
    }

    return ChapterImage(
      endpoint: json['chapter_endpoint'],
      listImage: listImage,
    );
  }
}
