import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart' as models;

import 'package:lumi/core/network/appwrite_client.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';

const String _databaseId = 'lumi';
const String _usersCollectionId = 'users';
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

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({Account? account, TablesDB? tablesDb})
    : _account = account ?? Account(client),
      _tablesDb = tablesDb ?? TablesDB(client);

  final Account _account;
  final TablesDB _tablesDb;

  @override
  Future<AuthSession?> getCurrentSession() async {
    try {
      final models.User user = await _account.get();
      await _ensureUserDocument(user);
      return _mapUser(user);
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        return null;
      }
      throw AuthDataSourceException(e.message ?? 'Could not load your session.');
    }
  }

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final models.User user = await _account.get();
      await _ensureUserDocument(user);
      return _mapUser(user);
    } on AppwriteException catch (e) {
      throw AuthDataSourceException(e.message ?? 'Sign-in failed.');
    }
  }

  @override
  Future<AuthSession> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final models.User user = await _account.get();
      await _ensureUserDocument(user);
      return _mapUser(user);
    } on AppwriteException catch (e) {
      throw AuthDataSourceException(e.message ?? 'Sign-up failed.');
    }
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    try {
      await _account.createOAuth2Session(provider: OAuthProvider.google);
      final models.User user = await _account.get();
      await _ensureUserDocument(user);
      return _mapUser(user);
    } on AppwriteException catch (e) {
      throw AuthDataSourceException(e.message ?? 'Google sign-in failed.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        return;
      }
      throw AuthDataSourceException(e.message ?? 'Sign-out failed.');
    }
  }

  Future<void> _ensureUserDocument(models.User user) async {
    try {
      await _tablesDb.createRow(
        databaseId: _databaseId,
        tableId: _usersCollectionId,
        rowId: user.$id,
        data: <String, dynamic>{
          'userId': user.$id,
          'email': user.email,
          'name': user.name,
          'displayName': user.name,
          'avatarStyle': _defaultAvatarStyle,
          'signatureColorValue': _defaultSignatureColorValue,
          'photoUrl': null,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        },
        permissions: <String>[
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
          Permission.delete(Role.user(user.$id)),
        ],
      );
    } on AppwriteException catch (_) {
      // 409 = row already exists; other errors should not block auth.
    }
  }

  AuthSession _mapUser(models.User user) {
    final dynamic prefsRaw = user.prefs.data['avatarUrl'];
    return AuthSession(
      userId: user.$id,
      email: user.email,
      name: user.name,
      photoUrl: prefsRaw is String && prefsRaw.isNotEmpty ? prefsRaw : null,
    );
  }
}
