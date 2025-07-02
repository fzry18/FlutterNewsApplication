import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/core/constants/app_constants.dart';
import 'package:news_app/core/errors/exceptions.dart';
import 'package:news_app/data/models/news_response_model.dart';

abstract class NewsLocalDataSource {
  Future<NewsResponseModel> getLastNews();
  Future<void> cacheNews(NewsResponseModel newsToCache);
  Future<bool> isCacheValid();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final SharedPreferences sharedPreferences;

  NewsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NewsResponseModel> getLastNews() async {
    final jsonString = sharedPreferences.getString(
      CacheConstants.cachedNewsHeadlines,
    );
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return NewsResponseModel.fromJson(jsonMap);
    } else {
      throw CacheException(message: 'No cached news found');
    }
  }

  @override
  Future<void> cacheNews(NewsResponseModel newsToCache) async {
    final jsonString = json.encode({
      'status': newsToCache.status,
      'totalResults': newsToCache.totalResults,
      'articles': newsToCache.articles
          .map((article) => article.toJson())
          .toList(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    await sharedPreferences.setString(
      CacheConstants.cachedNewsHeadlines,
      jsonString,
    );
  }

  @override
  Future<bool> isCacheValid() async {
    final jsonString = sharedPreferences.getString(
      CacheConstants.cachedNewsHeadlines,
    );
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      if (jsonMap.containsKey('timestamp')) {
        final timestamp = jsonMap['timestamp'] as int;
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        return now.difference(cacheTime) < CacheConstants.cacheValidity;
      }
    }
    return false;
  }
}
