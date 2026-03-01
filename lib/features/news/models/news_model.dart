class NewsModel {
  final String title;
  final String summary;
  final String url;
  final String bannerImage;
  final String source;
  final String timePublished;
  final double sentimentScore;
  final String sentimentLabel;

  NewsModel({
    required this.title,
    required this.summary,
    required this.url,
    required this.bannerImage,
    required this.source,
    required this.timePublished,
    required this.sentimentScore,
    required this.sentimentLabel,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
      bannerImage: json['banner_image'] ?? 'https://via.placeholder.com/150',
      source: json['source'] ?? 'Unknown',
      timePublished: json['time_published'] ?? '',
      sentimentScore: (json['overall_sentiment_score'] ?? 0.0).toDouble(),
      sentimentLabel: json['overall_sentiment_label'] ?? 'Neutral',
    );
  }
}