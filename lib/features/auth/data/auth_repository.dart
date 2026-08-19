
import 'package:ai_travel/core/di/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';
import 'auth_api.dart';
import '../domain/user.dart';

class AuthRepository {
  AuthRepository(this._authApi, this._secureStorage);

  final AuthApi _authApi;
  final SecureStorage _secureStorage;

  static const _tokenKey = 'auth_access_token';
  static const _tokenExpiryKey = 'auth_token_expires_at';

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final json = await _authApi.register(
      name: name,
      email: email,
      password: password,
    );

    final token = json['token'];

    final userJson = json['user'];

    if (token is! String) {
      throw Exception(
        'token is missing or is not a String: $token',
      );
    }

    if (userJson is! Map<String, dynamic>) {
      throw Exception(
        'user is missing or is not an object: $userJson',
      );
    }

    await _secureStorage.write(
      _tokenKey,
      token,
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

    print('LOGIN RESPONSE: $json');

    final token = json['token'];
    //final expiresAt = json['expiresAt'];
    final userJson = json['user'];

    print('ACCESS TOKEN: $token');
    //print('EXPIRES AT: $expiresAt');
    print('USER: $userJson');

    if (token is! String) {
      throw Exception(
        'accessToken is missing or is not a String: $token',
      );
    }

    ///if (expiresAt is! String) {
      ///throw Exception(
        ///'expiresAt is missing or is not a String: $expiresAt',
      ///);
    ///}

    if (userJson is! Map<String, dynamic>) {
      throw Exception(
        'user is missing or is not an object: $userJson',
      );
    }

    await _secureStorage.write(
      _tokenKey,
      token,
    );

    ///await _secureStorage.write(
      ///_tokenExpiryKey,
      ///expiresAt,
    ///);

    return User.fromJson(userJson);
  }

  Future<User> getCurrentUser() async {
    final json = await _authApi.getCurrentUser();
    return User.fromJson(json);
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
    }
    await _secureStorage.delete(_tokenKey);
    await _secureStorage.delete(_tokenExpiryKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(_tokenKey);
    if (token == null || token.isEmpty) return false;

    final expiresAtRaw = await _secureStorage.read(_tokenExpiryKey);
    if (expiresAtRaw == null) return true; // no expiry stored, assume valid

    final expiresAt = DateTime.tryParse(expiresAtRaw);
    if (expiresAt == null) return true;

    return DateTime.now().isBefore(expiresAt);
  }
}
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(secureStorageProvider),
  );
});