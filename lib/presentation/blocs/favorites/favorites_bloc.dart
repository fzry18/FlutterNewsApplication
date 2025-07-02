import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/usecases/check_favorite.dart';
import 'package:news_app/domain/usecases/get_favorites.dart';
import 'package:news_app/domain/usecases/toggle_favorite.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_event.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;
  final CheckFavorite checkFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.toggleFavorite,
    required this.checkFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatus);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    final result = await getFavorites();

    result.fold(
      (failure) {
        print('Debug: Gagal memuat favorit: ${failure.toString()}');
        emit(FavoritesError(failure.toString()));
      },
      (favorites) {
        print('Debug: Berhasil memuat ${favorites.length} favorit');
        // Log setiap favorit untuk debugging
        for (var article in favorites) {
          print('Debug: Favorit - ${article.title}');
        }
        emit(FavoritesLoaded(favorites));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    // PERBAIKAN: Tambahkan log untuk melihat proses toggle
    print('Debug: Toggle favorite untuk artikel: ${event.article.title}');

    final result = await toggleFavorite(
      ToggleFavoriteParams(article: event.article),
    );

    await result.fold(
      (failure) async {
        print('Debug: Toggle favorite gagal: ${failure.toString()}');
        emit(FavoritesError(failure.toString()));
      },
      (isFavorite) async {
        print('Debug: Toggle favorite berhasil, status: $isFavorite');
        emit(
          FavoriteToggleSuccess(isFavorite: isFavorite, article: event.article),
        );

        // PERBAIKAN: Langsung reload dan emit favorites yang baru
        final favoritesResult = await getFavorites();
        favoritesResult.fold(
          (failure) => emit(FavoritesError(failure.toString())),
          (favorites) {
            print(
              'Debug: Reload favorites setelah toggle, total: ${favorites.length}',
            );
            emit(FavoritesLoaded(favorites));
          },
        );
      },
    );
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatusEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await checkFavorite(
      CheckFavoriteParams(articleId: event.articleId),
    );

    result.fold(
      (failure) => emit(FavoritesError(failure.toString())),
      (isFavorite) => emit(
        ArticleFavoriteStatus(
          articleId: event.articleId,
          isFavorite: isFavorite,
        ),
      ),
    );
  }
}
