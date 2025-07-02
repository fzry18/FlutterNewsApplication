class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = 'cc8beefaebf0445199dc7a57dec0da70';
  static const String headlinesEndpoint = '/top-headlines';
  static const String everythingEndpoint = '/everything';
  static const String sourcesEndpoint = '/sources';
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 15000;
}

class CacheConstants {
  static const String cachedNewsHeadlines = 'CACHED_NEWS_HEADLINES';
  static const String cachedArticles = 'CACHED_ARTICLES';
  static const Duration cacheValidity = Duration(hours: 1);
}
