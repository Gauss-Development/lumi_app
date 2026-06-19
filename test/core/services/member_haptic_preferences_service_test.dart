import 'package:flutter_test/flutter_test.dart';
import 'package:lumi/core/domain/entities/signature_haptic_pattern.dart';
import 'package:lumi/core/services/member_haptic_preferences_service.dart';
import 'package:lumi/core/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('persists custom pattern per member', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences =
        PreferencesService(await SharedPreferences.getInstance());
    final MemberHapticPreferencesService service =
        MemberHapticPreferencesService(preferences);

    await service.ensureLoaded();
    expect(service.patternFor('m1'), isA<SignatureHapticPattern>());

    await service.setPattern('m1', SignatureHapticPattern.deep);
    expect(service.patternFor('m1'), SignatureHapticPattern.deep);
    expect(service.hasCustomPattern('m1'), isTrue);

    final MemberHapticPreferencesService restored =
        MemberHapticPreferencesService(preferences);
    await restored.ensureLoaded();
    expect(restored.patternFor('m1'), SignatureHapticPattern.deep);
  });
}
