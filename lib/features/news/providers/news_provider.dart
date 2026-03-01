import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../models/news_model.dart';

final newsProvider = FutureProvider<List<NewsModel>>((ref) async {
  final dio = ref.watch(dioProvider);

  try {
    final response = await dio.get('', queryParameters: {
      'function': 'NEWS_SENTIMENT',
      'sort': 'LATEST',
    });

    if (response.statusCode == 200) {
      final data = response.data;

      if (data is Map<String, dynamic>) {
        if (data.containsKey('Information') ||
            data.containsKey('Note') ||
            data.containsKey('Error Message')) {
          return _getDummyNewsData();
        }
      }

      if (data != null && data['feed'] != null) {
        final List feed = data['feed'];
        return feed.map((item) => NewsModel.fromJson(item)).toList();
      }

      return _getDummyNewsData();
    }

    return _getDummyNewsData();
  } catch (e) {
    return _getDummyNewsData();
  }
});

List<NewsModel> _getDummyNewsData() {
  final dummyJsonFeed = [
    {
      "title": "Tech Giants Rally as AI Adoption Accelerates Across Industries",
      "source": "TechInsider",
      "banner_image": "https://images.unsplash.com/photo-1611162617474-5b21e879e113?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "url": "https://example.com/news1",
      "time_published": "20240301T100000",
      "summary": "Major technology stocks saw significant gains today following new reports on artificial intelligence integration.",
      "overall_sentiment_score": 0.5,
      "overall_sentiment_label": "Bullish"
    },
    {
      "title": "Global Markets Show Resilience Amid Economic Shifts",
      "source": "MarketWatch Pro",
      "banner_image": "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "url": "https://example.com/news2",
      "time_published": "20240301T093000",
      "summary": "Investors remain cautious as global markets adapt to recent monetary policy announcements.",
      "overall_sentiment_score": -0.25,
      "overall_sentiment_label": "Somewhat Bearish"
    },
    {
      "title": "Electric Vehicle Sales Hit Record High in Q1",
      "source": "AutoNews Daily",
      "banner_image": "https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "url": "https://example.com/news3",
      "time_published": "20240301T081500",
      "summary": "The EV sector continues its explosive growth, with leading manufacturers reporting record deliveries.",
      "overall_sentiment_score": 0.7,
      "overall_sentiment_label": "Bullish"
    },
    {
      "title": "Renewable Energy Investments Surge in 2024",
      "source": "EcoFinance",
      "banner_image": "https://images.unsplash.com/photo-1466611653911-95081537e5b7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "url": "https://example.com/news4",
      "time_published": "20240301T074500",
      "summary": "Clean energy projects are seeing unprecedented funding as countries push for zero-emission targets.",
      "overall_sentiment_score": 0.2,
      "overall_sentiment_label": "Somewhat Bullish"
    },
    {
      "title": "Semiconductor Supply Chain Stabilizes, Boosting Tech Stocks",
      "source": "Global Business News",
      "banner_image": "https://images.unsplash.com/photo-1518770660439-4636190af475?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "url": "https://example.com/news5",
      "time_published": "20240301T062000",
      "summary": "Chip manufacturers report improved production capacities, easing fears of future shortages.",
      "overall_sentiment_score": 0.1,
      "overall_sentiment_label": "Neutral"
    },
    {
      "title": "Oil Prices Drop Amid Surprising Inventory Build-Up",
      "source": "EnergyReports",
      "banner_image": "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "url": "https://example.com/news6",
      "time_published": "20240301T054500",
      "summary": "Crude oil futures fell sharply after official data showed a larger-than-expected increase in domestic stockpiles.",
      "overall_sentiment_score": -0.55,
      "overall_sentiment_label": "Bearish"
    }
  ];

  return dummyJsonFeed.map((item) => NewsModel.fromJson(item)).toList();
}