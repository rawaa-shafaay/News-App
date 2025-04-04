class NewsModel {
  final String id;
  final String name;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String readingTime;
  final String dateToShow;

  NewsModel({
    required this.id,
    required this.name,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.readingTime,
    required this.dateToShow,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['source']['id'] ?? "",
      name: json['source']['name'] ?? "",
      author: json['author'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      url: json['url'] ?? "",
      urlToImage: json['urlToImage'] ?? "",
      publishedAt: json['publishedAt'] ?? "",
      readingTime: 'readingTime',
      dateToShow: 'dateToShow',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': {'id': id, 'name': name},
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'readingTime': readingTime,
      'dateToShow': dateToShow,
    };
  }

  static List<NewsModel> newSnapShot(List<dynamic> snapShot) {
    return snapShot.where((item) => item != null).map((json) {
      return NewsModel.fromJson(json);
    }).toList();
  }
}
