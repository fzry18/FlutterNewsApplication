import 'package:dio/dio.dart';
import 'package:news_app/core/constants/app_constants.dart';
import 'package:news_app/core/errors/exceptions.dart';
import 'package:news_app/core/network/api_client.dart';
import 'package:news_app/data/models/news_response_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getTopHeadlines({
    String country = 'us',
    String? category,
  });
  Future<NewsResponseModel> searchNews({required String query});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient apiClient;

  NewsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<NewsResponseModel> getTopHeadlines({
    String country = 'us',
    String? category,
  }) async {
    try {
      final params = {'country': country};

      // Tambahkan parameter kategori jika ada
      if (category != null && category.isNotEmpty) {
        params['category'] = category;
      }

      final response = await apiClient.get(
        ApiConstants.headlinesEndpoint,
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        return NewsResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? 'Failed to fetch news headlines',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'An error occurred while fetching news',
      );
    }
  }

  @override
  Future<NewsResponseModel> searchNews({required String query}) async {
    try {
      final response = await apiClient.get(
        ApiConstants.everythingEndpoint,
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        return NewsResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? 'Failed to search news',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'An error occurred while searching news',
      );
    }
  }
}
