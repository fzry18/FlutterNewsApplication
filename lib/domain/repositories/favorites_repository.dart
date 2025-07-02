import 'package:dartz/dartz.dart';
import 'package:news_app/domain/entities/article.dart';

abstract class FavoritesRepository {
  Future<Either<Exception, List<Article>>> getFavorites();
  Future<Either<Exception, bool>> addFavorite(Article article);
  Future<Either<Exception, bool>> removeFavorite(String articleId);
  Future<Either<Exception, bool>> isFavorite(String articleId);
}
