import 'package:equatable/equatable.dart';

class PresenceSession extends Equatable {
  const PresenceSession({required this.userId, required this.lastOpenedAt});

  final String userId;
  final DateTime lastOpenedAt;

  @override
  List<Object?> get props => [userId, lastOpenedAt];
}

class TogetherMoment extends Equatable {
  const TogetherMoment({
    required this.memberId,
    required this.memberName,
    required this.colorValue,
    required this.detectedAt,
  });

  final String memberId;
  final String memberName;
  final int colorValue;
  final DateTime detectedAt;

  @override
  List<Object?> get props => [memberId, memberName, colorValue, detectedAt];
}
