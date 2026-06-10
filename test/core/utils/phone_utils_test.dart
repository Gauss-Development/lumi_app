import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/core/utils/phone_utils.dart';

void main() {
  group('PhoneUtils', () {
    test('normalizes 10-digit US numbers', () {
      expect(
        PhoneUtils.normalizeToE164('5551234567'),
        '+15551234567',
      );
    });

    test('keeps E.164 numbers', () {
      expect(
        PhoneUtils.normalizeToE164('+44 7911 123456'),
        '+447911123456',
      );
    });

    test('validates E.164', () {
      expect(PhoneUtils.isValidE164('+15551234567'), isTrue);
      expect(PhoneUtils.isValidE164('555'), isFalse);
    });
  });
}
