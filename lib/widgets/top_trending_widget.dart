import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sample/models/news_model.dart';
import 'package:sample/widgets/details_news_webview_widget.dart';

class TopTrendingWidget extends StatelessWidget {
  const TopTrendingWidget({super.key, required this.article});

  final NewsModel article;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: _buildCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNewsImage(context),
          const SizedBox(height: 12),
          _buildNewsTitle(context),
          const SizedBox(height: 8),
          _buildNewsFooter(context),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildNewsImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: FancyShimmerImage(
        imageUrl: article.urlToImage,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        boxFit: BoxFit.cover,
        errorWidget: Container(
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildNewsTitle(BuildContext context) {
    return Text(
      article.title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildNewsFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          article.dateToShow,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        IconButton(
          onPressed: () => _handleLinkPressed(context, article.url),
          icon: const Icon(Icons.link, color: Colors.blue),
          iconSize: 20,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  void _handleLinkPressed(BuildContext context, String url) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: DetailsNewsWebviewWidget(url: url),
      ),
    );
  }
}
