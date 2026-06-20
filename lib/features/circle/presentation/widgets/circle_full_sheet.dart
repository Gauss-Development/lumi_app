import 'package:flutter/material.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/subscription/presentation/widgets/paywall_sheet.dart';

class CircleFullSheet extends StatelessWidget {
  const CircleFullSheet({
    required this.activeMembersLimit,
    required this.requiresUpgrade,
    super.key,
  });

  final int activeMembersLimit;
  final bool requiresUpgrade;

  static Future<void> show(
    BuildContext context, {
    required int activeMembersLimit,
    required bool requiresUpgrade,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => CircleFullSheet(
        activeMembersLimit: activeMembersLimit,
        requiresUpgrade: requiresUpgrade,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool atHouseholdCap =
        activeMembersLimit >= LumiLimits.circleCap && !requiresUpgrade;
    final String title = atHouseholdCap
        ? 'All $activeMembersLimit lights are here'
        : 'Your circle is full';
    final String body = atHouseholdCap
        ? 'Lumi keeps your circle intimate — twelve people is the most you can hold at once. Remove someone gently before inviting another light.'
        : 'Free circles hold up to $activeMembersLimit people. Upgrade to Glow+ for up to ${LumiLimits.circleCap} family lights in one household.';

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              if (requiresUpgrade)
                PrimaryGlowButton(
                  label: 'See Glow+ plans',
                  glowColor: AppColors.softLavender,
                  onPressed: () {
                    Navigator.of(context).pop();
                    PaywallSheet.show(context);
                  },
                )
              else
                PrimaryGlowButton(
                  label: 'Got it',
                  glowColor: AppColors.peach,
                  onPressed: () => Navigator.of(context).pop(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
