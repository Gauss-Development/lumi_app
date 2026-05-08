import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
import 'package:lumi/core/widgets/primary_glow_button.dart';

class CircleEmptyState extends StatelessWidget {
  const CircleEmptyState({required this.onInviteTap, super.key});

  final VoidCallback onInviteTap;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.circle_outlined, size: 72, color: Colors.white54),
            const SizedBox(height: 24),
            Text(
              'Invite your first person',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Twelve quiet spaces. Start with one orb that matters.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryGlowButton(label: 'Invite', onPressed: onInviteTap),
          ],
        ),
      ),
=======
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const GlowOrb(color: AppColors.softLavender, size: 120, intensity: 0.75),
        const SizedBox(height: 24),
        Text(
          'Invite your first person',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Twelve quiet spaces. Start with one orb that matters.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        PrimaryGlowButton(
          label: 'Invite',
          glowColor: AppColors.softLavender,
          onPressed: onInviteTap,
        ),
      ],
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    );
  }
}
