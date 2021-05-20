String cleanThumb(String url) => url.split('?')[0];

String typeMangaImage(String type) {
  if (type.toLowerCase() == 'manga') return 'images/japan_flag.png';
  if (type.toLowerCase() == 'manhua') return 'images/china_flag.png';
  if (type.toLowerCase() == 'manhwa') return 'images/korea_flag.png';

  return '';
}
