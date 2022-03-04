class FeedbackModel {
  final String title;
  final String body;
  final DateTime dateTime = DateTime.now();

  FeedbackModel({required this.title, required this.body});

  Map<String, String> toMap() {
    return {
      'title': title,
      'body': body,
      'date_time': dateTime.toIso8601String(),
    };
  }
}
