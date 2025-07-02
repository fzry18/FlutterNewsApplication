import 'package:dartz/dartz.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<Either<Exception, List<Article>>> call() async {
    return await repository.getFavorites();
  }
}
