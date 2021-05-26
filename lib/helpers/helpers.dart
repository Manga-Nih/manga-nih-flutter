String cleanThumb(String url) => url.split('?')[0];

String typeMangaImage(String type) {
  if (type.toLowerCase() == 'manga') return 'images/japan_flag.png';
  if (type.toLowerCase() == 'manhua') return 'images/china_flag.png';
  if (type.toLowerCase() == 'manhwa') return 'images/korea_flag.png';

  return '';
}

String greetingNow() {
  int now = DateTime.now().hour;
  if (now >= 01 && now <= 10) {
    return 'Good Morning';
  } else if (now > 10 && now <= 16) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}
