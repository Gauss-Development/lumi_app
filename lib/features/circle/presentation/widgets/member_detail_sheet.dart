import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
import 'package:lumi/features/circle/domain/entities/circle_member.dart';

class MemberDetailSheet extends StatelessWidget {
  const MemberDetailSheet({
    required this.member,
    required this.onActivate,
    required this.onMute,
<<<<<<< HEAD
=======
    required this.onMemorialize,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    super.key,
  });

  final CircleMember member;
  final VoidCallback onActivate;
  final VoidCallback onMute;
<<<<<<< HEAD

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              member.displayName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(member.status.label),
            if ((member.subtitle ?? '').isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(member.subtitle!),
            ],
            const SizedBox(height: 20),
            if (member.status == CircleStatus.pendingOutbound ||
                member.status == CircleStatus.pendingInbound)
              FilledButton(
                onPressed: onActivate,
                child: const Text('Mark as connected'),
              ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onMute,
              child: const Text('Mute for one week'),
            ),
          ],
=======
  final VoidCallback onMemorialize;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(member.signatureColorValue);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepNight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        Colors.white.withValues(alpha: 0.8),
                        color,
                        color.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                      stops: const <double>[0, 0.2, 0.58, 1],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: color.withValues(alpha: 0.38),
                        blurRadius: 36,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  member.displayName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              if ((member.relationshipLabel ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    member.relationshipLabel!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Center(
                child: Text(
                  member.status.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if ((member.subtitle ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    member.subtitle!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textFaint,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (member.status == CircleStatus.pendingOutbound ||
                  member.status == CircleStatus.pendingInbound)
                PrimaryGlowButton(
                  label: 'Mark as connected',
                  glowColor: color,
                  onPressed: onActivate,
                ),
              if (member.status == CircleStatus.pendingOutbound ||
                  member.status == CircleStatus.pendingInbound)
                const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onMute,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: const Text('Mute for one week'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: onMemorialize,
                  child: const Text('Mark memorial'),
                ),
              ),
            ],
          ),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
        ),
      ),
    );
  }
}
