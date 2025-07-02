import 'package:dartz/dartz.dart';
import 'package:news_app/core/errors/exceptions.dart';
import 'package:news_app/core/network/network_info.dart';
import 'package:news_app/data/datasources/news_local_datasource.dart';
import 'package:news_app/data/datasources/news_remote_datasource.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Exception, List<Article>>> getTopHeadlines({
    String country = 'us',
    String? category,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await remoteDataSource.getTopHeadlines(
          country: country,
          category: category,
        );
        localDataSource.cacheNews(remoteNews);
        return Right(remoteNews.articles);
      } on ServerException catch (e) {
        return Left(e);
      }
    } else {
      try {
        final cacheValid = await localDataSource.isCacheValid();
        if (cacheValid) {
          final localNews = await localDataSource.getLastNews();
          return Right(localNews.articles);
        } else {
          return Left(NetworkException());
        }
      } on CacheException catch (e) {
        return Left(e);
      }
    }
  }

  @override
  Future<Either<Exception, List<Article>>> searchNews({
    required String query,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final searchResults = await remoteDataSource.searchNews(query: query);
        return Right(searchResults.articles);
      } on ServerException catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkException());
    }
  }
}
