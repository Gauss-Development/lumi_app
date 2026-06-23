import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/orb_pulse.dart';

void main() {
  testWidgets('OrbPulse stays static when inactive', (WidgetTester tester) async {
    double lastScale = 0;
    double lastIntensityMultiplier = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrbPulse(
            isActive: false,
            childBuilder: (BuildContext context, double scale, double multiplier) {
              lastScale = scale;
              lastIntensityMultiplier = multiplier;
              return GlowOrb(color: Colors.cyan, size: 48, intensity: multiplier);
            },
          ),
        ),
      ),
    );

    expect(lastScale, 1);
    expect(lastIntensityMultiplier, 1);
    expect(
      find.descendant(
        of: find.byType(OrbPulse),
        matching: find.byType(AnimatedBuilder),
      ),
      findsNothing,
    );
  });

  testWidgets('OrbPulse animates scale and intensity when active', (
    WidgetTester tester,
  ) async {
    final List<double> scales = <double>[];
    final List<double> multipliers = <double>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrbPulse(
            isActive: true,
            duration: const Duration(milliseconds: 100),
            childBuilder: (BuildContext context, double scale, double multiplier) {
              scales.add(scale);
              multipliers.add(multiplier);
              return SizedBox(
                width: 48,
                height: 48,
                child: GlowOrb(color: Colors.cyan, size: 48, intensity: multiplier),
              );
            },
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(OrbPulse),
        matching: find.byType(AnimatedBuilder),
      ),
      findsOneWidget,
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    expect(scales, isNotEmpty);
    expect(multipliers, isNotEmpty);
    expect(scales.any((double value) => value > 1), isTrue);
    expect(multipliers.any((double value) => value > 1), isTrue);
  });

  testWidgets('OrbPulse respects reduced motion', (WidgetTester tester) async {
    double lastScale = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: OrbPulse(
              isActive: true,
              childBuilder: (BuildContext context, double scale, double multiplier) {
                lastScale = scale;
                return const SizedBox(width: 48, height: 48);
              },
            ),
          ),
        ),
      ),
    );

    expect(lastScale, 1);
    expect(
      find.descendant(
        of: find.byType(OrbPulse),
        matching: find.byType(AnimatedBuilder),
      ),
      findsNothing,
    );
  });
}
