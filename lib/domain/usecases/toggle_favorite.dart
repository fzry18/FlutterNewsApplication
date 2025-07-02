import 'package:dartz/dartz.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';

class ToggleFavoriteParams {
  final Article article;

  ToggleFavoriteParams({required this.article});
}

class ToggleFavorite {
  final FavoritesRepository repository;

  ToggleFavorite(this.repository);

  Future<Either<Exception, bool>> call(ToggleFavoriteParams params) async {
    final isFavoriteResult = await repository.isFavorite(params.article.id);

    return isFavoriteResult.fold((failure) => Left(failure), (
      isFavorite,
    ) async {
      if (isFavorite) {
        return await repository.removeFavorite(params.article.id);
      } else {
        return await repository.addFavorite(params.article);
      }
    });
  }
}
