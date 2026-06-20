class PhoneUtils {
  const PhoneUtils._();

  /// Normalizes user input to E.164 when possible (defaults to US +1).
  static String normalizeToE164(String raw, {String defaultCountryCode = '1'}) {
    final String digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }
    if (raw.trim().startsWith('+')) {
      return '+$digits';
    }
    if (digits.length == 10) {
      return '+$defaultCountryCode$digits';
    }
    if (digits.length == 11 && digits.startsWith('1')) {
      return '+$digits';
    }
    return '+$digits';
  }

  static bool isValidE164(String phone) {
    return RegExp(r'^\+\d{10,15}$').hasMatch(phone);
  }

  static String maskForDisplay(String phone) {
    if (phone.length < 4) {
      return phone;
    }
    return '••• •• ${phone.substring(phone.length - 4)}';
  }
}
