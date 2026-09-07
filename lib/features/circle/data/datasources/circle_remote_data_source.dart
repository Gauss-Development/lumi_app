import 'dart:developer' as developer;
import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/network/supabase_client.dart';
import 'package:lumi/core/network/supabase_errors.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/entities/invitation.dart';

const String _codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const int _codeLength = 10;
const Duration _invitationLifetime = Duration(days: 7);

const int _defaultSignatureColorValue = 0xFFFF7D6B;

class InviteCodeNotFound implements Exception {
  const InviteCodeNotFound();
}

class InviteCodeExpired implements Exception {
  const InviteCodeExpired();
}

class InviteCodeAlreadyUsed implements Exception {
  const InviteCodeAlreadyUsed();
}

class InviteCodeIsOwn implements Exception {
  const InviteCodeIsOwn();
}

class AcceptInvitationStepFailed implements Exception {
  const AcceptInvitationStepFailed(this.step, this.cause);
  final String step;
  final PostgrestException cause;

  String get reason {
    final String message = cause.message.isNotEmpty ? cause.message : 'unknown error';
    return '$step: $message';
  }

  @override
  String toString() => 'AcceptInvitationStepFailed($reason)';
}

class CircleRemoteDataSource {
  CircleRemoteDataSource({SupabaseClient? client, Random? random})
    : _client = client ?? supabase,
      _random = random ?? Random.secure();

  final SupabaseClient _client;
  final Random _random;

  Future<_OwnerProfile> _ownerProfile() async {
    final User user = _client.auth.currentUser!;
    final _OwnerProfile fallback = _OwnerProfile(
      userId: user.id,
      displayName: _displayNameFromUser(user),
      signatureColorValue: _defaultSignatureColorValue,
    );
    try {
      final Map<String, dynamic>? row = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (row == null) {
        return fallback;
      }
      return _OwnerProfile(
        userId: user.id,
        displayName: (row['display_name'] as String?)?.trim().isNotEmpty == true
            ? row['display_name'] as String
            : fallback.displayName,
        signatureColorValue:
            row['signature_color_value'] as int? ?? fallback.signatureColorValue,
      );
    } catch (_) {
      return fallback;
    }
  }

  String _displayNameFromUser(User user) {
    final String? metaName = user.userMetadata?['name'] as String?;
    if (metaName != null && metaName.isNotEmpty) {
      return metaName;
    }
    if (user.email != null && user.email!.isNotEmpty) {
      return user.email!.split('@').first;
    }
    return 'Lumi';
  }

  Future<List<CircleMember>> getMembers() async {
    final _OwnerProfile owner = await _ownerProfile();
    try {
      await _syncAcceptedInvitationsForOwner(owner);
    } on PostgrestException catch (e) {
      developer.log(
        'invite/syncAccepted failed',
        name: 'CircleRemoteDataSource',
        error: e,
      );
    }
    final List<dynamic> rows = await _client
        .from('circle_members')
        .select()
        .eq('owner_user_id', owner.userId)
        .order('created_at', ascending: false);
    final List<CircleMember> members = <CircleMember>[];
    for (final dynamic row in rows) {
      try {
        members.add(_memberFromRow(row as Map<String, dynamic>));
      } catch (_) {
        // Skip legacy rows with incompatible data.
      }
    }
    return members;
  }

  Future<CircleMember?> muteMember({
    required String memberId,
    required DateTime until,
  }) {
    return _patchMember(memberId, <String, dynamic>{
      'status': CircleStatus.muted.name,
      'muted_until': until.toUtc().toIso8601String(),
      'subtitle': 'Muted for one week',
    });
  }

  Future<CircleMember?> memorializeMember(String memberId) {
    return _patchMember(memberId, <String, dynamic>{
      'status': CircleStatus.memorial.name,
      'subtitle': 'Kept in your circle for the long arc',
    });
  }

  Future<bool> removeMember(String memberId) async {
    final CircleMember? existing = await _getMember(memberId);
    if (existing == null) {
      return false;
    }

    try {
      final String? reciprocalMemberId = existing.reciprocalMemberId;
      if (reciprocalMemberId != null && reciprocalMemberId.isNotEmpty) {
        await _deleteMemberRow(reciprocalMemberId);
      }
      await _deleteMemberRow(memberId);
      return true;
    } on PostgrestException catch (e) {
      if (isNotFoundError(e)) {
        return false;
      }
      rethrow;
    }
  }

  Future<void> touchMemberActivity({
    required String memberId,
    required bool queued,
  }) async {
    final CircleMember? existing = await _getMember(memberId);
    if (existing == null) {
      return;
    }
    final DateTime now = DateTime.now();
    final bool resetWindow =
        existing.lastInteractionAt == null ||
        now.difference(existing.lastInteractionAt!).inHours >= 24;
    final int nextPace = (resetWindow ? 0 : existing.paceCount) + 1;
    final int nextQueued = queued
        ? existing.queuedCount + 1
        : existing.queuedCount.clamp(0, LumiLimits.maxLumisPerPairPerDay);

    await _patchMember(memberId, <String, dynamic>{
      'pace_count': nextPace.clamp(0, LumiLimits.maxLumisPerPairPerDay),
      'queued_count': nextQueued,
      'last_interaction_at': now.toUtc().toIso8601String(),
    });
  }

  Future<Invitation> createInvitation({
    required String inviteeLabel,
    String? inviteeRelationshipLabel,
  }) async {
    final _OwnerProfile inviter = await _ownerProfile();
    final DateTime now = DateTime.now().toUtc();
    final DateTime expiresAt = now.add(_invitationLifetime);

    String? lastError;
    for (int attempt = 0; attempt < 4; attempt++) {
      final String code = _generateCode();
      try {
        final Map<String, dynamic> row = await _client
            .from('invitations')
            .insert(<String, dynamic>{
              'code': code,
              'inviter_user_id': inviter.userId,
              'inviter_display_name': inviter.displayName,
              'inviter_signature_color_value': inviter.signatureColorValue,
              'invitee_label': inviteeLabel,
              'invitee_relationship_label': inviteeRelationshipLabel,
              'status': InvitationStatus.pending.name,
              'created_at': now.toIso8601String(),
              'expires_at': expiresAt.toIso8601String(),
            })
            .select()
            .single();
        return _invitationFromRow(row);
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          lastError = 'Code collided; retrying.';
          continue;
        }
        rethrow;
      }
    }
    throw StateError(lastError ?? 'Could not allocate an invite code.');
  }

  Future<CircleMember> acceptInvitation(String rawCode) async {
    final String code = rawCode.trim().toUpperCase();
    final _OwnerProfile invitee = await _ownerProfile();

    final Map<String, dynamic> invitationRow;
    try {
      final Map<String, dynamic>? row = await _client
          .from('invitations')
          .select()
          .eq('code', code)
          .maybeSingle();
      if (row == null) {
        throw const InviteCodeNotFound();
      }
      invitationRow = row;
    } on PostgrestException catch (e) {
      developer.log(
        'invite/getRow failed (code=$code)',
        name: 'CircleRemoteDataSource',
        error: e,
      );
      throw AcceptInvitationStepFailed('reading invite', e);
    }

    final Invitation invitation = _invitationFromRow(invitationRow);

    if (invitation.status != InvitationStatus.pending) {
      throw const InviteCodeAlreadyUsed();
    }
    if (invitation.isExpired) {
      throw const InviteCodeExpired();
    }
    if (invitation.inviterUserId == invitee.userId) {
      throw const InviteCodeIsOwn();
    }

    final DateTime acceptedAt = DateTime.now().toUtc();
    final String createdAt = acceptedAt.toIso8601String();
    final String inviterMemberId = _inviterMemberIdForCode(code);
    final String inviteeMemberId = _inviteeMemberIdForCode(code);

    late Map<String, dynamic> inviteeOwnedRow;
    try {
      inviteeOwnedRow = await _createMemberRow(
        rowId: inviteeMemberId,
        ownerUserId: invitee.userId,
        memberUserId: invitation.inviterUserId,
        reciprocalMemberId: inviterMemberId,
        invitationCode: code,
        displayName: invitation.inviterDisplayName,
        signatureColorValue: invitation.inviterSignatureColorValue,
        createdAt: createdAt,
      );
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        inviteeOwnedRow = await _client
            .from('circle_members')
            .select()
            .eq('id', inviteeMemberId)
            .single();
      } else {
        developer.log(
          'invite/createOwnRow failed',
          name: 'CircleRemoteDataSource',
          error: e,
        );
        throw AcceptInvitationStepFailed('saving your side of the circle', e);
      }
    }

    try {
      await _client.from('invitations').update(<String, dynamic>{
        'status': InvitationStatus.accepted.name,
        'invitee_user_id': invitee.userId,
        'invitee_display_name': invitee.displayName,
        'invitee_signature_color_value': invitee.signatureColorValue,
        'inviter_member_id': inviterMemberId,
        'invitee_member_id': inviteeMemberId,
        'accepted_at': acceptedAt.toIso8601String(),
      }).eq('code', code);
    } on PostgrestException catch (e) {
      developer.log(
        'invite/markAccepted failed',
        name: 'CircleRemoteDataSource',
        error: e,
      );
      throw AcceptInvitationStepFailed('marking the invite accepted', e);
    }

    return _memberFromRow(inviteeOwnedRow);
  }

  Future<void> _syncAcceptedInvitationsForOwner(_OwnerProfile owner) async {
    List<dynamic> rows;
    try {
      rows = await _client
          .from('invitations')
          .select()
          .eq('inviter_user_id', owner.userId)
          .limit(100);
    } on PostgrestException catch (e) {
      developer.log(
        'invite/listAccepted failed',
        name: 'CircleRemoteDataSource',
        error: e,
      );
      return;
    }

    for (final dynamic row in rows) {
      final Invitation invitation;
      try {
        invitation = _invitationFromRow(row as Map<String, dynamic>);
      } catch (_) {
        continue;
      }
      if (invitation.status != InvitationStatus.accepted ||
          invitation.inviteeUserId == null ||
          invitation.inviteeUserId!.isEmpty ||
          invitation.inviteeMemberId == null ||
          invitation.inviteeMemberId!.isEmpty) {
        continue;
      }

      final String inviterMemberId =
          invitation.inviterMemberId ??
          _inviterMemberIdForCode(invitation.code);
      final CircleMember? existing;
      try {
        existing = await _getMember(inviterMemberId);
      } on PostgrestException catch (e) {
        developer.log(
          'invite/checkInviterRow failed (code=${invitation.code})',
          name: 'CircleRemoteDataSource',
          error: e,
        );
        continue;
      }
      if (existing != null) {
        continue;
      }

      try {
        await _createMemberRow(
          rowId: inviterMemberId,
          ownerUserId: owner.userId,
          memberUserId: invitation.inviteeUserId!,
          reciprocalMemberId: invitation.inviteeMemberId,
          invitationCode: invitation.code,
          displayName: invitation.inviteeDisplayName?.trim().isNotEmpty == true
              ? invitation.inviteeDisplayName!
              : invitation.inviteeLabel,
          signatureColorValue:
              invitation.inviteeSignatureColorValue ??
              _defaultSignatureColorValue,
          relationshipLabel: invitation.inviteeRelationshipLabel,
          createdAt: (invitation.acceptedAt ?? DateTime.now().toUtc())
              .toUtc()
              .toIso8601String(),
        );
        if (invitation.inviterMemberId == null ||
            invitation.inviterMemberId!.isEmpty) {
          await _client.from('invitations').update(<String, dynamic>{
            'inviter_member_id': inviterMemberId,
          }).eq('code', invitation.code);
        }
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          continue;
        }
        developer.log(
          'invite/syncInviterRow failed (code=${invitation.code})',
          name: 'CircleRemoteDataSource',
          error: e,
        );
      }
    }
  }

  Future<CircleMember?> _getMember(String memberId) async {
    try {
      final Map<String, dynamic> row = await _client
          .from('circle_members')
          .select()
          .eq('id', memberId)
          .single();
      return _memberFromRow(row);
    } on PostgrestException catch (e) {
      if (isNotFoundError(e)) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> _deleteMemberRow(String memberId) async {
    await _client.from('circle_members').delete().eq('id', memberId);
  }

  Future<Map<String, dynamic>> _createMemberRow({
    required String rowId,
    required String ownerUserId,
    required String memberUserId,
    required String? reciprocalMemberId,
    required String invitationCode,
    required String displayName,
    required int signatureColorValue,
    required String createdAt,
    String? relationshipLabel,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': rowId,
      'owner_user_id': ownerUserId,
      'member_user_id': memberUserId,
      'reciprocal_member_id': reciprocalMemberId,
      'invitation_code': invitationCode,
      'display_name': displayName,
      'signature_color_value': signatureColorValue,
      'status': CircleStatus.active.name,
      'pace_count': 0,
      'queued_count': 0,
      'mutual_connection': true,
      'subtitle': 'Connected through an invite',
      'created_at': createdAt,
    };
    if (relationshipLabel != null && relationshipLabel.isNotEmpty) {
      data['relationship_label'] = relationshipLabel;
    }
    return _client.from('circle_members').insert(data).select().single();
  }

  Future<CircleMember?> _patchMember(
    String memberId,
    Map<String, dynamic> data,
  ) async {
    try {
      final Map<String, dynamic> row = await _client
          .from('circle_members')
          .update(data)
          .eq('id', memberId)
          .select()
          .single();
      return _memberFromRow(row);
    } on PostgrestException catch (e) {
      if (isNotFoundError(e)) {
        return null;
      }
      rethrow;
    }
  }

  String _generateCode() {
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < _codeLength; i++) {
      buffer.write(_codeAlphabet[_random.nextInt(_codeAlphabet.length)]);
    }
    return buffer.toString();
  }

  CircleMember _memberFromRow(Map<String, dynamic> data) {
    final dynamic lastInteraction = data['last_interaction_at'];
    final dynamic mutedUntil = data['muted_until'];
    return CircleMember(
      id: data['id'] as String,
      ownerUserId: data['owner_user_id'] as String?,
      memberUserId: data['member_user_id'] as String?,
      reciprocalMemberId: data['reciprocal_member_id'] as String?,
      invitationCode: data['invitation_code'] as String?,
      displayName: data['display_name'] as String? ?? '',
      signatureColorValue:
          data['signature_color_value'] as int? ?? _defaultSignatureColorValue,
      status: CircleStatus.values.byName(
        data['status'] as String? ?? CircleStatus.active.name,
      ),
      paceCount: data['pace_count'] as int? ?? 0,
      queuedCount: data['queued_count'] as int? ?? 0,
      mutualConnection: data['mutual_connection'] as bool? ?? false,
      relationshipLabel: data['relationship_label'] as String?,
      lastInteractionAt: lastInteraction is String && lastInteraction.isNotEmpty
          ? DateTime.tryParse(lastInteraction)
          : null,
      subtitle: data['subtitle'] as String?,
      mutedUntil: mutedUntil is String && mutedUntil.isNotEmpty
          ? DateTime.tryParse(mutedUntil)
          : null,
    );
  }

  Invitation _invitationFromRow(Map<String, dynamic> data) {
    return Invitation(
      code: data['code'] as String,
      inviterUserId: data['inviter_user_id'] as String? ?? '',
      inviterDisplayName: data['inviter_display_name'] as String? ?? '',
      inviterSignatureColorValue:
          data['inviter_signature_color_value'] as int? ??
          _defaultSignatureColorValue,
      inviteeLabel: data['invitee_label'] as String? ?? '',
      inviteeRelationshipLabel: data['invitee_relationship_label'] as String?,
      status: InvitationStatus.values.byName(
        data['status'] as String? ?? InvitationStatus.pending.name,
      ),
      createdAt:
          DateTime.tryParse(data['created_at'] as String? ?? '') ??
          DateTime.now().toUtc(),
      expiresAt:
          DateTime.tryParse(data['expires_at'] as String? ?? '') ??
          DateTime.now().toUtc().add(_invitationLifetime),
      inviteeUserId: data['invitee_user_id'] as String?,
      inviteeDisplayName: data['invitee_display_name'] as String?,
      inviteeSignatureColorValue: data['invitee_signature_color_value'] as int?,
      inviterMemberId: data['inviter_member_id'] as String?,
      inviteeMemberId: data['invitee_member_id'] as String?,
      acceptedAt: DateTime.tryParse(data['accepted_at'] as String? ?? ''),
    );
  }

  String _inviterMemberIdForCode(String code) => 'inv_${code.toLowerCase()}';

  String _inviteeMemberIdForCode(String code) => 'acc_${code.toLowerCase()}';
}

class _OwnerProfile {
  const _OwnerProfile({
    required this.userId,
    required this.displayName,
    required this.signatureColorValue,
  });

  final String userId;
  final String displayName;
  final int signatureColorValue;
}
