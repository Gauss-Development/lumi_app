import 'dart:convert';

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';

class CircleLocalDataSource {
  CircleLocalDataSource(this._preferencesService);

  static const String _membersKey = 'circle_members';

  final PreferencesService _preferencesService;

  Future<List<CircleMember>> getMembers() async {
    final String? raw = _preferencesService.readString(_membersKey);
    if (raw == null || raw.isEmpty) {
      return <CircleMember>[];
    }

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) => CircleMember.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<void> saveMembers(List<CircleMember> members) async {
    await _preferencesService.writeString(
      _membersKey,
      jsonEncode(
        members
            .map((CircleMember member) => member.toJson())
            .toList(growable: false),
      ),
    );
  }

  Future<CircleMember> addInvite({
    required String displayName,
    required int colorValue,
    String? relationshipLabel,
  }) async {
    final List<CircleMember> members = await getMembers();
    final CircleMember invite = CircleMember.pendingOutbound(
      id: 'invite-${DateTime.now().millisecondsSinceEpoch}',
      displayName: displayName,
      signatureColorValue: colorValue,
      relationshipLabel: relationshipLabel,
    );
    final List<CircleMember> updated = <CircleMember>[invite, ...members];
    await saveMembers(updated);
    return invite;
  }

  Future<CircleMember?> activateMember(String memberId) async {
    final List<CircleMember> members = await getMembers();
    CircleMember? activatedMember;
    final List<CircleMember> updated = members
        .map((CircleMember member) {
          if (member.id != memberId) {
            return member;
          }

          activatedMember = member.copyWith(
            status: CircleStatus.active,
            mutualConnection: true,
            subtitle: 'Tap and hold to send your first Lumi',
          );
          return activatedMember!;
        })
        .toList(growable: false);

    await saveMembers(updated);
    return activatedMember;
  }

  Future<CircleMember?> muteMember({
    required String memberId,
    required DateTime until,
  }) async {
    final List<CircleMember> members = await getMembers();
    CircleMember? mutedMember;
    final List<CircleMember> updated = members
        .map((CircleMember member) {
          if (member.id != memberId) {
            return member;
          }

          mutedMember = member.copyWith(
            status: CircleStatus.muted,
            mutedUntil: until,
            subtitle: 'Muted for one week',
          );
          return mutedMember!;
        })
        .toList(growable: false);

    await saveMembers(updated);
    return mutedMember;
  }

  Future<void> touchMemberActivity({
    required String memberId,
    required bool queued,
  }) async {
    final DateTime now = DateTime.now();
    final List<CircleMember> members = await getMembers();
    final List<CircleMember> updated = members
        .map((CircleMember member) {
          if (member.id != memberId) {
            return member;
          }

          final bool resetWindow =
              member.lastInteractionAt == null ||
              now.difference(member.lastInteractionAt!).inHours >= 24;

          final int nextPaceCount =
              (resetWindow ? 0 : member.paceCount) + 1;

          return member.copyWith(
            paceCount: nextPaceCount.clamp(0, LumiLimits.maxLumisPerPairPerDay),
            queuedCount: queued
                ? member.queuedCount + 1
                : member.queuedCount.clamp(0, LumiLimits.maxLumisPerPairPerDay),
            lastInteractionAt: now,
          );
        })
        .toList(growable: false);

    await saveMembers(updated);
  }
}
