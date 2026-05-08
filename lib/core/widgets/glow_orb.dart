import 'package:flutter/material.dart';

class GlowOrb extends StatelessWidget {
  const GlowOrb({
    required this.color,
    super.key,
    this.size = 220,
    this.intensity = 1,
    this.child,
  });

  final Color color;
  final double size;
  final double intensity;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            Colors.white.withValues(alpha: 0.8 * intensity),
            color,
            color.withValues(alpha: 0.45),
            Colors.transparent,
          ],
          stops: const <double>[0, 0.18, 0.52, 1],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.5 * intensity),
            blurRadius: size * 0.22,
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.25 * intensity),
            blurRadius: size * 0.42,
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
