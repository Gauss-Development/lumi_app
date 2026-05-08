import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.avatarStyle,
    required this.signatureColorValue,
    this.avatarSeed,
  });

  static const List<String> avatarOptions = <String>[
    'avatar_0',
    'avatar_1',
    'avatar_2',
    'avatar_3',
    'avatar_4',
    'avatar_5',
  ];

  final String id;
  final String displayName;
  final String avatarStyle;
  final int signatureColorValue;
  final String? avatarSeed;

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? avatarStyle,
    int? signatureColorValue,
    String? avatarSeed,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarStyle: avatarStyle ?? this.avatarStyle,
      signatureColorValue: signatureColorValue ?? this.signatureColorValue,
      avatarSeed: avatarSeed ?? this.avatarSeed,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    displayName,
    avatarStyle,
    signatureColorValue,
    avatarSeed,
  ];
}
