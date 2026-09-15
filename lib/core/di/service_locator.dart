import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../features/auth/data/auth_repository.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';
import '../storage/secure_storage.dart';

final secureStorageProvider =
Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final authDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://voyger-xrip.onrender.com/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();

  final authRepository = ref.read(authRepositoryProvider);

  client.dio.interceptors.add(
    AuthInterceptor(
      client.dio,
      authRepository,
    ),
  );

  return client;
});

final dioProvider = Provider<Dio>((ref) {
  return ref.watch(apiClientProvider).dio;
});