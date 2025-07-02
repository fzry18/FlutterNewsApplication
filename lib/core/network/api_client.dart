import 'package:dio/dio.dart';
import 'package:news_app/core/constants/app_constants.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(
        milliseconds: ApiConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final params = {'apiKey': ApiConstants.apiKey, ...?queryParameters};

    try {
      final response = await dio.get(endpoint, queryParameters: params);
      return response;
    } on DioException {
      rethrow;
    }
  }
}
