import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      padding: EdgeInsets.zero,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
              ),
              Text(
                'Privacy',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.textFaint),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            'Quiet by design.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Lumi is built for small circles, not feeds. These are the privacy promises the app currently keeps.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          const _PrivacyCard(
            icon: Icons.people_outline_rounded,
            title: 'Circle-only sharing',
            body:
                'Lumis are addressed to people in your circle. There is no public profile, follower graph, or discovery surface.',
          ),
          const _PrivacyCard(
            icon: Icons.message_outlined,
            title: 'No message content',
            body:
                'A Lumi carries a type, color, timing, and lightweight reaction state. It is intentionally not a text conversation.',
          ),
          const _PrivacyCard(
            icon: Icons.notifications_none_rounded,
            title: 'Permission control',
            body:
                'Notifications, haptics, quiet hours, and app pause stay under your control from Settings.',
          ),
          const _PrivacyCard(
            icon: Icons.lock_outline_rounded,
            title: 'Account data',
            body:
                'Your account and circle data are stored in Supabase. Local preferences such as rituals and shelf items are scoped to your signed-in account on this device.',
          ),
          const SizedBox(height: 12),
          Text(
            'More granular export and deletion controls will live here as the backend surface grows.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
          ),
        ],
      ),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textFaint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
