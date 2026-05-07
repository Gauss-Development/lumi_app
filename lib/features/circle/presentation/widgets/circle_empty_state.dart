import 'package:flutter/material.dart';

import 'package:lumi/core/widgets/primary_glow_button.dart';

class CircleEmptyState extends StatelessWidget {
  const CircleEmptyState({required this.onInviteTap, super.key});

  final VoidCallback onInviteTap;

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
