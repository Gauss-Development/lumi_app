import 'package:lumi/features/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.displayName,
    required super.avatarStyle,
    required super.signatureColorValue,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? 'local-user',
      displayName: json['display_name'] as String? ?? '',
      avatarStyle: json['avatar_style'] as String? ?? UserProfile.avatarOptions.first,
      signatureColorValue: json['signature_color_value'] as int? ?? 0xFFFF7D6B,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      displayName: entity.displayName,
      avatarStyle: entity.avatarStyle,
      signatureColorValue: entity.signatureColorValue,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'display_name': displayName,
      'avatar_style': avatarStyle,
      'signature_color_value': signatureColorValue,
    };
  }
}
