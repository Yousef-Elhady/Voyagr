import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';

class ApiClient {
  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      _errorInterceptor(),

      if (kDebugMode)
        LogInterceptor(
          requestBody: false,
          responseBody: false,
        ),
    ]);
  }

  late final Dio dio;

  static const _baseUrl =
      'https://voyger-xrip.onrender.com/api/v1';

  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException error, handler) {
        final apiException = ApiException.fromResponse(
          error.response,
          fallbackMessage: error.message,
        );

        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: apiException,
          ),
        );
      },
    );
  }
}