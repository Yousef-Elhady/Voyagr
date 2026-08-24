import 'package:ai_travel/core/di/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  static const _basePath = '/auth';

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_basePath/signup',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    print('RAW SIGNUP RESPONSE: ${response.data}');
    return _unwrap(response);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_basePath/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return _unwrap(response);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>('$_basePath/me');
    return _unwrap(response);
  }

  Future<void> logout() async {
    await _dio.post<Map<String, dynamic>>('$_basePath/logout');
  }

  Map<String, dynamic> _unwrap(Response<Map<String, dynamic>> response) {
    final body = response.data;
    if (body != null && body['data'] is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});