import 'package:flutter/services.dart';

class HapticsService {
  const HapticsService();

  Future<void> playIncomingLumi() async {
    await HapticFeedback.mediumImpact();
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
}
