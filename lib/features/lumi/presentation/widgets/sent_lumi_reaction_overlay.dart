import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/di/injection.dart';
import 'package:lumi/core/services/acknowledged_reactions_service.dart';
import 'package:lumi/core/services/haptics_service.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class SentLumiReactionOverlay extends StatefulWidget {
  const SentLumiReactionOverlay({required this.lumi, super.key});

  final Lumi lumi;

  @override
  State<SentLumiReactionOverlay> createState() => _SentLumiReactionOverlayState();
}

class _SentLumiReactionOverlayState extends State<SentLumiReactionOverlay> {
  final HapticsService _hapticsService = const HapticsService();
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_hapticsService.playSoftSelection());
    });
  }

  String _recipientName(BuildContext context) {
    return context.read<CircleBloc>().state.maybeMap(
      loaded: (loaded) {
        for (final CircleMember member in loaded.members) {
          if (member.id == widget.lumi.memberId) {
            return member.displayName;
          }
        }
        return 'Someone close';
      },
      orElse: () => 'Someone close',
    );
  }

  Color _recipientColor(BuildContext context) {
    return context.read<CircleBloc>().state.maybeMap(
      loaded: (loaded) {
        for (final CircleMember member in loaded.members) {
          if (member.id == widget.lumi.memberId) {
            return Color(member.signatureColorValue);
          }
        }
        return AppColors.peach;
      },
      orElse: () => AppColors.peach,
    );
  }

  Future<void> _dismiss() async {
    if (_isDismissing) {
      return;
    }
    setState(() => _isDismissing = true);
    await sl<AcknowledgedReactionsService>().acknowledge(widget.lumi.id);
    await _hapticsService.playSoftSelection();
  }

  @override
  Widget build(BuildContext context) {
    final LumiReactionType reaction =
        widget.lumi.reaction ?? LumiReactionType.heart;
    final Color recipientColor = _recipientColor(context);
    final EdgeInsets safe = MediaQuery.paddingOf(context);

    return Material(
      color: Colors.black.withValues(alpha: 0.52),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: safe.top + 8,
            right: 24,
            child: IconButton(
              onPressed: _isDismissing ? null : _dismiss,
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
                    'They felt your Lumi',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _recipientName(context),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    reaction.emoji,
                    style: const TextStyle(fontSize: 72, height: 1),
                  ),
                  const SizedBox(height: 24),
                  GlowOrb(
                    color: recipientColor,
                    size: 120,
                    intensity: 1.05,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    _reactionLabel(reaction),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  PrimaryGlowButton(
                    label: _isDismissing ? 'Lovely…' : 'Lovely',
                    glowColor: recipientColor,
                    onPressed: _isDismissing ? null : _dismiss,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _reactionLabel(LumiReactionType reaction) {
    return switch (reaction) {
      LumiReactionType.heart => 'A quiet heart back to you.',
      LumiReactionType.smile => 'A warm smile came back.',
      LumiReactionType.handOnHeart => 'A hand on the heart.',
      LumiReactionType.sun => 'A little sun for your day.',
      LumiReactionType.moon => 'A soft moonlit feeling.',
    };
  }
}
