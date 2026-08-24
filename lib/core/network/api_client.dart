// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage.dart';
import 'api_exception.dart';

/// Builds and configures the single Dio instance every *_api.dart file
/// in the app shares. Handles two things centrally so individual API
/// files (auth_api.dart, currency_api.dart, ...) never have to:
///   1. Attaching the bearer token to every outgoing request
///   2. Converting any failed response into an ApiException
class ApiClient {
  ApiClient(this._secureStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      _authInterceptor(),
      _errorInterceptor(),
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  late final Dio dio;
  final SecureStorage _secureStorage;

  // TODO: move into core/config/env.dart once that file exists, and
  // load per-flavor (dev/staging/prod) instead of hardcoding.
  //
  // Reminder: "localhost" only reaches your own machine.
  //   - Android emulator -> use 10.0.2.2 to reach your host machine
  //   - iOS simulator     -> localhost works fine
  //   - Physical device    -> use your machine's LAN IP instead
  static const _baseUrl = 'https://voyger-xrip.onrender.com/api/v1';

  /// Reads the stored token (same key auth_repository.dart writes to)
  /// and attaches it as a Bearer header on every request. Public
  /// endpoints (register/login) simply ignore the header — the backend
  /// only checks it on protected routes, so there's no need to
  /// conditionally skip attaching it here.
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read('auth_access_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }

  /// Converts every failed response into an ApiException and attaches
  /// it to the DioException's `.error` field before rethrowing. Dio
  /// always surfaces failures as a DioException (there's no way around
  /// that from an interceptor) — but every catch site in the app should
  /// call `ApiException.from(e)` to unwrap the real error, rather than
  /// inspecting the raw DioException directly.
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