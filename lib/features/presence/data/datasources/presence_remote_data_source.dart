import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/network/supabase_client.dart';
import 'package:lumi/core/network/supabase_errors.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/presence/domain/entities/presence_session.dart';

class PresenceRemoteDataSourceException implements Exception {
  const PresenceRemoteDataSourceException(this.message);

  final String message;

  @override
  String toString() => 'PresenceRemoteDataSourceException($message)';
}

class PresenceRemoteDataSource {
  PresenceRemoteDataSource({SupabaseClient? client}) : _client = client ?? supabase;

  final SupabaseClient _client;

  Future<PresenceSession> recordHeartbeat(String userId) async {
    final DateTime openedAt = DateTime.now().toUtc();
    try {
      await _client.from('presence_heartbeats').upsert(<String, dynamic>{
        'user_id': userId,
        'last_opened_at': openedAt.toIso8601String(),
      });
    } catch (error) {
      throw PresenceRemoteDataSourceException(
        postgrestMessage(error, 'Could not record your presence.'),
      );
    }
    return PresenceSession(userId: userId, lastOpenedAt: openedAt);
  }

  Future<TogetherMoment?> detectTogetherMoment({
    required String userId,
    required List<CircleMember> members,
    required DateTime now,
  }) async {
    final DateTime cutoff = now.subtract(LumiLimits.togetherMomentWindow);
    final List<CircleMember> connectedMembers = members
        .where(
          (CircleMember member) =>
              member.mutualConnection &&
              member.isActive &&
              member.memberUserId != null &&
              member.memberUserId != userId,
        )
        .toList(growable: false);
    if (connectedMembers.isEmpty) {
      return null;
    }

    final Map<String, CircleMember> memberByUserId =
        <String, CircleMember>{
          for (final CircleMember member in connectedMembers)
            member.memberUserId!: member,
        };
    final List<String> memberUserIds = memberByUserId.keys.toList(growable: false);

    try {
      final List<dynamic> rows = await _client
          .from('presence_heartbeats')
          .select()
          .inFilter('user_id', memberUserIds)
          .gte('last_opened_at', cutoff.toIso8601String())
          .order('last_opened_at', ascending: false)
          .limit(1);
      if (rows.isEmpty) {
        return null;
      }

      final Map<String, dynamic> row = rows.first as Map<String, dynamic>;
      final String memberUserId = row['user_id'] as String;
      final CircleMember? member = memberByUserId[memberUserId];
      if (member == null) {
        return null;
      }

      final DateTime detectedAt = DateTime.parse(
        row['last_opened_at'] as String,
      ).toUtc();

      return TogetherMoment(
        memberId: member.id,
        memberName: member.displayName,
        colorValue: member.signatureColorValue,
        detectedAt: detectedAt,
      );
    } catch (error) {
      throw PresenceRemoteDataSourceException(
        postgrestMessage(error, 'Could not check who is here with you.'),
      );
    }
  }
}
