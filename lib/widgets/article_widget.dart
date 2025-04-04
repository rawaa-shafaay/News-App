import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:sample/models/news_model.dart';
import 'package:sample/widgets/details_news_webview_widget.dart';

class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.article});

  final NewsModel article;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildImage(size),
          SizedBox(width: 10),
          _builTextContent(context),
        ],
      ),
    );
  }

  Widget _buildImage(Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FancyShimmerImage(
        imageUrl: article.urlToImage,
        width: size.height * 0.12,
        height: size.height * 0.12,
        boxFit: BoxFit.fill,
      ),
    );
  }

  Widget _builTextContent(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            article.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(article.readingTime),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DetailsNewsWebviewWidget(url: article.url),
                      ),
                    ),
                icon: Icon(Icons.link, color: Colors.blue),
              ),
              Text(article.dateToShow),
            ],
          ),
        ],
      ),
    );
  }
}
