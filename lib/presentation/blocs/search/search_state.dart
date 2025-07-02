import 'package:equatable/equatable.dart';
import 'package:news_app/domain/entities/article.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Article> articles;

  const SearchLoaded(this.articles);

  @override
  List<Object> get props => [articles];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
