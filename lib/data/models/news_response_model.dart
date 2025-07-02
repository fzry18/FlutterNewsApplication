import 'package:news_app/data/models/article_model.dart';

class NewsResponseModel {
  final String status;
  final int totalResults;
  final List<ArticleModel> articles;

  NewsResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsResponseModel(
      status: json['status'] ?? '',
      totalResults: json['totalResults'] ?? 0,
      articles: json['articles'] != null
          ? List<ArticleModel>.from(
              json['articles'].map((x) => ArticleModel.fromJson(x)),
            )
          : [],
    );
  }
}
