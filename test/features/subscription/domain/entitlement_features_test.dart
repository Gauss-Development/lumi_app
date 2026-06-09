import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/entitlement_features.dart';

void main() {
  group('EntitlementFeatures', () {
    test('free tier allows pure only and three colors', () {
      const EntitlementStatus status = EntitlementStatus.free();

      expect(status.canSendLumiType(LumiType.pure), isTrue);
      expect(status.canSendLumiType(LumiType.pulse), isFalse);
      expect(status.composerColorValues(), hasLength(3));
    });

    test('household unlocks all modes and colors', () {
      const EntitlementStatus status = EntitlementStatus.household(
        plan: HouseholdPlan.yearly,
      );

      expect(status.canSendLumiType(LumiType.doodle), isTrue);
      expect(status.composerColorValues(), hasLength(12));
    });
  });
}
