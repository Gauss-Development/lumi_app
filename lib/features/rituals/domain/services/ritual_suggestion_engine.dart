import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/rituals/domain/entities/ritual_preferences.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';

class RitualSuggestionEngine {
  const RitualSuggestionEngine();

  RitualSuggestion? suggest({
    required RitualPreferences preferences,
    required QuietHours quietHours,
    required List<CircleMember> members,
    required List<Lumi> recentLumis,
    DateTime? now,
  }) {
    final DateTime current = now ?? DateTime.now();
    if (preferences.dismissedUntil?.isAfter(current) == true) {
      return null;
    }
    if (quietHours.isActiveAt(current)) {
      return null;
    }

    final List<CircleMember> sendableMembers = members
        .where((CircleMember member) => member.canSend)
        .toList(growable: false);
    if (sendableMembers.isEmpty) {
      return null;
    }

    final RitualSuggestion? daily = _dailyRitual(
      preferences: preferences,
      members: sendableMembers,
      now: current,
    );
    if (daily != null) {
      return daily;
    }

    if (!preferences.gentleRemindersEnabled) {
      return null;
    }

    final DateTime staleBefore = current.subtract(
      Duration(days: preferences.reminderCadenceDays),
    );
    final List<String> staleMemberIds = sendableMembers
        .where(
          (CircleMember member) =>
              _lastOutgoingAt(member.id, recentLumis)?.isAfter(staleBefore) !=
              true,
        )
        .map((CircleMember member) => member.id)
        .toList(growable: false);

    if (staleMemberIds.isEmpty) {
      return null;
    }

    return RitualSuggestion(
      kind: RitualKind.checkIn,
      title: 'A quiet check-in',
      description: _targetDescription(staleMemberIds.length),
      actionLabel: 'Send light',
      memberIds: staleMemberIds,
    );
  }

  RitualSuggestion? _dailyRitual({
    required RitualPreferences preferences,
    required List<CircleMember> members,
    required DateTime now,
  }) {
    final List<String> memberIds = members
        .map((CircleMember member) => member.id)
        .toList(growable: false);
    if (preferences.morningEnabled &&
        now.hour >= preferences.morningHour &&
        now.hour < preferences.morningHour + 3 &&
        !_wasSentToday(preferences.lastMorningSentAt, now)) {
      return RitualSuggestion(
        kind: RitualKind.morning,
        title: 'Morning light',
        description: _targetDescription(memberIds.length),
        actionLabel: 'Send morning light',
        memberIds: memberIds,
      );
    }

    if (preferences.eveningEnabled &&
        now.hour >= preferences.eveningHour &&
        now.hour < preferences.eveningHour + 3 &&
        !_wasSentToday(preferences.lastEveningSentAt, now)) {
      return RitualSuggestion(
        kind: RitualKind.evening,
        title: 'Good night glow',
        description: _targetDescription(memberIds.length),
        actionLabel: 'Send glow',
        memberIds: memberIds,
      );
    }

    return null;
  }

  DateTime? _lastOutgoingAt(String memberId, List<Lumi> lumis) {
    DateTime? latest;
    for (final Lumi lumi in lumis) {
      if (lumi.isIncoming || lumi.memberId != memberId) {
        continue;
      }
      if (latest == null || lumi.createdAt.isAfter(latest)) {
        latest = lumi.createdAt;
      }
    }
    return latest;
  }

  bool _wasSentToday(DateTime? value, DateTime now) {
    if (value == null) {
      return false;
    }
    return value.year == now.year &&
        value.month == now.month &&
        value.day == now.day;
  }

  String _targetDescription(int count) {
    if (count == 1) {
      return 'One person has not heard from you lately.';
    }
    return '$count people can receive a small signal now.';
  }
}
