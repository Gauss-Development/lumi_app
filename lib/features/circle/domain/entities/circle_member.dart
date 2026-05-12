import 'package:equatable/equatable.dart';

enum CircleStatus { active, muted, memorial }

extension CircleStatusX on CircleStatus {
  bool get canSend => this == CircleStatus.active || this == CircleStatus.muted;

  String get label {
    switch (this) {
      case CircleStatus.active:
        return 'Connected';
      case CircleStatus.muted:
        return 'Muted';
      case CircleStatus.memorial:
        return 'Memorial';
    }
  }
}

class CircleMember extends Equatable {
  const CircleMember({
    required this.id,
    required this.displayName,
    required this.signatureColorValue,
    required this.status,
    required this.paceCount,
    required this.queuedCount,
    required this.mutualConnection,
    this.ownerUserId,
    this.memberUserId,
    this.reciprocalMemberId,
    this.invitationCode,
    this.relationshipLabel,
    this.lastInteractionAt,
    this.subtitle,
    this.mutedUntil,
  });

  final String id;
  final String displayName;
  final int signatureColorValue;
  final CircleStatus status;
  final int paceCount;
  final int queuedCount;
  final bool mutualConnection;
  final String? ownerUserId;
  final String? memberUserId;
  final String? reciprocalMemberId;
  final String? invitationCode;
  final String? relationshipLabel;
  final DateTime? lastInteractionAt;
  final String? subtitle;
  final DateTime? mutedUntil;

  bool get isActive => status == CircleStatus.active;

  bool get isMuted =>
      status == CircleStatus.muted &&
      mutedUntil != null &&
      mutedUntil!.isAfter(DateTime.now());

  bool get canSend => status.canSend;

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return 'L';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  CircleMember copyWith({
    String? id,
    String? displayName,
    int? signatureColorValue,
    CircleStatus? status,
    int? paceCount,
    int? queuedCount,
    bool? mutualConnection,
    String? ownerUserId,
    String? memberUserId,
    String? reciprocalMemberId,
    String? invitationCode,
    String? relationshipLabel,
    DateTime? lastInteractionAt,
    String? subtitle,
    DateTime? mutedUntil,
  }) {
    return CircleMember(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      signatureColorValue: signatureColorValue ?? this.signatureColorValue,
      status: status ?? this.status,
      paceCount: paceCount ?? this.paceCount,
      queuedCount: queuedCount ?? this.queuedCount,
      mutualConnection: mutualConnection ?? this.mutualConnection,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      memberUserId: memberUserId ?? this.memberUserId,
      reciprocalMemberId: reciprocalMemberId ?? this.reciprocalMemberId,
      invitationCode: invitationCode ?? this.invitationCode,
      relationshipLabel: relationshipLabel ?? this.relationshipLabel,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      subtitle: subtitle ?? this.subtitle,
      mutedUntil: mutedUntil ?? this.mutedUntil,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    displayName,
    signatureColorValue,
    status,
    paceCount,
    queuedCount,
    mutualConnection,
    ownerUserId,
    memberUserId,
    reciprocalMemberId,
    invitationCode,
    relationshipLabel,
    lastInteractionAt,
    subtitle,
    mutedUntil,
  ];
}
