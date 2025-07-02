import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:news_app/core/errors/exceptions.dart';
import 'package:news_app/data/models/article_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<ArticleModel>> getFavorites();
  Future<void> addFavorite(ArticleModel article);
  Future<void> removeFavorite(String articleId);
  Future<bool> isFavorite(String articleId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Box<dynamic> favoritesBox;

  FavoritesLocalDataSourceImpl({required this.favoritesBox});

  @override
  Future<List<ArticleModel>> getFavorites() async {
    try {
      final List<ArticleModel> favoritesList = [];

      print('Debug: Jumlah item di favoritesBox: ${favoritesBox.length}');
      print('Debug: Keys di favoritesBox: ${favoritesBox.keys.toList()}');

      // Ubah cara pengambilan data
      for (var key in favoritesBox.keys) {
        try {
          final item = favoritesBox.get(key);
          if (item != null) {
            // Jika item tersimpan sebagai string JSON
            if (item is String) {
              final articleMap = json.decode(item);
              favoritesList.add(ArticleModel.fromJson(articleMap));
            }
            // Jika item tersimpan langsung sebagai Map
            else if (item is Map) {
              favoritesList.add(
                ArticleModel.fromJson(Map<String, dynamic>.from(item)),
              );
            }
            print('Debug: Berhasil parsing artikel dari cache: $key');
          }
        } catch (e) {
          print('Debug: Error parsing artikel: ${e.toString()}');
        }
      }

      print(
        'Debug: Total artikel favorit yang berhasil diparsing: ${favoritesList.length}',
      );
      return favoritesList;
    } catch (e) {
      print('Debug: Error saat mengambil favorit: ${e.toString()}');
      throw CacheException(message: 'Failed to get favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> addFavorite(ArticleModel article) async {
    try {
      // Ubah cara penyimpanan data
      final articleJson = article.toJson();
      await favoritesBox.put(article.id, json.encode(articleJson));
      print('Debug: Artikel berhasil disimpan dengan ID: ${article.id}');
    } catch (e) {
      print('Debug: Error saat menyimpan favorit: ${e.toString()}');
      throw CacheException(message: 'Failed to add favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorite(String articleId) async {
    try {
      await favoritesBox.delete(articleId);
    } catch (e) {
      throw CacheException(
        message: 'Failed to remove favorite: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isFavorite(String articleId) async {
    try {
      return favoritesBox.containsKey(articleId);
    } catch (e) {
      throw CacheException(
        message: 'Failed to check favorite: ${e.toString()}',
      );
    }
  }
}
