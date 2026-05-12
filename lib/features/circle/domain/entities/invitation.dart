import 'package:equatable/equatable.dart';

enum InvitationStatus { pending, accepted, expired, cancelled }

class Invitation extends Equatable {
  const Invitation({
    required this.code,
    required this.inviterUserId,
    required this.inviterDisplayName,
    required this.inviterSignatureColorValue,
    required this.inviteeLabel,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.inviteeRelationshipLabel,
    this.inviteeUserId,
    this.inviteeDisplayName,
    this.inviteeSignatureColorValue,
    this.inviterMemberId,
    this.inviteeMemberId,
    this.acceptedAt,
  });

  final String code;
  final String inviterUserId;
  final String inviterDisplayName;
  final int inviterSignatureColorValue;
  final String inviteeLabel;
  final String? inviteeRelationshipLabel;
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? inviteeUserId;
  final String? inviteeDisplayName;
  final int? inviteeSignatureColorValue;
  final String? inviterMemberId;
  final String? inviteeMemberId;
  final DateTime? acceptedAt;

  bool get isExpired =>
      status == InvitationStatus.expired || expiresAt.isBefore(DateTime.now());

  @override
  List<Object?> get props => <Object?>[
    code,
    inviterUserId,
    inviterDisplayName,
    inviterSignatureColorValue,
    inviteeLabel,
    inviteeRelationshipLabel,
    status,
    createdAt,
    expiresAt,
    inviteeUserId,
    inviteeDisplayName,
    inviteeSignatureColorValue,
    inviterMemberId,
    inviteeMemberId,
    acceptedAt,
  ];
}
