import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider global Dio
final dioProvider = Provider<Dio>((ref) {

  // Add base URL
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.alphavantage.co/query', // Base URL AlphaVantage
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Add API key
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final apiKey = dotenv.env['ALPHAVANTAGE_API_KEY'];
      options.queryParameters['apikey'] = apiKey;
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      return handler.next(e);
    },
  ));

  return dio;
});