import 'package:flutter/services.dart';

class HapticsService {
  const HapticsService();

  Future<void> playIncomingLumi() async {
    await HapticFeedback.mediumImpact();
  }

  Future<void> playSoftSelection() async {
    await HapticFeedback.selectionClick();
  }

  Future<void> playPulsePattern(List<int> durationsMs) async {
    for (final duration in durationsMs) {
      await HapticFeedback.lightImpact();
      await Future<void>.delayed(Duration(milliseconds: duration));
    }
  }
}
