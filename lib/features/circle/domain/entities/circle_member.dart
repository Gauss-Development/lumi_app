import 'package:equatable/equatable.dart';

enum CircleStatus {
  emptySlot,
  pendingOutbound,
  pendingInbound,
  active,
  muted,
  memorial,
}

extension CircleStatusX on CircleStatus {
  bool get canSend => this == CircleStatus.active || this == CircleStatus.muted;

  String get label {
    switch (this) {
      case CircleStatus.emptySlot:
        return 'Open slot';
      case CircleStatus.pendingOutbound:
        return 'Invite pending';
      case CircleStatus.pendingInbound:
        return 'Confirm connection';
      case CircleStatus.active:
        return 'Connected';
      case CircleStatus.muted:
        return 'Muted';
      case CircleStatus.memorial:
        return 'Memorial';
    }
  }
}

class InviteLink extends Equatable {
  const InviteLink({required this.url, required this.expiresAt});

  final String url;
  final DateTime expiresAt;

  @override
  List<Object?> get props => <Object?>[url, expiresAt];
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
<<<<<<< HEAD
=======
    this.relationshipLabel,
    this.lastInteractionAt,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    this.subtitle,
    this.mutedUntil,
  });

  factory CircleMember.pendingOutbound({
    required String id,
    required String displayName,
    required int signatureColorValue,
<<<<<<< HEAD
=======
    String? relationshipLabel,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  }) {
    return CircleMember(
      id: id,
      displayName: displayName,
      signatureColorValue: signatureColorValue,
      status: CircleStatus.pendingOutbound,
      paceCount: 0,
      queuedCount: 0,
      mutualConnection: false,
<<<<<<< HEAD
=======
      relationshipLabel: relationshipLabel,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      subtitle: 'Invite sent · expires in 24h',
    );
  }

  factory CircleMember.fromJson(Map<String, dynamic> json) {
    return CircleMember(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      signatureColorValue: json['signatureColorValue'] as int? ?? 0xFFFF7F7F,
      status: CircleStatus.values.byName(
        json['status'] as String? ?? CircleStatus.pendingOutbound.name,
      ),
      paceCount: json['paceCount'] as int? ?? 0,
      queuedCount: json['queuedCount'] as int? ?? 0,
      mutualConnection: json['mutualConnection'] as bool? ?? false,
<<<<<<< HEAD
=======
      relationshipLabel: json['relationshipLabel'] as String?,
      lastInteractionAt: json['lastInteractionAt'] == null
          ? null
          : DateTime.tryParse(json['lastInteractionAt'] as String),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      subtitle: json['subtitle'] as String?,
      mutedUntil: json['mutedUntil'] == null
          ? null
          : DateTime.tryParse(json['mutedUntil'] as String),
    );
  }

  final String id;
  final String displayName;
  final int signatureColorValue;
  final CircleStatus status;
  final int paceCount;
  final int queuedCount;
  final bool mutualConnection;
<<<<<<< HEAD
=======
  final String? relationshipLabel;
  final DateTime? lastInteractionAt;
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
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
<<<<<<< HEAD
=======
    String? relationshipLabel,
    DateTime? lastInteractionAt,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
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
<<<<<<< HEAD
=======
      relationshipLabel: relationshipLabel ?? this.relationshipLabel,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      subtitle: subtitle ?? this.subtitle,
      mutedUntil: mutedUntil ?? this.mutedUntil,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'signatureColorValue': signatureColorValue,
      'status': status.name,
      'paceCount': paceCount,
      'queuedCount': queuedCount,
      'mutualConnection': mutualConnection,
<<<<<<< HEAD
=======
      'relationshipLabel': relationshipLabel,
      'lastInteractionAt': lastInteractionAt?.toIso8601String(),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      'subtitle': subtitle,
      'mutedUntil': mutedUntil?.toIso8601String(),
    };
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
<<<<<<< HEAD
=======
    relationshipLabel,
    lastInteractionAt,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    subtitle,
    mutedUntil,
  ];
}
