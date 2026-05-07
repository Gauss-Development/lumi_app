import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1630),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          final List<PaywallPlan> plans = state.map(
            initial: (_) => const <PaywallPlan>[],
            loading: (_) => const <PaywallPlan>[],
            loaded: (loaded) => loaded.plans,
            failure: (_) => const <PaywallPlan>[],
          );

          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Unlock the full circle',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Invite up to ${LumiLimits.maxCircleMembers} people, keep treasured Lumis forever, and unlock rituals for the whole household.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ...plans.map(
                  (PaywallPlan plan) => Card(
                    child: ListTile(
                      title: Text(plan.title),
                      subtitle: Text(plan.description),
                      trailing: Text(plan.priceLabel),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryGlowButton(
                  label: 'Start household plan',
                  onPressed: plans.isEmpty
                      ? null
                      : () {
                          context.read<SubscriptionBloc>().add(
                            SubscriptionEvent.purchaseRequested(plans.first.id),
                          );
                          Navigator.of(context).pop();
                        },
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
              ],
            ),
          );
        },
      ),
    );
  }
}
