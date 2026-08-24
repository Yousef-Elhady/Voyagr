import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../storage/secure_storage.dart';

/// Low-level, app-wide dependencies that don't belong to any single
/// feature. Feature-specific providers (authApiProvider,
/// authRepositoryProvider, currencyApiProvider, ...) do NOT live here —
/// they're colocated with their own class, right in auth_api.dart,
/// auth_repository.dart, etc. This file only holds the shared
/// foundation every feature builds on top of.

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(secureStorageProvider));
});

/// Convenience so *_api.dart files can depend on `dioProvider` directly
/// instead of reaching into `apiClientProvider.dio` every time.
final dioProvider = Provider<Dio>((ref) {
  return ref.watch(apiClientProvider).dio;
});