import 'package:dio/dio.dart';

import '../../features/auth/data/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(
      this._dio,
      this._authRepository,
      );

  final Dio _dio;
  final AuthRepository _authRepository;

  Future<void>? _refreshFuture;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final accessToken =
    await _authRepository.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] =
      'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {

    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final path = err.requestOptions.path;

    if (path.contains('/auth/login') ||
        path.contains('/auth/signup') ||
        path.contains('/auth/refresh')) {
      handler.next(err);
      return;
    }

    if (err.requestOptions.extra['retried'] == true) {
      await _authRepository.clearTokens();
      handler.next(err);
      return;
    }

    try {

      _refreshFuture ??= _authRepository.refresh();

      try {
        await _refreshFuture!;
      } finally {
        _refreshFuture = null;
      }

      final newAccessToken =
      await _authRepository.getAccessToken();

      if (newAccessToken == null ||
          newAccessToken.isEmpty) {
        throw Exception(
          'Failed to refresh access token',
        );
      }

      final requestOptions = err.requestOptions;

      requestOptions.headers['Authorization'] =
      'Bearer $newAccessToken';

      requestOptions.extra['retried'] = true;

      final response = await _dio.fetch(
        requestOptions,
      );

      handler.resolve(response);
    } catch (_) {
      await _authRepository.clearTokens();

      handler.next(err);
    }
  }
}