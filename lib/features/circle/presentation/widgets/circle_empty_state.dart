import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';

class CircleEmptyState extends StatelessWidget {
  const CircleEmptyState({required this.onInviteTap, super.key});

  final VoidCallback onInviteTap;

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
