import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchNewsEvent extends SearchEvent {
  final String query;

  const SearchNewsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearchEvent extends SearchEvent {}
