import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/features/lumi/domain/entities/lumi.dart';

void main() {
  group('Lumi incoming reply state', () {
    test('isAwaitingReply is true for delivered incoming lumis', () {
      final Lumi lumi = Lumi(
        id: 'lumi-1',
        senderId: 'user-a',
        memberId: 'member-b-to-a',
        isIncoming: true,
        type: LumiType.light,
        colorValue: 0xFFFFAA00,
        createdAt: _createdAt,
        deliveryStatus: LumiDeliveryStatus.delivered,
      );

      expect(lumi.isAwaitingReply, isTrue);
    });

    test('isAwaitingReply is false after reaction or seen', () {
      final Lumi reacted = Lumi(
        id: 'lumi-1',
        senderId: 'user-a',
        memberId: 'member-b-to-a',
        isIncoming: true,
        type: LumiType.pure,
        colorValue: 0xFFFFAA00,
        createdAt: _createdAt,
        deliveryStatus: LumiDeliveryStatus.reacted,
        reaction: LumiReactionType.heart,
      );
      final Lumi seen = Lumi(
        id: 'lumi-2',
        senderId: 'user-a',
        memberId: 'member-b-to-a',
        isIncoming: true,
        type: LumiType.pure,
        colorValue: 0xFFFFAA00,
        createdAt: _createdAt,
        deliveryStatus: LumiDeliveryStatus.seen,
      );

      expect(reacted.isAwaitingReply, isFalse);
      expect(seen.isAwaitingReply, isFalse);
    });
  });
}

final DateTime _createdAt = DateTime.utc(2026, 6, 1);
