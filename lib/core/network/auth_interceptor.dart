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

  Future<void> _refreshToken() {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    final future = _authRepository.refresh();

    _refreshFuture = future;

    future.whenComplete(() {
      if (identical(_refreshFuture, future)) {
        _refreshFuture = null;
      }
    });

    return future;
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
      await _refreshToken();

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