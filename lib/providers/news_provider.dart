import 'package:flutter/material.dart';
import 'package:sample/models/news_model.dart';
import 'package:sample/services/news_api_services.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> _articlesList = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasMore = true;
  int _currentPage = 1;

  List<NewsModel> get articles => _articlesList;
  bool get isLoading => _isLoading;
  String? get error => _errorMessage;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  Future<void> loadArticles({bool refresh = false, int page = 1}) async {
    if (_isLoading) return;

    _setLoading(true);

    if (refresh) {
      _resetState();
    }

    try {
      final response = await NewsApiServices.fetchNewsFromApi(page: page);
      final newArticles = response.articles;

      _hasMore = newArticles.length == response.pageSize;

      if (refresh) {
        _articlesList = newArticles;
      } else {
        _articlesList.addAll(newArticles);
      }
      _currentPage = page;
    } catch (e) {
      _setError('Failed to load articles: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _resetState() {
    _articlesList.clear();
    _currentPage = 1;
    _hasMore = true;
    _clearError();
  }

  Future<void> refreshArticles() async {
    await loadArticles(refresh: true, page: 1);
  }

  void changePage(int newPage) {
    if (newPage != _currentPage) {
      _currentPage = newPage;
      loadArticles(page: newPage);
    }
  }
}
