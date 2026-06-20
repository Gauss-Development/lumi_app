import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Soft breathing pulse for a circle orb when an incoming Lumi is waiting.
///
/// Animates [scale] and [intensityMultiplier] via [childBuilder] using a native
/// [AnimationController] (no third-party packages).
class OrbPulse extends StatefulWidget {
  const OrbPulse({
    required this.isActive,
    required this.childBuilder,
    super.key,
    this.duration = const Duration(milliseconds: 1400),
    this.minScale = 1,
    this.maxScale = 1.06,
    this.minIntensityMultiplier = 1,
    this.maxIntensityMultiplier = 1.22,
  });

  final bool isActive;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final double minIntensityMultiplier;
  final double maxIntensityMultiplier;
  final Widget Function(
    BuildContext context,
    double scale,
    double intensityMultiplier,
  )
  childBuilder;

  @override
  State<OrbPulse> createState() => _OrbPulseState();
}

class _OrbPulseState extends State<OrbPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(OrbPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    _syncAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  void _syncAnimation() {
    final bool shouldAnimate =
        widget.isActive && !MediaQuery.disableAnimationsOf(context);
    if (shouldAnimate) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
      return;
    }
    _controller
      ..stop()
      ..value = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive || MediaQuery.disableAnimationsOf(context)) {
      return widget.childBuilder(context, widget.minScale, widget.minIntensityMultiplier);
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _curve,
        builder: (BuildContext context, Widget? child) {
          final double t = _curve.value;
          final double scale = lerpDouble(widget.minScale, widget.maxScale, t)!;
          final double intensityMultiplier = lerpDouble(
            widget.minIntensityMultiplier,
            widget.maxIntensityMultiplier,
            t,
          )!;
          return widget.childBuilder(context, scale, intensityMultiplier);
        },
      ),
    );
  }
}
