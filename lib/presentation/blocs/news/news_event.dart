import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class GetHeadlinesEvent extends NewsEvent {
  final String country;
  final String? category;

  const GetHeadlinesEvent({this.country = 'us', this.category});

  @override
  List<Object?> get props => [country, category];
}

class RefreshHeadlinesEvent extends NewsEvent {
  final String country;
  final String? category;

  const RefreshHeadlinesEvent({this.country = 'us', this.category});

  @override
  List<Object?> get props => [country, category];
}

class ChangeNewsCategoryEvent extends NewsEvent {
  final String category;

  const ChangeNewsCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}
