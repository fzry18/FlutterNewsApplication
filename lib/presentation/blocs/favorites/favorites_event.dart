import 'package:equatable/equatable.dart';
import 'package:news_app/domain/entities/article.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final Article article;

  const ToggleFavoriteEvent(this.article);

  @override
  List<Object> get props => [article];
}

class CheckFavoriteStatusEvent extends FavoritesEvent {
  final String articleId;

  const CheckFavoriteStatusEvent(this.articleId);

  @override
  List<Object> get props => [articleId];
}
