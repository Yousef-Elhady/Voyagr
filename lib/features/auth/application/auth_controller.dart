import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_travel/core/network/api_exception.dart';
import 'package:ai_travel/features/auth/data/auth_repository.dart';
import 'auth_state.dart';

/// The single source of truth for "who is logged in right now" across
/// the whole app. Screens (login, signup, profile, the router's redirect
/// logic) all read from this instead of talking to AuthRepository
/// directly.
///
/// Unlike the reference you found, this controller does NOT call Dio,
/// SharedPreferences, or parse JSON itself — it only calls methods on
/// AuthRepository, which already knows how to talk to AuthApi and
/// SecureStorage. That's the whole point of the layers: this file stays
/// thin and UI-facing, all the "how do we actually fetch/store this"
/// logic lives one layer down.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // build() must return synchronously, so we can't await the session
    // check here. We kick it off in the background and let it update
    // `state` once it resolves — the UI will rebuild automatically
    // when that happens, same as any other state change.
    _restoreSession();
    return const AuthStateInitial();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  // ── Startup: restore session from saved token ─────────────
  Future<void> _restoreSession() async {
    final isLoggedIn = await _repo.isLoggedIn();
    if (!isLoggedIn) {
      state = const AuthStateUnauthenticated();
      return;
    }

    try {
      final user = await _repo.getCurrentUser();
      state = AuthStateAuthenticated(user);
    } catch (_) {
      // Stored token exists but is invalid/expired/rejected by the
      // backend — clear it and treat the user as logged out rather
      // than getting stuck.
      await _repo.logout();
      state = const AuthStateUnauthenticated();
    }
  }

  // ── Register ──────────────────────────────────────────────
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthStateLoading();
    try {
      await _repo.register(
        name: name,
        email: email,
        password: password,
      );
      // Reminder: register does NOT return a token (see auth_repository.dart).
      // We deliberately do not auto-authenticate here. Instead we log
      // the user in immediately after with the same credentials, which
      // gives a normal "sign up → you're in" experience while keeping
      // register() and login() cleanly separate at the repository level.
      await login(email: email, password: password);
    } catch (e) {
      state = AuthStateError(_readableError(e));
    }
  }

  // ── Login ─────────────────────────────────────────────────
  Future<void> login({required String email, required String password}) async {
    state = const AuthStateLoading();
    try {
      final user = await _repo.login(email: email, password: password);
      state = AuthStateAuthenticated(user);
    } catch (e) {
      state = AuthStateError(_readableError(e));
    }
  }

  // ── Logout ────────────────────────────────────────────────
  Future<void> logout() async {
    state = const AuthStateLoading();
    await _repo.logout();
    state = const AuthStateUnauthenticated();
  }

  // ── Helpers ───────────────────────────────────────────────
  // Narrows whatever error came out of the repository into a short
  // string the UI can show directly. ApiException is expected to come
  // from api_client.dart's interceptor (see earlier files); anything
  // else (e.g. no internet) falls back to a generic message.
  String _readableError(Object e) {
    final exception = ApiException.from(e);
    return exception.message;
  }
}

final authControllerProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);