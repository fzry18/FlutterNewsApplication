import 'package:news_app/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required String id,
    required String title,
    String? author,
    String? description,
    required String url,
    String? urlToImage,
    required String publishedAt,
    required String content,
    required String source,
  }) : super(
         id: id,
         title: title,
         author: author,
         description: description,
         url: url,
         urlToImage: urlToImage,
         publishedAt: publishedAt,
         content: content,
         source: source,
       );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      // Generate a unique ID
      id: json['url'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      author: json['author'],
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? DateTime.now().toIso8601String(),
      content: json['content'] ?? '',
      source: json['source'] != null ? json['source']['name'] ?? '' : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'source': {'name': source},
    };
  }

  factory ArticleModel.fromEntity(Article article) {
    return ArticleModel(
      id: article.id,
      title: article.title,
      author: article.author,
      description: article.description,
      url: article.url,
      urlToImage: article.urlToImage,
      publishedAt: article.publishedAt,
      content: article.content,
      source: article.source,
    );
  }
}
