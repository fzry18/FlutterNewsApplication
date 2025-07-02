import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/usecases/get_news_headlines.dart';
import 'package:news_app/presentation/blocs/news/news_event.dart';
import 'package:news_app/presentation/blocs/news/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsHeadlines getNewsHeadlines;
  String _currentCategory = '';

  NewsBloc({required this.getNewsHeadlines}) : super(NewsInitial()) {
    on<GetHeadlinesEvent>(_onGetHeadlines);
    on<RefreshHeadlinesEvent>(_onRefreshHeadlines);
    on<ChangeNewsCategoryEvent>(_onChangeCategory);
  }

  Future<void> _onGetHeadlines(
    GetHeadlinesEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    final result = await getNewsHeadlines(
      GetNewsHeadlinesParams(country: event.country, category: event.category),
    );

    result.fold(
      (failure) => emit(NewsError(failure.toString())),
      (articles) => emit(NewsLoaded(articles)),
    );
  }

  Future<void> _onRefreshHeadlines(
    RefreshHeadlinesEvent event,
    Emitter<NewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is NewsLoaded) {
      emit(NewsLoaded(currentState.articles));
    }

    final result = await getNewsHeadlines(
      GetNewsHeadlinesParams(
        country: event.country,
        category:
            event.category ??
            (_currentCategory.isEmpty ? null : _currentCategory),
      ),
    );

    result.fold(
      (failure) => emit(NewsError(failure.toString())),
      (articles) => emit(NewsLoaded(articles)),
    );
  }

  Future<void> _onChangeCategory(
    ChangeNewsCategoryEvent event,
    Emitter<NewsState> emit,
  ) async {
    _currentCategory = event.category;
    add(GetHeadlinesEvent(category: _currentCategory));
  }
}
