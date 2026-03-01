import 'package:flutter/material.dart';
import 'package:stock_app/features/news/models/news_model.dart';
import '../../news_detail/news_detail_screen.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({
    Key? key,
    required this.news,
  }) : super(key: key);

  Color _getSentimentColor(String label) {
    switch (label) {
      case 'Bullish':
        return Colors.green[600]!;
      case 'Somewhat Bullish':
        return Colors.green[300]!;
      case 'Bearish':
        return Colors.red[600]!;
      case 'Somewhat Bearish':
        return Colors.red[300]!;
      case 'Neutral':
      default:
        return Colors.grey[600]!;
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.length >= 8) {
      try {
        final year = dateStr.substring(0, 4);
        final month = dateStr.substring(4, 6);
        final day = dateStr.substring(6, 8);
        return '$day/$month/$year';
      } catch (e) {
        return dateStr;
      }
    }
    return dateStr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewsDetailScreen(news: news)),
      ),

      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [

                Image.network(
                  news.bannerImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported)
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,

                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                    decoration: BoxDecoration(
                      color: _getSentimentColor(news.sentimentLabel).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),

                    child: Text(
                      news.sentimentLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),


            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        news.source,
                        style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      Text(
                        _formatDate(news.timePublished),
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12),
                      ),

                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(
                    news.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}