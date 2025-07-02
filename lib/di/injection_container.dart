import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/core/network/api_client.dart';
import 'package:news_app/core/network/network_info.dart';
import 'package:news_app/data/datasources/favorites_local_datasource.dart';
import 'package:news_app/data/datasources/news_local_datasource.dart';
import 'package:news_app/data/datasources/news_remote_datasource.dart';
import 'package:news_app/data/repositories/favorites_repository_impl.dart';
import 'package:news_app/data/repositories/news_repository_impl.dart';
import 'package:news_app/domain/repositories/favorites_repository.dart';
import 'package:news_app/domain/repositories/news_repository.dart';
import 'package:news_app/domain/usecases/check_favorite.dart';
import 'package:news_app/domain/usecases/get_favorites.dart';
import 'package:news_app/domain/usecases/get_news_headlines.dart';
import 'package:news_app/domain/usecases/search_news.dart';
import 'package:news_app/domain/usecases/toggle_favorite.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:news_app/presentation/blocs/news/news_bloc.dart';
import 'package:news_app/presentation/blocs/search/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - News
  // BLoC
  sl.registerFactory(() => NewsBloc(getNewsHeadlines: sl()));

  sl.registerFactory(() => SearchBloc(searchNews: sl()));

  sl.registerFactory(
    () => FavoritesBloc(
      getFavorites: sl(),
      toggleFavorite: sl(),
      checkFavorite: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNewsHeadlines(sl()));
  sl.registerLazySingleton(() => SearchNews(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => CheckFavorite(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(favoritesBox: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  sl.registerLazySingleton(() => ApiClient(dio: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  // Inisialisasi Hive box for favorites
  final favoritesBox = await Hive.openBox('favorites');
  sl.registerLazySingleton(() => favoritesBox);
}
