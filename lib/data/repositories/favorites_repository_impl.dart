import 'package:dartz/dartz.dart';
import 'package:news_app/core/errors/exceptions.dart';
import 'package:news_app/data/datasources/favorites_local_datasource.dart';
import 'package:news_app/data/models/article_model.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Exception, List<Article>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> addFavorite(Article article) async {
    try {
      await localDataSource.addFavorite(ArticleModel.fromEntity(article));
      return const Right(true);
    } on CacheException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> removeFavorite(String articleId) async {
    try {
      await localDataSource.removeFavorite(articleId);
      return const Right(true);
    } on CacheException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> isFavorite(String articleId) async {
    try {
      final isFavorite = await localDataSource.isFavorite(articleId);
      return Right(isFavorite);
    } on CacheException catch (e) {
      return Left(e);
    }
  }
}
