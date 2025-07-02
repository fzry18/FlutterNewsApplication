import 'package:dartz/dartz.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';

class CheckFavoriteParams {
  final String articleId;

  CheckFavoriteParams({required this.articleId});
}

class CheckFavorite {
  final FavoritesRepository repository;

  CheckFavorite(this.repository);

  Future<Either<Exception, bool>> call(CheckFavoriteParams params) async {
    return await repository.isFavorite(params.articleId);
  }
}
