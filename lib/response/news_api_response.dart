import 'package:sample/models/news_model.dart';

class NewsApiResponse {
  final List<NewsModel> articles;
  final int totalResults;
  final int pageSize;

  NewsApiResponse({
    required this.articles,
    required this.totalResults,
    required this.pageSize,
  });

  factory NewsApiResponse.fromJson(Map<String, dynamic> json, int pageSize) {
    return NewsApiResponse(
      articles: NewsModel.newsSnapShot(json['articles'] ?? []),
      totalResults: json['totalResults'] ?? 0,
      pageSize: pageSize,
    );
  }
}
