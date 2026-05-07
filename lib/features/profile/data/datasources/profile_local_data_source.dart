import 'dart:convert';

import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/profile/data/models/user_profile_model.dart';

class ProfileLocalDataSource {
  ProfileLocalDataSource(this._preferencesService);

  final PreferencesService _preferencesService;

  static const String _profileKey = 'profile.user';

  Future<UserProfileModel?> getProfile() async {
    final String? raw = _preferencesService.readString(_profileKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return UserProfileModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfileModel profile) async {
    await _preferencesService.writeString(
      _profileKey,
      jsonEncode(profile.toJson()),
    );
  }
}
