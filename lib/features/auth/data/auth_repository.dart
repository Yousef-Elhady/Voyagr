import 'package:ai_travel/core/di/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';
import 'auth_api.dart';
import '../domain/user.dart';

class AuthRepository {
  AuthRepository(this._authApi, this._secureStorage);

  final AuthApi _authApi;
  final SecureStorage _secureStorage;

  static const _accessTokenKey = 'auth_access_token';
  static const _accessTokenExpiryKey = 'auth_token_expires_at';
  static const _refreshTokenKey ='auth_refresh_token';

  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final json = await _authApi.signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    final accessToken = json['accessToken'];
    final refreshToken = json['refreshToken'];
    final expiresAt = json['expiresAt'];



    final userJson = json['user'];

    if (expiresAt is! String) {
      throw Exception(
        'token is missing or is not a String: $accessToken',
      );
    }
    await _secureStorage.write(_accessTokenExpiryKey, expiresAt);

    if (accessToken is! String) {
      throw Exception(
        'token is missing or is not a String: $accessToken',
      );
    }
    if (refreshToken is! String) {
      throw Exception(
        'refresh token is missing or is not a String: $refreshToken',
      );
    }


    if (userJson is! Map<String, dynamic>) {
      throw Exception(
        'user is missing or is not an object: $userJson',
      );
    }

    await _secureStorage.write(
      _accessTokenKey,
      accessToken,
    );

    await _secureStorage.write(
        _refreshTokenKey,
        refreshToken,
    );

    return User.fromJson(userJson);
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final json = await _authApi.login(
      email: email,
      password: password,
    );


    final accessToken = json['accessToken'];
    final refreshToken = json['refreshToken'];
    final expiresAt = json['expiresAt'];
    final userJson = json['user'];


    if (accessToken is! String) {
      throw Exception(
        'accessToken is missing or is not a String: $accessToken',
      );
    }
    if (refreshToken is! String) {
      throw Exception(
        'refresh token is missing or is not a String: $refreshToken',
      );
    }

    if (expiresAt is! String) {
      throw Exception(
        'expiresAt is missing or is not a String: $expiresAt',
      );
    }

    if (userJson is! Map<String, dynamic>) {
      throw Exception(
        'user is missing or is not an object: $userJson',
      );
    }

    await _secureStorage.write(
      _accessTokenKey,
      accessToken,
    );
    await _secureStorage.write(
      _refreshTokenKey,
      refreshToken,
    );

    await _secureStorage.write(
      _accessTokenExpiryKey,
      expiresAt,
    );

    return User.fromJson(userJson);
  }

  Future<User> getCurrentUser() async {
    final json = await _authApi.getCurrentUser();
    return User.fromJson(json);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(_accessTokenKey);
    await _secureStorage.delete(_accessTokenExpiryKey);
    await _secureStorage.delete(_refreshTokenKey);
  }

  Future<void> refresh() async {
    final refreshToken =
    await _secureStorage.read(_refreshTokenKey);

    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('No refresh token');
    }

    final json = await _authApi.refreshToken(
      refreshToken: refreshToken,
    );

    final accessToken = json['accessToken'];
    final newRefreshToken = json['refreshToken'];
    final expiresAt = json['expiresAt'];

    if (accessToken is! String) {
      throw Exception('Invalid access token');
    }

    if (expiresAt is! String) {
      throw Exception('Invalid expiresAt');
    }

    await _secureStorage.write(
      _accessTokenKey,
      accessToken,
    );

    await _secureStorage.write(
      _accessTokenExpiryKey,
      expiresAt,
    );

    if (newRefreshToken is String) {
      await _secureStorage.write(
        _refreshTokenKey,
        newRefreshToken,
      );
    }
  }

  Future<void> logout() async {
    final refreshToken = await _secureStorage.read(_refreshTokenKey);
    try {
      await _authApi.logout(refreshToken: refreshToken);
    } catch (_) {
    }
    await _secureStorage.delete(_accessTokenKey);
    await _secureStorage.delete(_accessTokenExpiryKey);
    await _secureStorage.delete(_refreshTokenKey);
  }

  Future<bool> restoreSession() async {
    final accessToken = await _secureStorage.read(_accessTokenKey);
    final refreshToken = await _secureStorage.read(_refreshTokenKey);

    if (accessToken == null|| accessToken.isEmpty || refreshToken == null) {
      return false;
    }

    final expiresAtRaw =
    await _secureStorage.read(_accessTokenExpiryKey);

    if (expiresAtRaw != null) {
      final expiresAt = DateTime.tryParse(expiresAtRaw);

      if (expiresAt != null &&
          DateTime.now().isAfter(expiresAt)) {
        try {
          await refresh();
        } catch (_) {
          await clearTokens();
          return false;
        }
      }
    }

    return true;
  }
}
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(secureStorageProvider),
  );
});