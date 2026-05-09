import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/services/haptics_service.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';
import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';
import 'package:lumi/features/shelf/presentation/bloc/shelf_bloc.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:lumi/features/subscription/presentation/widgets/paywall_sheet.dart';

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
      case LumiType.pulse:
        await _hapticsService.playPulsePattern(
          widget.lumi.pulsePattern?.beats ?? const <int>[180, 220],
        );
      case LumiType.pure:
      case LumiType.light:
      case LumiType.doodle:
        await _hapticsService.playIncomingLumi();
    }
  }

  String _senderName(BuildContext context) {
    return context.read<CircleBloc>().state.maybeWhen(
      loaded: (
        members,
        availableSlots,
        latestInviteLink,
        showUpgradePrompt,
      ) {
        for (final member in members) {
          if (member.id == widget.lumi.memberId) {
            return member.displayName;
          }
        }
        return widget.lumi.memberId;
      },
      orElse: () => widget.lumi.memberId,
    );
  }

  void _markSeen(BuildContext context) {
    context.read<LumiBloc>().add(
      LumiEvent.markSeenRequested(
        memberId: widget.lumi.memberId,
        lumiId: widget.lumi.id,
      ),
    );
  }

  void _glowBack(BuildContext context) {
    final String senderId = context.read<AuthBloc>().state.maybeWhen(
      authenticated: (session) => session.userId,
      orElse: () => 'local-user',
    );
    final int colorValue = context.read<ProfileSetupBloc>().state.signatureColorValue == 0
        ? AppConstants.signatureColors.first.toARGB32()
        : context.read<ProfileSetupBloc>().state.signatureColorValue;
    context.read<LumiBloc>().add(
      LumiEvent.sendPureRequested(
        senderId: senderId,
        memberId: widget.lumi.memberId,
        colorValue: colorValue,
      ),
    );
    _markSeen(context);
  }

  void _keepOnShelf(BuildContext context) {
    final EntitlementStatus? status = context.read<SubscriptionBloc>().state.maybeWhen(
      loaded: (status, plans) => status,
      orElse: () => null,
    );
    if (status == null || !status.isActive) {
      PaywallSheet.show(context);
      return;
    }
    context.read<ShelfBloc>().add(
      ShelfEvent.saveRequested(
        KeptLumi(
          id: 'kept-${widget.lumi.id}',
          lumiId: widget.lumi.id,
          senderId: widget.lumi.senderId,
          senderName: _senderName(context),
          savedAt: DateTime.now(),
          previewLabel: widget.lumi.type.label,
        ),
      ),
    );
    _markSeen(context);
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Color(widget.lumi.colorValue);
    final EdgeInsets safe = MediaQuery.paddingOf(context);

    return Material(
      color: Colors.black.withValues(alpha: 0.58),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: safe.top + 8,
            right: 24,
            child: IconButton(
              onPressed: () => _markSeen(context),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                ),
              ),
              icon: const Icon(Icons.close_rounded, size: 18),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'A glow from',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _senderName(context),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 36),
                  GlowOrb(
                    color: color,
                    size: 300,
                    intensity: 1.05,
                    child: widget.lumi.type == LumiType.doodle
                        ? CustomPaint(
                            size: const Size(220, 220),
                            painter: _DoodlePreviewPainter(
                              stroke: widget.lumi.doodleStroke,
                              color: color,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 36),
                  Text(
                    _bodyCopy(widget.lumi.type),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: safe.bottom + 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _glowBack(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.75),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.wb_incandescent_outlined, size: 16),
                      label: const Text('Glow back'),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _keepOnShelf(context),
                      style: TextButton.styleFrom(
                        foregroundColor: color,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.bookmark_outline_rounded, size: 16),
                      label: const Text('Keep on shelf'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _bodyCopy(LumiType type) {
    return switch (type) {
      LumiType.pulse => 'A pulse from someone you love. Sit with the rhythm for a moment.',
      LumiType.doodle => 'A small mark, sent without words. Hold it as long as you like.',
      LumiType.light => 'A feeling arrived softly. No words needed — just presence.',
      LumiType.pure => 'Thinking of you. No words needed — sit with it as long as you like.',
    };
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
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final Path path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
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
