import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/enums/news_type.dart';
import 'package:sample/providers/news_provider.dart';
import 'package:sample/routes/app_routes.dart';
import 'package:sample/states/empty_state.dart';
import 'package:sample/states/error_state.dart';
import 'package:sample/widgets/article_widget.dart';
import 'package:sample/widgets/drawer_widget.dart';
import 'package:sample/widgets/sort_by_widget.dart';
import 'package:sample/widgets/theme_toggle_icon.dart';
import 'package:sample/widgets/top_trending_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _swiperController = SwiperController();
  NewsType _currentView = NewsType.allNews;
  late final NewsProvider _newsProvider;
  Timer? _loadMoreTimer;

  @override
  void dispose() {
    _loadMoreTimer?.cancel();
    _scrollController.removeListener(_setupScrollListener);
    _scrollController.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _newsProvider = context.read<NewsProvider>();
    _loadInitialData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_newsProvider.isLoading && _newsProvider.hasMore) {
          _newsProvider.loadArticles(page: _newsProvider.currentPage + 1);
        }
      }
    });
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _newsProvider.articles.isEmpty) {
        _newsProvider.loadArticles();
      }
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_shouldLoadMore()) {
        _loadMoreTimer?.cancel();
        _loadMoreTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted && _shouldLoadMore()) {
            _newsProvider.loadArticles(page: _newsProvider.currentPage + 1);
          }
        });
      }
    });
  }

  bool _shouldLoadMore() {
    final position = _scrollController.position;
    return position.pixels >= position.maxScrollExtent - 100 &&
        !_newsProvider.isLoading &&
        _newsProvider.hasMore;
  }

  Future<void> _refreshData() async {
    try {
      await _newsProvider.refreshArticles();
      if (mounted) {
        _showSnackBar('News refreshed successfully');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Refresh failed: ${e.toString()}');
        Future.delayed(const Duration(seconds: 3), _refreshData);
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 2,
      title: Text('News App'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
          tooltip: 'search news',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshData(),
          tooltip: 'refresh news',
        ),
        ThemeToggleIcon(),
      ],
    );
  }

  Widget _buildContent() {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.articles.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return ErrorState(error: provider.error!, onRetry: _refreshData);
        }
        if (provider.articles.isEmpty) {
          return EmptyState(onRefresh: _refreshData);
        }

        return Column(
          children: [
            _buildViewSelector(),
            if (_currentView == NewsType.allNews) ...[
              const SortByWidget(),
              const SizedBox(height: 8),
            ],
            Expanded(
              child:
                  _currentView == NewsType.allNews
                      ? _buildArticlesList(provider)
                      : _buildTrendingView(provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildViewSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<NewsType>(
          segments: _newsTypeSegments,
          selected: {_currentView},
          onSelectionChanged:
              (newsSelection) =>
                  setState(() => _currentView = newsSelection.first),
        ),
      ),
    );
  }

  final List<ButtonSegment<NewsType>> _newsTypeSegments = [
    const ButtonSegment(
      value: NewsType.allNews,
      label: Text('All News'),
      icon: Icon(Icons.list),
    ),
    const ButtonSegment(
      value: NewsType.topTrending,
      label: Text('Top Trending'),
      icon: Icon(Icons.trending_up),
    ),
  ];

  Widget _buildArticlesList(NewsProvider provider) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.articles.length + 1,
        itemBuilder: (context, index) {
          if (index < provider.articles.length) {
            return Column(
              children: [
                ArticleWidget(
                  article: provider.articles[index],
                  key: ValueKey(provider.articles[index].id),
                ),
                const Divider(height: 1),
              ],
            );
          }
          return _buildListFooter(provider);
        },
      ),
    );
  }

  Widget _buildListFooter(NewsProvider provider) {
    if (provider.hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          '🎉 You have reached the end!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTrendingView(NewsProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Swiper(
          controller: _swiperController,
          itemCount: provider.articles.length,
          itemBuilder:
              (_, index) => TopTrendingWidget(
                article: provider.articles[index],
                key: ValueKey(provider.articles[index].id),
              ),
          autoplay: true,
          autoplayDelay: 8000,
          viewportFraction: 0.9,
          scale: 0.9,
          layout: SwiperLayout.STACK,
          itemWidth: constraints.maxWidth * 0.9,
          itemHeight: constraints.maxHeight,
        );
      },
    );
  }
}
