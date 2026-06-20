import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lumi/core/services/pending_lumi_notification_service.dart';
import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/core/utils/lumi_push_payload.dart';

void main() {
  group('PendingLumiNotificationService', () {
    late PendingLumiNotificationService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      service = PendingLumiNotificationService(PreferencesService(prefs));
    });

    test('peek returns stored payload without clearing it', () async {
      const LumiPushPayload payload = LumiPushPayload(
        lumiId: 'lumi-1',
        senderMemberId: 'member-1',
        senderName: 'Mom',
      );

      await service.store(payload);

      expect(service.peek(), payload);
      expect(service.peek(), payload);
    });

    test('consume returns payload once', () async {
      const LumiPushPayload payload = LumiPushPayload(
        lumiId: 'lumi-2',
        senderMemberId: 'member-2',
      );

      await service.store(payload);

      expect(await service.consume(), payload);
      expect(await service.consume(), isNull);
      expect(service.peek(), isNull);
    });
  });
}
