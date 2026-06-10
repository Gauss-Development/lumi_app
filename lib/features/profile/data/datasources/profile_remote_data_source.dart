import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

import 'package:lumi/core/network/appwrite_client.dart';
import 'package:lumi/features/profile/data/models/user_profile_model.dart';
import 'package:lumi/features/profile/domain/entities/user_profile.dart';

const String _databaseId = 'lumi';
const String _usersCollectionId = 'users';

class ProfileRemoteDataSourceException implements Exception {
  const ProfileRemoteDataSourceException(this.message);
  final String message;

  @override
  String toString() => 'ProfileRemoteDataSourceException($message)';
}

abstract class ProfileRemoteDataSource {
  Future<UserProfile?> fetchProfile(String userId);

  Future<UserProfile> upsertProfile(UserProfile profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({TablesDB? tablesDb})
    : _tablesDb = tablesDb ?? TablesDB(client);

  final TablesDB _tablesDb;

  @override
  Future<UserProfile?> fetchProfile(String userId) async {
    try {
      final models.Row row = await _tablesDb.getRow(
        databaseId: _databaseId,
        tableId: _usersCollectionId,
        rowId: userId,
      );
      return _mapRow(userId, row.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        return null;
      }
      throw ProfileRemoteDataSourceException(
        e.message ?? 'Could not load your profile.',
      );
    }
  }

  @override
  Future<UserProfile> upsertProfile(UserProfile profile) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'userId': profile.id,
      'displayName': profile.displayName,
      'avatarStyle': profile.avatarStyle,
      'signatureColorValue': profile.signatureColorValue,
    };

    try {
      await _tablesDb.updateRow(
        databaseId: _databaseId,
        tableId: _usersCollectionId,
        rowId: profile.id,
        data: data,
      );
    } on AppwriteException catch (e) {
      if (e.code != 404) {
        throw ProfileRemoteDataSourceException(
          e.message ?? 'Could not save your profile.',
        );
      }
      await _tablesDb.createRow(
        databaseId: _databaseId,
        tableId: _usersCollectionId,
        rowId: profile.id,
        data: <String, dynamic>{
          ...data,
          'email': '${profile.id}@phone.lumi.app',
          'name': profile.displayName,
          'photoUrl': null,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        },
        permissions: <String>[
          Permission.read(Role.user(profile.id)),
          Permission.update(Role.user(profile.id)),
          Permission.delete(Role.user(profile.id)),
        ],
      );
    }

    return profile;
  }

  UserProfile? _mapRow(String userId, Map<String, dynamic> data) {
    final String displayName = (data['displayName'] as String?)?.trim() ?? '';
    if (displayName.isEmpty) {
      return null;
    }
    return UserProfileModel(
      id: userId,
      displayName: displayName,
      avatarStyle: (data['avatarStyle'] as String?)?.trim().isNotEmpty == true
          ? data['avatarStyle'] as String
          : UserProfile.avatarOptions.first,
      signatureColorValue:
          data['signatureColorValue'] as int? ?? 0xFFFF7D6B,
    );
  }
}
