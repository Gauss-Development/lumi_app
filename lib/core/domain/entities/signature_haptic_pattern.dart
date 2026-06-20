/// Per-circle-member incoming Lumi haptic feel (GAU-281).
enum SignatureHapticPattern {
  gentle,
  warm,
  bright,
  deep;

  String get label => switch (this) {
    SignatureHapticPattern.gentle => 'Gentle',
    SignatureHapticPattern.warm => 'Warm',
    SignatureHapticPattern.bright => 'Bright',
    SignatureHapticPattern.deep => 'Deep',
  };

  String get storageKey => name;

  static SignatureHapticPattern fromStorage(String? raw) {
    if (raw == null || raw.isEmpty) {
      return SignatureHapticPattern.warm;
    }
    return SignatureHapticPattern.values.asNameMap()[raw] ??
        SignatureHapticPattern.warm;
  }

  /// Stable default when the user has not chosen a pattern yet.
  static SignatureHapticPattern defaultForMember(String memberId) {
    if (memberId.isEmpty) {
      return SignatureHapticPattern.warm;
    }
    final int index =
        memberId.hashCode.abs() % SignatureHapticPattern.values.length;
    return SignatureHapticPattern.values[index];
  }
}
