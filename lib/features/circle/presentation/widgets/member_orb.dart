import 'package:flutter/material.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';

class MemberOrb extends StatelessWidget {
  const MemberOrb({
    required this.member,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final CircleMember? member;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    if (member == null) {
      return GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Center(child: Icon(Icons.add, color: Colors.white38)),
        ),
      );
    }

    final currentMember = member!;
    final color = Color(currentMember.signatureColorValue);
    final isNearLimit =
        currentMember.paceCount >= LumiLimits.maxLumisPerPairPerDay - 1;
    final double recentActivityGlow = switch (currentMember.lastInteractionAt) {
      null => 0.12,
      final DateTime lastSeen
          when DateTime.now().difference(lastSeen).inHours < 1 =>
        0.42,
      final DateTime lastSeen
          when DateTime.now().difference(lastSeen).inHours < 6 =>
        0.28,
      final DateTime lastSeen
          when DateTime.now().difference(lastSeen).inHours < 24 =>
        0.18,
      _ => 0.1,
    };

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
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
              color: color.withValues(
                alpha: isNearLimit ? 0.12 : recentActivityGlow,
              ),
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
            if ((currentMember.relationshipLabel ?? '').isNotEmpty)
              Text(
                currentMember.relationshipLabel!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
