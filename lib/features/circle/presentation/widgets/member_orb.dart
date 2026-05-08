import 'package:flutter/material.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/theme/app_colors.dart';
<<<<<<< HEAD
=======
import 'package:lumi/core/widgets/glow_orb.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
import 'package:lumi/features/circle/domain/entities/circle_member.dart';

class MemberOrb extends StatelessWidget {
  const MemberOrb({
    required this.member,
    required this.onTap,
    required this.onLongPress,
    super.key,
<<<<<<< HEAD
=======
    this.diameter = 88,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  });

  final CircleMember? member;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
<<<<<<< HEAD
=======
  final double diameter;
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e

  @override
  Widget build(BuildContext context) {
    if (member == null) {
      return GestureDetector(
        onTap: onTap,
<<<<<<< HEAD
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Center(child: Icon(Icons.add, color: Colors.white38)),
=======
        child: Column(
          children: <Widget>[
            Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                color: Colors.white.withValues(alpha: 0.015),
              ),
              child: const Center(
                child: Icon(Icons.add, color: AppColors.textFaint, size: 18),
              ),
            ),
          ],
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
        ),
      );
    }

<<<<<<< HEAD
    final currentMember = member!;
    final color = Color(currentMember.signatureColorValue);
    final isNearLimit =
        currentMember.paceCount >= LumiLimits.maxLumisPerPairPerDay - 1;
=======
    final CircleMember currentMember = member!;
    final Color color = Color(currentMember.signatureColorValue);
    final bool nearLimit =
        currentMember.paceCount >= LumiLimits.maxLumisPerPairPerDay - 1;
    final bool memorial = currentMember.status == CircleStatus.memorial;
    final double intensity = switch (currentMember.lastInteractionAt) {
      null => 0.82,
      final DateTime lastSeen
          when DateTime.now().difference(lastSeen).inHours < 1 =>
        1.1,
      final DateTime lastSeen
          when DateTime.now().difference(lastSeen).inHours < 6 =>
        1.0,
      final DateTime lastSeen
          when DateTime.now().difference(lastSeen).inHours < 24 =>
        0.92,
      _ => 0.8,
    };
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
<<<<<<< HEAD
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: currentMember.isMuted ? 0.25 : 0.8),
            width: 1.4,
          ),
          gradient: RadialGradient(
            colors: <Color>[
              color.withValues(alpha: currentMember.isMuted ? 0.08 : 0.24),
              AppColors.midnight,
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: isNearLimit ? 0.12 : 0.28),
              blurRadius: isNearLimit ? 10 : 18,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  currentMember.initials,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Text(
              currentMember.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
=======
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GlowOrb(
            color: memorial ? color.withValues(alpha: 0.7) : color,
            size: diameter,
            intensity: nearLimit ? 0.72 : intensity,
            child: memorial
                ? Container(
                    width: diameter,
                    height: diameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                  )
                : null,
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
            _subtitle(currentMember),
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

  String _subtitle(CircleMember member) {
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
      return 'waiting';
    }
    final Duration diff = DateTime.now().difference(member.lastInteractionAt!);
    if (diff.inMinutes < 60) {
      return 'glowed ${diff.inMinutes.clamp(1, 59)}m ago';
    }
    if (diff.inHours < 24) {
      return 'glowed ${diff.inHours}h ago';
    }
    return 'glowed ${diff.inDays}d ago';
  }
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
}
