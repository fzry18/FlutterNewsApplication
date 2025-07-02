import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/usecases/search_news.dart';
import 'package:news_app/presentation/blocs/search/search_event.dart';
import 'package:news_app/presentation/blocs/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchNews searchNews;

  SearchBloc({required this.searchNews}) : super(SearchInitial()) {
    on<SearchNewsEvent>(_onSearchNews);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchNews(
    SearchNewsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final result = await searchNews(SearchNewsParams(query: event.query));

    result.fold(
      (failure) => emit(SearchError(failure.toString())),
      (articles) => emit(SearchLoaded(articles)),
    );
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
