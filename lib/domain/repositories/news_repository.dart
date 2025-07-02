import 'package:dartz/dartz.dart';
// import 'package:news_app/core/errors/exceptions.dart';
import 'package:news_app/domain/entities/article.dart';

abstract class NewsRepository {
  Future<Either<Exception, List<Article>>> getTopHeadlines({
    String country = 'us',
    String? category,
  });
  Future<Either<Exception, List<Article>>> searchNews({required String query});
}
