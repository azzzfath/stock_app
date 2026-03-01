import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/news_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;
  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

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

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            centerTitle: false,
            expandedHeight: 250,
            pinned: true,

            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                news.bannerImage,
                fit: BoxFit.cover,
                headers: const {
                  'User-Agent': 'Mozilla/5.0...',
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                    ),
                  );
                },
              ),
            ),

          ),

          SliverToBoxAdapter(

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        news.source,
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
                      ),

                      Text(
                        _formatDate(news.timePublished),
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 14),
                      ),

                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                    decoration: BoxDecoration(
                      color: _getSentimentColor(news.sentimentLabel).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getSentimentColor(news.sentimentLabel),
                        width: 1,
                      ),
                    ),

                    child:
                        Text(
                          news.sentimentLabel,
                          style: TextStyle(
                            color: _getSentimentColor(news.sentimentLabel),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),

                  ),
                  const SizedBox(height: 16),


                  Text(
                      news.title,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, height: 1.3)
                  ),
                  const SizedBox(height: 20),

                  Text(
                      news.summary,
                      style: const TextStyle(fontSize: 16, height: 1.6, letterSpacing: 0.2)
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(

                      onPressed: () async {
                        final url = Uri.parse(news.url);
                        if (await canLaunchUrl(url)) await launchUrl(url);
                      },

                      icon: const Icon(Iconsax.global),
                      label: const Text('Read Full Article', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                ],
              ),
            ),

          ),
        ],
      ),
    );
  }
}