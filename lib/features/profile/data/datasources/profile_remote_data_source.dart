import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/network/supabase_client.dart';
import 'package:lumi/core/network/supabase_errors.dart';
import 'package:lumi/features/profile/data/models/user_profile_model.dart';
import 'package:lumi/features/profile/domain/entities/user_profile.dart';

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
  ProfileRemoteDataSourceImpl({SupabaseClient? client})
    : _client = client ?? supabase;

  final SupabaseClient _client;

  @override
  Future<UserProfile?> fetchProfile(String userId) async {
    try {
      final Map<String, dynamic>? row = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (row == null) {
        return null;
      }
      return _mapRow(userId, row);
    } catch (e) {
      if (isNotFoundError(e)) {
        return null;
      }
      throw ProfileRemoteDataSourceException(
        postgrestMessage(e, 'Could not load your profile.'),
      );
    }
  }

  @override
  Future<UserProfile> upsertProfile(UserProfile profile) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': profile.id,
      'display_name': profile.displayName,
      'avatar_style': profile.avatarStyle,
      'signature_color_value': profile.signatureColorValue,
    };

    try {
      await _client.from('profiles').upsert(<String, dynamic>{
        ...data,
        'email': '${profile.id}@phone.lumi.app',
        'name': profile.displayName,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      throw ProfileRemoteDataSourceException(
        postgrestMessage(e, 'Could not save your profile.'),
      );
    }

    return profile;
  }

  UserProfile? _mapRow(String userId, Map<String, dynamic> data) {
    final String displayName = (data['display_name'] as String?)?.trim() ?? '';
    if (displayName.isEmpty) {
      return null;
    }
    return UserProfileModel(
      id: userId,
      displayName: displayName,
      avatarStyle: (data['avatar_style'] as String?)?.trim().isNotEmpty == true
          ? data['avatar_style'] as String
          : UserProfile.avatarOptions.first,
      signatureColorValue:
          data['signature_color_value'] as int? ?? 0xFFFF7D6B,
    );
  }
}
