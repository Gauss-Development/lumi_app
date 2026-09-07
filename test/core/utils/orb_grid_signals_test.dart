import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/core/utils/orb_grid_signals.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

void main() {
  test('fromLumis maps unread, type, glow, and reaction badges', () {
    final DateTime now = DateTime.utc(2026, 6, 1, 12);
    final Lumi incoming = Lumi(
      id: 'lumi-in',
      senderId: 'user-a',
      memberId: 'member-b-to-a',
      isIncoming: true,
      type: LumiType.pulse,
      colorValue: 0xFFFFAA00,
      createdAt: now.subtract(const Duration(hours: 2)),
      deliveryStatus: LumiDeliveryStatus.delivered,
    );
    final Lumi outgoingReaction = Lumi(
      id: 'lumi-out',
      senderId: 'user-b',
      memberId: 'member-a-to-b',
      isIncoming: false,
      type: LumiType.pure,
      colorValue: 0xFFFFAA00,
      createdAt: now.subtract(const Duration(hours: 1)),
      deliveryStatus: LumiDeliveryStatus.reacted,
      reaction: LumiReactionType.heart,
    );

    final OrbGridSignals signals = OrbGridSignals.fromLumis(
      <Lumi>[incoming, outgoingReaction],
      now,
    );

    expect(signals.unreadByMemberId['member-b-to-a'], 1);
    expect(signals.incomingTypeByMemberId['member-b-to-a'], LumiType.pulse);
    expect(signals.nameGlowByMemberId['member-b-to-a'], isTrue);
    expect(signals.reactionBadgeByMemberId['member-a-to-b'], LumiReactionType.heart);
  });

  test('Lumi types expose distinct orb pulse timings', () {
    expect(LumiType.pulse.orbPulseDuration.inMilliseconds, lessThan(
      LumiType.pure.orbPulseDuration.inMilliseconds,
    ));
    expect(LumiType.light.orbMaxScale, lessThan(LumiType.pulse.orbMaxScale));
  });
}
