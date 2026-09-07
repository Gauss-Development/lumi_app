import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/network/supabase_client.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';

const String _defaultAvatarStyle = 'avatar_0';
const int _defaultSignatureColorValue = 0xFFFF7D6B;

class AuthDataSourceException implements Exception {
  const AuthDataSourceException(this.message);
  final String message;

  @override
  String toString() => 'AuthDataSourceException($message)';
}

abstract class AuthRemoteDataSource {
  Future<AuthSession?> getCurrentSession();

  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthSession> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthSession> signInWithGoogle();

  Future<AuthSession> signInWithApple();

  Future<void> signOut();

  Future<void> deleteAccount();

  Future<void> requestPasswordReset({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({SupabaseClient? client})
    : _client = client ?? supabase;

  final SupabaseClient _client;

  @override
  Future<AuthSession?> getCurrentSession() async {
    final Session? session = _client.auth.currentSession;
    final User? user = session?.user;
    if (user == null) {
      return null;
    }
    await _ensureProfile(user);
    return _mapUser(user);
  }

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final User? user = response.user;
      if (user == null) {
        throw const AuthDataSourceException('Sign-in failed.');
      }
      await _ensureProfile(user);
      return _mapUser(user);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<AuthSession> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{'name': name},
      );
      final User? user = response.user;
      if (user == null) {
        throw const AuthDataSourceException('Sign-up failed.');
      }
      if (response.session == null) {
        throw const AuthDataSourceException(
          'Check your email to confirm your account.',
        );
      }
      await _ensureProfile(user, displayName: name);
      return _mapUser(user);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<AuthSession> signInWithGoogle() {
    return _signInWithOAuth(
      OAuthProvider.google,
      'Google sign-in did not finish.',
    );
  }

  @override
  Future<AuthSession> signInWithApple() {
    return _signInWithOAuth(
      OAuthProvider.apple,
      'Apple sign-in did not finish.',
    );
  }

  Future<AuthSession> _signInWithOAuth(
    OAuthProvider provider,
    String unfinishedMessage,
  ) async {
    try {
      await _client.auth.signInWithOAuth(
        provider,
        redirectTo: EnvironmentConfig.instance.oauthRedirectUrl,
      );
      final User? user = _client.auth.currentUser;
      if (user == null) {
        throw AuthDataSourceException(unfinishedMessage);
      }
      await _ensureProfile(user);
      return _mapUser(user);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final FunctionResponse response = await _client.functions.invoke(
        'delete_account',
      );
      if (response.status < 200 || response.status >= 300) {
        throw const AuthDataSourceException(
          'We could not delete your account right now. Please try again.',
        );
      }
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      if (e is AuthDataSourceException) {
        rethrow;
      }
      throw const AuthDataSourceException(
        'We could not delete your account right now. Please try again.',
      );
    }

    try {
      await _client.auth.signOut();
    } catch (_) {
      // The session is usually already invalidated by the account deletion.
    }
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: EnvironmentConfig.instance.oauthRedirectUrl,
      );
    } on AuthException catch (e) {
      throw AuthDataSourceException(
        e.message.isNotEmpty
            ? e.message
            : 'Could not send the reset email. Try again.',
      );
    }
  }

  Future<void> _ensureProfile(User user, {String? displayName}) async {
    try {
      await _client.from('profiles').upsert(<String, dynamic>{
        'id': user.id,
        'email': _resolvedEmail(user),
        'phone': user.phone,
        'name': displayName ?? user.userMetadata?['name'] ?? '',
        'display_name': displayName ??
            (user.userMetadata?['name'] as String?) ??
            user.email?.split('@').first ??
            'Lumi',
        'avatar_style': _defaultAvatarStyle,
        'signature_color_value': _defaultSignatureColorValue,
        'photo_url': user.userMetadata?['avatar_url'],
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {
      // Profile bootstrap must not block auth.
    }
  }

  String _resolvedEmail(User user) {
    if (user.email != null && user.email!.trim().isNotEmpty) {
      return user.email!;
    }
    return '${user.id}@phone.lumi.app';
  }

  AuthSession _mapUser(User user) {
    final String? avatarUrl = user.userMetadata?['avatar_url'] as String?;
    return AuthSession(
      userId: user.id,
      email: _resolvedEmail(user),
      phone: user.phone ?? '',
      name: (user.userMetadata?['name'] as String?) ?? user.email ?? '',
      photoUrl: avatarUrl != null && avatarUrl.isNotEmpty ? avatarUrl : null,
    );
  }
}
