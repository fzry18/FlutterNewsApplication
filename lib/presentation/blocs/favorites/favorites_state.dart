import 'package:equatable/equatable.dart';
import 'package:news_app/domain/entities/article.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Article> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

class ArticleFavoriteStatus extends FavoritesState {
  final String articleId;
  final bool isFavorite;

  const ArticleFavoriteStatus({
    required this.articleId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [articleId, isFavorite];
}

class FavoriteToggleSuccess extends FavoritesState {
  final bool isFavorite;
  final Article article;

  const FavoriteToggleSuccess({
    required this.isFavorite,
    required this.article,
  });

  @override
  List<Object> get props => [isFavorite, article];
}
