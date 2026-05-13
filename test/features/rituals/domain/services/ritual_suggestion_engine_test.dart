import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/rituals/domain/entities/ritual_preferences.dart';
import 'package:lumi/features/rituals/domain/services/ritual_suggestion_engine.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';

void main() {
  const engine = RitualSuggestionEngine();
  const quietHours = QuietHours(
    startHour: 23,
    startMinute: 0,
    endHour: 7,
    endMinute: 0,
  );

  test('suggests morning light during the morning window', () {
    final suggestion = engine.suggest(
      preferences: const RitualPreferences(morningHour: 9),
      quietHours: quietHours,
      members: <CircleMember>[_member('member-a'), _member('member-b')],
      recentLumis: const <Lumi>[],
      now: DateTime(2026, 5, 13, 9, 30),
    );

    expect(suggestion?.kind, RitualKind.morning);
    expect(suggestion?.memberIds, <String>['member-a', 'member-b']);
  });

  test('does not suggest a daily ritual twice in one day', () {
    final suggestion = engine.suggest(
      preferences: RitualPreferences(
        morningHour: 9,
        gentleRemindersEnabled: false,
        lastMorningSentAt: DateTime(2026, 5, 13, 9),
      ),
      quietHours: quietHours,
      members: <CircleMember>[_member('member-a')],
      recentLumis: const <Lumi>[],
      now: DateTime(2026, 5, 13, 10),
    );

    expect(suggestion, isNull);
  });

  test('suggests check-in only for stale relationships', () {
    final suggestion = engine.suggest(
      preferences: const RitualPreferences(
        morningEnabled: false,
        eveningEnabled: false,
        reminderCadenceDays: 3,
      ),
      quietHours: quietHours,
      members: <CircleMember>[_member('fresh'), _member('stale')],
      recentLumis: <Lumi>[
        Lumi(
          id: 'lumi-1',
          senderId: 'user-a',
          memberId: 'fresh',
          isIncoming: false,
          type: LumiType.pure,
          colorValue: 0,
          createdAt: DateTime(2026, 5, 12),
        ),
      ],
      now: DateTime(2026, 5, 13, 14),
    );

    expect(suggestion?.kind, RitualKind.checkIn);
    expect(suggestion?.memberIds, <String>['stale']);
  });
}

CircleMember _member(String id) {
  return CircleMember(
    id: id,
    displayName: id,
    signatureColorValue: 0,
    status: CircleStatus.active,
    paceCount: 0,
    queuedCount: 0,
    mutualConnection: true,
  );
}
