import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/services/haptics_service.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/lumi/presentation/widgets/reaction_tray.dart';

class IncomingLumiOverlay extends StatefulWidget {
  const IncomingLumiOverlay({required this.lumi, super.key});

  final Lumi lumi;

  @override
  State<IncomingLumiOverlay> createState() => _IncomingLumiOverlayState();
}

class _IncomingLumiOverlayState extends State<IncomingLumiOverlay> {
  final HapticsService _hapticsService = const HapticsService();

  @override
  void initState() {
    super.initState();
    _playLumi();
  }

  Future<void> _playLumi() async {
    switch (widget.lumi.type) {
      case LumiType.pure:
      case LumiType.light:
      case LumiType.doodle:
        await _hapticsService.playIncomingLumi();
      case LumiType.pulse:
        await _hapticsService.playPulsePattern(
          widget.lumi.pulsePattern?.beats ?? const <int>[180, 180],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color lumiColor = Color(widget.lumi.colorValue);
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: lumiColor.withValues(alpha: 0.35),
                blurRadius: 26,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      lumiColor.withValues(alpha: 0.95),
                      lumiColor.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _LumiPreview(lumi: widget.lumi, color: lumiColor),
              const SizedBox(height: 20),
              const Text(
                'A Lumi from your circle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.lumi.type.label,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.read<LumiBloc>().add(
                  LumiEvent.reactRequested(
                    memberId: widget.lumi.memberId,
                    lumiId: widget.lumi.id,
                    reaction: LumiReactionType.handOnHeart,
                  ),
                ),
                child: const Text('Lumi back'),
              ),
              const SizedBox(height: 12),
              ReactionTray(
                onSelected: (reaction) => context.read<LumiBloc>().add(
                  LumiEvent.reactRequested(
                    memberId: widget.lumi.memberId,
                    lumiId: widget.lumi.id,
                    reaction: reaction,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LumiPreview extends StatelessWidget {
  const _LumiPreview({required this.lumi, required this.color});

  final Lumi lumi;
  final Color color;

  @override
  Widget build(BuildContext context) {
    switch (lumi.type) {
      case LumiType.pure:
        return Text(
          'Just a soft thinking-of-you glow.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        );
      case LumiType.light:
        return Text(
          'Light intensity ${(lumi.intensity * 100).round()}%',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        );
      case LumiType.pulse:
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: (lumi.pulsePattern?.beats ?? const <int>[])
              .map(
                (int beat) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('${beat}ms'),
                ),
              )
              .toList(growable: false),
        );
      case LumiType.doodle:
        return SizedBox(
          width: 140,
          height: 90,
          child: CustomPaint(
            painter: _DoodlePreviewPainter(
              stroke: lumi.doodleStroke,
              color: color,
            ),
          ),
        );
    }
  }
}

class _DoodlePreviewPainter extends CustomPainter {
  const _DoodlePreviewPainter({required this.stroke, required this.color});

  final DoodleStroke? stroke;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final List<DoodlePoint> points = stroke?.points ?? const <DoodlePoint>[];
    if (points.isEmpty) {
      return;
    }

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path path = Path();
    path.moveTo(points.first.dx * size.width, points.first.dy * size.height);

    for (final DoodlePoint point in points.skip(1)) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DoodlePreviewPainter oldDelegate) {
    return oldDelegate.stroke != stroke || oldDelegate.color != color;
  }
}
