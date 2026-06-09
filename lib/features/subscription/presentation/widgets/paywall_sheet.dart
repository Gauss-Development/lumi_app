import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/adaptive_scroll.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/presentation/bloc/subscription_bloc.dart';

class PaywallSheet extends StatelessWidget {
  const PaywallSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SubscriptionBloc>(),
        child: const PaywallSheet(),
      ),
    );
  }

  static const List<String> _benefits = <String>[
    'All 12 signature colors',
    'Pulse, doodle and color modes',
    'Unlimited kept shelf',
    'Family circle up to 12 lights',
    'Quiet hours and arrival rituals',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepNight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (BuildContext context, SubscriptionState state) {
            final List<PaywallPlan> plans = state.map(
              initial: (_) => const <PaywallPlan>[],
              loading: (_) => const <PaywallPlan>[],
              loaded: (loaded) => loaded.plans,
              failure: (_) => const <PaywallPlan>[],
            );
            final String selectedId = plans.any((p) => p.isAnnual)
                ? plans.firstWhere((p) => p.isAnnual).id
                : (plans.isNotEmpty ? plans.first.id : '');

            return _PaywallBody(plans: plans, selectedId: selectedId);
          },
        ),
      ),
    );
  }
}

class _PaywallBody extends StatefulWidget {
  const _PaywallBody({required this.plans, required this.selectedId});

  final List<PaywallPlan> plans;
  final String selectedId;

  @override
  State<_PaywallBody> createState() => _PaywallBodyState();
}

class _PaywallBodyState extends State<_PaywallBody> {
  late String _selectedId = widget.selectedId;

  @override
  Widget build(BuildContext context) {
    return AdaptiveSheetBody(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
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
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ),
            const GlowOrb(color: AppColors.gold, size: 180, intensity: 1.1),
            const SizedBox(height: 24),
            Text(
              'Lumi Glow+',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              'A warmer light\nfor the people you love',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Glow+ unlocks every color, every gesture, and the full kept shelf.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 28),
            ...PaywallSheet._benefits.map((String benefit) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gold.withValues(alpha: 0.16),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(benefit)),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            ...widget.plans.map((PaywallPlan plan) {
              final bool selected = _selectedId == plan.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => setState(() => _selectedId = plan.id),
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.gold.withValues(alpha: 0.08)
                          : Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selected
                            ? AppColors.gold.withValues(alpha: 0.7)
                            : Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? AppColors.gold
                                : Colors.transparent,
                            border: Border.all(
                              color: selected
                                  ? AppColors.gold
                                  : Colors.white.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: selected
                              ? const Icon(
                                  Icons.check,
                                  size: 11,
                                  color: AppColors.deepNight,
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    plan.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  if (plan.isAnnual) ...<Widget>[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withValues(
                                          alpha: 0.16,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text(
                                        'Best',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: AppColors.gold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                plan.description,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text(plan.priceLabel),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 14),
            BlocListener<SubscriptionBloc, SubscriptionState>(
              listenWhen: (SubscriptionState prev, SubscriptionState curr) {
                final bool failed = curr.maybeWhen(
                  failure: (_) => true,
                  orElse: () => false,
                );
                final bool purchaseCompleted =
                    prev.maybeWhen(loading: () => true, orElse: () => false) &&
                    curr.maybeWhen(
                      loaded: (_, _) => true,
                      orElse: () => false,
                    );
                return failed || purchaseCompleted;
              },
              listener: (BuildContext context, SubscriptionState state) {
                state.whenOrNull(
                  failure: (String message) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(message)));
                  },
                  loaded: (_, _) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
              child: PrimaryGlowButton(
                label: 'Begin Glow+',
                glowColor: AppColors.gold,
                onPressed: widget.plans.isEmpty
                    ? null
                    : () {
                        context.read<SubscriptionBloc>().add(
                          SubscriptionEvent.purchaseRequested(_selectedId),
                        );
                      },
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context.read<SubscriptionBloc>().add(
                  const SubscriptionEvent.restoreRequested(),
                );
              },
              child: const Text('Restore purchases'),
            ),
            const SizedBox(height: 14),
            Text(
              '7 days free, then renews automatically. Cancel anytime in settings.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
            ),
          ],
        ),
      ),
    );
  }
}
