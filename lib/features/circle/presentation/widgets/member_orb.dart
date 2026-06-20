import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/orb_pulse.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class MemberOrb extends StatefulWidget {
  const MemberOrb({
    required this.member,
    required this.onTap,
    required this.onLongPress,
    super.key,
    this.diameter = 88,
    this.unreadCount = 0,
  });

  final CircleMember? member;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final double diameter;
  final int unreadCount;

  @override
  State<MemberOrb> createState() => _MemberOrbState();
}

class _MemberOrbState extends State<MemberOrb> {
  Timer? _subtitleTimer;

  @override
  void initState() {
    super.initState();
    _subtitleTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _subtitleTimer?.cancel();
    super.dispose();
  }

  @override
  State<MemberOrb> createState() => _MemberOrbState();
}

class _MemberOrbState extends State<MemberOrb> {
  Timer? _subtitleTimer;

  @override
  void initState() {
    super.initState();
    _subtitleTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _subtitleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.member == null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: <Widget>[
            Container(
              width: widget.diameter,
              height: widget.diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.2,
                ),
                color: Colors.white.withValues(alpha: 0.02),
              ),
            ),
          ],
        ),
      );
    }

    final CircleMember currentMember = widget.member!;
    final Color color = Color(currentMember.signatureColorValue);
    final bool nearLimit =
        currentMember.paceCount >= LumiLimits.maxLumisPerPairPerDay - 1;
    final bool memorial = currentMember.status == CircleStatus.memorial;
    final DateTime now = DateTime.now();
    final double intensity = _intensityFor(currentMember.lastInteractionAt, now);

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GlowOrb(
            color: memorial ? color.withValues(alpha: 0.7) : color,
            size: widget.diameter,
            intensity: nearLimit ? 0.72 : intensity,
            child: memorial
                ? Container(
                    width: widget.diameter,
                    height: widget.diameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    if (widget.reactionBadge != null)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: _ReactionBadge(
                          reaction: widget.reactionBadge!,
                          diameter: widget.diameter,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            currentMember.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: Colors.white.withValues(alpha: memorial ? 0.65 : 0.85),
            ),
          ),
          Text(
            _subtitle(currentMember, now),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textFaint,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  static double _intensityFor(DateTime? lastSeen, DateTime now) {
    return switch (lastSeen) {
      null => 0.82,
      final DateTime seen when now.difference(seen).inHours < 1 => 1.1,
      final DateTime seen when now.difference(seen).inHours < 6 => 1.0,
      final DateTime seen when now.difference(seen).inHours < 24 => 0.92,
      _ => 0.8,
    };
  }

  String _subtitle(CircleMember member, DateTime now) {
    if ((member.relationshipLabel ?? '').isNotEmpty) {
      return member.relationshipLabel!;
    }
    if (member.status == CircleStatus.memorial) {
      return 'kept';
    }
    if (member.isMuted) {
      return 'quiet';
    }
    if (!member.mutualConnection) {
      return 'pending';
    }
    if (member.lastInteractionAt == null) {
      return 'connected';
    }
    final Duration diff = now.difference(member.lastInteractionAt!);
    if (diff.inMinutes < 60) {
      return 'glowed ${diff.inMinutes.clamp(1, 59)}m ago';
    }
    if (diff.inHours < 24) {
      return 'glowed ${diff.inHours}h ago';
    }
    return 'glowed ${diff.inDays}d ago';
  }
}

class _ReactionBadge extends StatelessWidget {
  const _ReactionBadge({required this.reaction, required this.diameter});

  final LumiReactionType reaction;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final double size = (diameter * 0.34).clamp(22, 30);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.deepNight.withValues(alpha: 0.92),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        reaction.emoji,
        style: TextStyle(fontSize: size * 0.52, height: 1),
      ),
    );
  }
}
