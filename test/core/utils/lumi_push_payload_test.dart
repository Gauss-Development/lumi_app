import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/core/utils/lumi_push_payload.dart';

void main() {
  group('LumiPushPayload', () {
    test('fromData parses sender metadata without content preview fields', () {
      final LumiPushPayload? payload = LumiPushPayload.fromData(
        <String, dynamic>{
          'lumiId': 'lumi-1',
          'senderMemberId': 'member-1',
          'recipientMemberId': 'member-2',
          'type': 'pure',
          'senderName': 'Mom',
          'senderColorValue': '16744171',
        },
      );

      expect(payload, isNotNull);
      expect(payload!.lumiId, 'lumi-1');
      expect(payload.senderMemberId, 'member-1');
      expect(payload.senderName, 'Mom');
      expect(payload.senderColorValue, 16744171);
      expect(payload.body, 'A Lumi from Mom');
    });

    test('privacySafeBody falls back when sender name is missing', () {
      expect(
        LumiPushPayload.privacySafeBody(senderName: null),
        'You received a Lumi.',
      );
      expect(
        LumiPushPayload.privacySafeBody(senderName: '   '),
        'You received a Lumi.',
      );
    });

    test('round-trips through storage map', () {
      const LumiPushPayload original = LumiPushPayload(
        lumiId: 'lumi-9',
        senderMemberId: 'member-9',
        senderName: 'Alex',
        senderColorValue: 0xFFFF7D6B,
      );

      final LumiPushPayload? restored = LumiPushPayload.fromStorageMap(
        original.toStorageMap(),
      );

      expect(restored, original);
    });
  });
}
