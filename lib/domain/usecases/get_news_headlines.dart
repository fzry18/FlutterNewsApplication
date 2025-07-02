import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

class GetNewsHeadlinesParams extends Equatable {
  final String country;
  final String? category;

  const GetNewsHeadlinesParams({this.country = 'us', this.category});

  @override
  List<Object?> get props => [country, category];
}

class GetNewsHeadlines {
  final NewsRepository repository;

  GetNewsHeadlines(this.repository);

  Future<Either<Exception, List<Article>>> call(
    GetNewsHeadlinesParams params,
  ) async {
    return await repository.getTopHeadlines(
      country: params.country,
      category: params.category,
    );
  }
}
