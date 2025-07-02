import 'package:dartz/dartz.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

class SearchNewsParams {
  final String query;

  SearchNewsParams({required this.query});
}

class SearchNews {
  final NewsRepository repository;

  SearchNews(this.repository);

  Future<Either<Exception, List<Article>>> call(SearchNewsParams params) async {
    return await repository.searchNews(query: params.query);
  }
}
