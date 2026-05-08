import 'package:flutter/material.dart';

class AppConstants {
  const AppConstants._();

  static const String appName = 'Lumi';
  static const String tagline = 'A little light for someone you love.';
  static const String defaultAvatarId = 'generated_sun';
  static const String defaultInviteBaseUrl = 'https://lumi.family/invite';
  static const Duration demoReactionDelay = Duration(seconds: 4);

  static const List<String> allowedReactions = <String>[
    'heart',
    'smile',
    'hand_on_heart',
    'sun',
    'moon',
  ];

  static const List<String> relationshipSuggestions = <String>[
    'Mom',
    'Dad',
    'Sister',
    'Brother',
    'Grandma',
    'Grandpa',
    'Partner',
    'Child',
    'Friend',
    'Caregiver',
  ];

  static const List<Color> signatureColors = <Color>[
    Color(0xFFFF7F7F),
    Color(0xFFFFB347),
    Color(0xFFFFE082),
    Color(0xFF8FD3FF),
    Color(0xFFCDA4FF),
    Color(0xFF96F2D7),
    Color(0xFFFFA3C7),
    Color(0xFFB39DDB),
    Color(0xFF80CBC4),
    Color(0xFFA5D6A7),
    Color(0xFFFFCC80),
    Color(0xFF90CAF9),
  ];
}
