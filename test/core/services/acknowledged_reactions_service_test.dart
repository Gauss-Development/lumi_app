import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lumi/core/services/acknowledged_reactions_service.dart';
import 'package:lumi/core/services/preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AcknowledgedReactionsService', () {
    late PreferencesService preferences;
    late AcknowledgedReactionsService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      preferences = PreferencesService(await SharedPreferences.getInstance());
      service = AcknowledgedReactionsService(preferences);
      await service.ensureLoaded();
    });

    test('starts empty and persists acknowledgements', () async {
      expect(service.isAcknowledged('lumi-1'), isFalse);

      await service.acknowledge('lumi-1');

      expect(service.isAcknowledged('lumi-1'), isTrue);

      final AcknowledgedReactionsService restored =
          AcknowledgedReactionsService(preferences);
      await restored.ensureLoaded();

      expect(restored.isAcknowledged('lumi-1'), isTrue);
    });

    test('notifies listeners when a reaction is acknowledged', () async {
      var notifications = 0;
      service.addListener(() => notifications++);

      await service.acknowledge('lumi-2');
      await service.acknowledge('lumi-2');

      expect(notifications, 1);
    });
  });
}
