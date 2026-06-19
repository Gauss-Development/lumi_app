import 'package:flutter/services.dart';

import 'package:lumi/core/domain/entities/signature_haptic_pattern.dart';

class HapticsService {
  const HapticsService();

  Future<void> playIncomingLumi() async {
    await playSignatureIncoming(SignatureHapticPattern.warm);
  }

  Future<void> playSignatureIncoming(SignatureHapticPattern pattern) async {
    switch (pattern) {
      case SignatureHapticPattern.gentle:
        await HapticFeedback.lightImpact();
        await Future<void>.delayed(const Duration(milliseconds: 60));
        await HapticFeedback.selectionClick();
      case SignatureHapticPattern.warm:
        await HapticFeedback.mediumImpact();
      case SignatureHapticPattern.bright:
        await HapticFeedback.selectionClick();
        await Future<void>.delayed(const Duration(milliseconds: 45));
        await HapticFeedback.lightImpact();
        await Future<void>.delayed(const Duration(milliseconds: 45));
        await HapticFeedback.lightImpact();
      case SignatureHapticPattern.deep:
        await HapticFeedback.heavyImpact();
        await Future<void>.delayed(const Duration(milliseconds: 70));
        await HapticFeedback.mediumImpact();
    }
  }

  Future<void> playSoftSelection() async {
    await HapticFeedback.selectionClick();
  }

  Future<void> playPulseHit() async {
    await HapticFeedback.lightImpact();
  }

  Future<void> playPulsePattern(List<int> durationsMs) async {
    await playPulseHit();
    for (final duration in durationsMs) {
      await Future<void>.delayed(Duration(milliseconds: duration));
      await playPulseHit();
    }
  }

  /// Distinct from incoming receive — confirms a Lumi was sent.
  Future<void> playSendLumi() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 40));
    await HapticFeedback.lightImpact();
  }
}
