import 'package:flutter_test/flutter_test.dart';
import 'package:lumi/core/domain/entities/signature_haptic_pattern.dart';

void main() {
  test('defaultForMember is stable per id', () {
    final SignatureHapticPattern a =
        SignatureHapticPattern.defaultForMember('member-a');
    final SignatureHapticPattern b =
        SignatureHapticPattern.defaultForMember('member-a');
    final SignatureHapticPattern other =
        SignatureHapticPattern.defaultForMember('member-b');

    expect(a, b);
    expect(SignatureHapticPattern.values, contains(a));
    expect(SignatureHapticPattern.values, contains(other));
  });

  test('fromStorage falls back to warm', () {
    expect(
      SignatureHapticPattern.fromStorage('deep'),
      SignatureHapticPattern.deep,
    );
    expect(
      SignatureHapticPattern.fromStorage('unknown'),
      SignatureHapticPattern.warm,
    );
  });
}
