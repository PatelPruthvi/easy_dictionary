class WordStoriesModel {
  final String title;
  final String readingTime;
  final String content;

  WordStoriesModel(
      {required this.title, required this.readingTime, required this.content});

  Map<String, dynamic> toJson() =>
      {"title": title, "reading_time": readingTime, "content": content};

  factory WordStoriesModel.fromJson(Map<String, dynamic> json) =>
      WordStoriesModel(
          title: json["title"],
          readingTime: json["reading_time"],
          content: json["content"]);
}
