import 'dart:developer' as developer;
import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/network/appwrite_client.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/entities/invitation.dart';

const String _databaseId = 'lumi';
const String _membersTable = 'circle_members';
const String _invitationsTable = 'invitations';
const String _usersTable = 'users';

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
  final AppwriteException cause;

  String get reason {
    final String message = cause.message ?? cause.type ?? 'unknown error';
    return '$step: $message (HTTP ${cause.code})';
  }

  @override
  String toString() => 'AcceptInvitationStepFailed($reason)';
}

class CircleRemoteDataSource {
  CircleRemoteDataSource({TablesDB? tablesDb, Account? account, Random? random})
    : _tablesDb = tablesDb ?? TablesDB(client),
      _account = account ?? Account(client),
      _random = random ?? Random.secure();

  final TablesDB _tablesDb;
  final Account _account;
  final Random _random;

  Future<_OwnerProfile> _ownerProfile() async {
    final models.User user = await _account.get();
    final _OwnerProfile fallback = _OwnerProfile(
      userId: user.$id,
      displayName: user.name.isNotEmpty
          ? user.name
          : (user.email.split('@').first),
      signatureColorValue: _defaultSignatureColorValue,
    );
    try {
      final models.Row row = await _tablesDb.getRow(
        databaseId: _databaseId,
        tableId: _usersTable,
        rowId: user.$id,
      );
      final Map<String, dynamic> data = row.data;
      return _OwnerProfile(
        userId: user.$id,
        displayName: (data['displayName'] as String?)?.trim().isNotEmpty == true
            ? data['displayName'] as String
            : fallback.displayName,
        signatureColorValue:
            data['signatureColorValue'] as int? ?? fallback.signatureColorValue,
      );
    } on AppwriteException catch (_) {
      return fallback;
    }
  }

  // ----- Members -----

  Future<List<CircleMember>> getMembers() async {
    final _OwnerProfile owner = await _ownerProfile();
    try {
      await _syncAcceptedInvitationsForOwner(owner);
    } on AppwriteException catch (e) {
      developer.log(
        'invite/syncAccepted failed (http=${e.code})',
        name: 'CircleRemoteDataSource',
        error: e,
      );
    }
    final models.RowList result = await _tablesDb.listRows(
      databaseId: _databaseId,
      tableId: _membersTable,
      queries: <String>[Query.equal('ownerUserId', owner.userId)],
    );
    final List<models.Row> rows = result.rows.toList()
      ..sort((a, b) => b.$createdAt.compareTo(a.$createdAt));
    final List<CircleMember> members = <CircleMember>[];
    for (final models.Row row in rows) {
      try {
        members.add(_memberFromRow(row));
      } catch (_) {
        // Skip legacy rows with incompatible data (e.g. pre-redesign status
        // values like "pendingOutbound"). Delete via Appwrite Console if you
        // want them gone.
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
      'mutedUntil': until.toUtc().toIso8601String(),
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
    } on AppwriteException catch (e) {
      if (e.code == 404) {
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
      'paceCount': nextPace.clamp(0, LumiLimits.maxLumisPerPairPerDay),
      'queuedCount': nextQueued,
      'lastInteractionAt': now.toUtc().toIso8601String(),
    });
  }

  // ----- Invitations -----

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
        final models.Row row = await _tablesDb.createRow(
          databaseId: _databaseId,
          tableId: _invitationsTable,
          rowId: code,
          data: <String, dynamic>{
            'inviterUserId': inviter.userId,
            'inviterDisplayName': inviter.displayName,
            'inviterSignatureColorValue': inviter.signatureColorValue,
            'inviteeLabel': inviteeLabel,
            'inviteeRelationshipLabel': inviteeRelationshipLabel,
            'status': InvitationStatus.pending.name,
            'createdAt': now.toIso8601String(),
            'expiresAt': expiresAt.toIso8601String(),
          },
          permissions: <String>[
            // Anyone authenticated can read the row by id (the code) and
            // mark it accepted. The inviter retains delete rights.
            Permission.read(Role.users()),
            Permission.update(Role.users()),
            Permission.delete(Role.user(inviter.userId)),
          ],
        );
        return _invitationFromRow(row);
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          lastError = 'Code collided; retrying.';
          continue;
        }
        rethrow;
      }
    }
    throw StateError(lastError ?? 'Could not allocate an invite code.');
  }

  /// Accepts an invitation by code. Creates two `circle_members` rows
  /// (one in each circle) and marks the invitation as accepted.
  ///
  /// Throws [InviteCodeNotFound], [InviteCodeExpired],
  /// [InviteCodeAlreadyUsed], or [InviteCodeIsOwn]; otherwise wraps the
  /// underlying Appwrite error with the step that failed so the message
  /// surfaces in the UI.
  Future<CircleMember> acceptInvitation(String rawCode) async {
    final String code = rawCode.trim().toUpperCase();
    final _OwnerProfile invitee = await _ownerProfile();

    final models.Row invitationRow;
    try {
      invitationRow = await _tablesDb.getRow(
        databaseId: _databaseId,
        tableId: _invitationsTable,
        rowId: code,
      );
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        throw const InviteCodeNotFound();
      }
      developer.log(
        'invite/getRow failed (code=$code, http=${e.code})',
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

    // Step 1: the invitee writes only their own member row. The inviter-side
    // row is materialized by the inviter's client when it next loads accepted
    // invitations, avoiding cross-user document permission failures.
    late models.Row inviteeOwnedRow;
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
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        inviteeOwnedRow = await _tablesDb.getRow(
          databaseId: _databaseId,
          tableId: _membersTable,
          rowId: inviteeMemberId,
        );
      } else {
        developer.log(
          'invite/createOwnRow failed (http=${e.code})',
          name: 'CircleRemoteDataSource',
          error: e,
        );
        throw AcceptInvitationStepFailed('saving your side of the circle', e);
      }
    }

    // Step 2: record the accepted invite. The inviter can later create their
    // own row from these fields using their own credentials.
    try {
      await _tablesDb.updateRow(
        databaseId: _databaseId,
        tableId: _invitationsTable,
        rowId: code,
        data: <String, dynamic>{
          'status': InvitationStatus.accepted.name,
          'inviteeUserId': invitee.userId,
          'inviteeDisplayName': invitee.displayName,
          'inviteeSignatureColorValue': invitee.signatureColorValue,
          'inviterMemberId': inviterMemberId,
          'inviteeMemberId': inviteeMemberId,
          'acceptedAt': acceptedAt.toIso8601String(),
        },
      );
    } on AppwriteException catch (e) {
      developer.log(
        'invite/markAccepted failed (http=${e.code})',
        name: 'CircleRemoteDataSource',
        error: e,
      );
      throw AcceptInvitationStepFailed('marking the invite accepted', e);
    }

    return _memberFromRow(inviteeOwnedRow);
  }

  Future<void> _syncAcceptedInvitationsForOwner(_OwnerProfile owner) async {
    final models.RowList result;
    try {
      result = await _tablesDb.listRows(
        databaseId: _databaseId,
        tableId: _invitationsTable,
        queries: <String>[
          Query.equal('inviterUserId', owner.userId),
          Query.limit(100),
        ],
      );
    } on AppwriteException catch (e) {
      developer.log(
        'invite/listAccepted failed (http=${e.code})',
        name: 'CircleRemoteDataSource',
        error: e,
      );
      return;
    }

    for (final models.Row row in result.rows) {
      final Invitation invitation;
      try {
        invitation = _invitationFromRow(row);
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
      } on AppwriteException catch (e) {
        developer.log(
          'invite/checkInviterRow failed (code=${invitation.code}, http=${e.code})',
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
          await _tablesDb.updateRow(
            databaseId: _databaseId,
            tableId: _invitationsTable,
            rowId: invitation.code,
            data: <String, dynamic>{'inviterMemberId': inviterMemberId},
          );
        }
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          continue;
        }
        developer.log(
          'invite/syncInviterRow failed (code=${invitation.code}, http=${e.code})',
          name: 'CircleRemoteDataSource',
          error: e,
        );
      }
    }
  }

  // ----- Helpers -----

  Future<CircleMember?> _getMember(String memberId) async {
    try {
      final models.Row row = await _tablesDb.getRow(
        databaseId: _databaseId,
        tableId: _membersTable,
        rowId: memberId,
      );
      return _memberFromRow(row);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> _deleteMemberRow(String memberId) async {
    await _tablesDb.deleteRow(
      databaseId: _databaseId,
      tableId: _membersTable,
      rowId: memberId,
    );
  }

  Future<models.Row> _createMemberRow({
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
      'ownerUserId': ownerUserId,
      'memberUserId': memberUserId,
      'reciprocalMemberId': reciprocalMemberId,
      'invitationCode': invitationCode,
      'displayName': displayName,
      'signatureColorValue': signatureColorValue,
      'status': CircleStatus.active.name,
      'paceCount': 0,
      'queuedCount': 0,
      'mutualConnection': true,
      'subtitle': 'Connected through an invite',
      'createdAt': createdAt,
    };
    if (relationshipLabel != null && relationshipLabel.isNotEmpty) {
      data['relationshipLabel'] = relationshipLabel;
    }
    return _tablesDb.createRow(
      databaseId: _databaseId,
      tableId: _membersTable,
      rowId: rowId,
      data: data,
      permissions: _ownerMemberPermissions(ownerUserId),
    );
  }

  Future<CircleMember?> _patchMember(
    String memberId,
    Map<String, dynamic> data,
  ) async {
    try {
      final models.Row row = await _tablesDb.updateRow(
        databaseId: _databaseId,
        tableId: _membersTable,
        rowId: memberId,
        data: data,
      );
      return _memberFromRow(row);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
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

  CircleMember _memberFromRow(models.Row row) {
    final Map<String, dynamic> data = row.data;
    final dynamic lastInteraction = data['lastInteractionAt'];
    final dynamic mutedUntil = data['mutedUntil'];
    return CircleMember(
      id: row.$id,
      ownerUserId: data['ownerUserId'] as String?,
      memberUserId: data['memberUserId'] as String?,
      reciprocalMemberId: data['reciprocalMemberId'] as String?,
      invitationCode: data['invitationCode'] as String?,
      displayName: data['displayName'] as String? ?? '',
      signatureColorValue:
          data['signatureColorValue'] as int? ?? _defaultSignatureColorValue,
      status: CircleStatus.values.byName(
        data['status'] as String? ?? CircleStatus.active.name,
      ),
      paceCount: data['paceCount'] as int? ?? 0,
      queuedCount: data['queuedCount'] as int? ?? 0,
      mutualConnection: data['mutualConnection'] as bool? ?? false,
      relationshipLabel: data['relationshipLabel'] as String?,
      lastInteractionAt: lastInteraction is String && lastInteraction.isNotEmpty
          ? DateTime.tryParse(lastInteraction)
          : null,
      subtitle: data['subtitle'] as String?,
      mutedUntil: mutedUntil is String && mutedUntil.isNotEmpty
          ? DateTime.tryParse(mutedUntil)
          : null,
    );
  }

  Invitation _invitationFromRow(models.Row row) {
    final Map<String, dynamic> data = row.data;
    return Invitation(
      code: row.$id,
      inviterUserId: data['inviterUserId'] as String? ?? '',
      inviterDisplayName: data['inviterDisplayName'] as String? ?? '',
      inviterSignatureColorValue:
          data['inviterSignatureColorValue'] as int? ??
          _defaultSignatureColorValue,
      inviteeLabel: data['inviteeLabel'] as String? ?? '',
      inviteeRelationshipLabel: data['inviteeRelationshipLabel'] as String?,
      status: InvitationStatus.values.byName(
        data['status'] as String? ?? InvitationStatus.pending.name,
      ),
      createdAt:
          DateTime.tryParse(data['createdAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      expiresAt:
          DateTime.tryParse(data['expiresAt'] as String? ?? '') ??
          DateTime.now().toUtc().add(_invitationLifetime),
      inviteeUserId: data['inviteeUserId'] as String?,
      inviteeDisplayName: data['inviteeDisplayName'] as String?,
      inviteeSignatureColorValue: data['inviteeSignatureColorValue'] as int?,
      inviterMemberId: data['inviterMemberId'] as String?,
      inviteeMemberId: data['inviteeMemberId'] as String?,
      acceptedAt: DateTime.tryParse(data['acceptedAt'] as String? ?? ''),
    );
  }

  List<String> _ownerMemberPermissions(String ownerUserId) {
    return <String>[
      Permission.read(Role.user(ownerUserId)),
      Permission.update(Role.user(ownerUserId)),
      Permission.delete(Role.user(ownerUserId)),
    ];
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
