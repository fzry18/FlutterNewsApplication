import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String? author;
  final String? description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String content;
  final String source;

  const Article({
    required this.id,
    required this.title,
    this.author,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.source,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    description,
    url,
    urlToImage,
    publishedAt,
    content,
    source,
  ];
}
