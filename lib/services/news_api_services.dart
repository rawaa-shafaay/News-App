import 'dart:convert';
import 'package:sample/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:sample/response/news_api_response.dart';

class NewsApiServices {
  static Future<NewsApiResponse> fetchNewsFromApi({
    int? page,
    required String sortBy,
  }) async {
    const int pageSize = 10;

    Uri uri = Uri.https(baseurl, 'v2/everything', {
      'q': 'bitcoin',
      'pageSize': pageSize.toString(),
      'sortBy': sortBy,
      if (page != null) 'page': page.toString(),
    });

    var response = await http.get(uri, headers: {'X-Api-Key': apiKey});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return NewsApiResponse.fromJson(data, pageSize);
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}
