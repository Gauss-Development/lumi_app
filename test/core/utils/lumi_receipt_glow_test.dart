import 'package:flutter_test/flutter_test.dart';
import 'package:lumi/core/utils/lumi_receipt_glow.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

void main() {
  test('latestIncomingReceiptByMemberId keeps newest incoming', () {
    final DateTime older = DateTime(2026, 6, 1, 10);
    final DateTime newer = DateTime(2026, 6, 1, 12);
    final Map<String, DateTime> latest = latestIncomingReceiptByMemberId(
      <Lumi>[
        Lumi(
          id: '1',
          senderId: 'u1',
          memberId: 'm1',
          isIncoming: true,
          type: LumiType.pure,
          colorValue: 0xFFFF0000,
          createdAt: older,
        ),
        Lumi(
          id: '2',
          senderId: 'u1',
          memberId: 'm1',
          isIncoming: true,
          type: LumiType.pure,
          colorValue: 0xFFFF0000,
          createdAt: newer,
        ),
        Lumi(
          id: '3',
          senderId: 'u2',
          memberId: 'm2',
          isIncoming: false,
          type: LumiType.pure,
          colorValue: 0xFF00FF00,
          createdAt: newer,
        ),
      ],
    );

    expect(latest['m1'], newer);
    expect(latest.containsKey('m2'), isFalse);
  });

  test('memberNameGlowActive within six hours', () {
    final DateTime now = DateTime(2026, 6, 1, 18);
    expect(
      memberNameGlowActive(DateTime(2026, 6, 1, 13), now),
      isTrue,
    );
    expect(
      memberNameGlowActive(DateTime(2026, 6, 1, 11, 59), now),
      isFalse,
    );
  });
}
