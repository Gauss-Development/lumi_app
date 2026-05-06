import 'dart:convert';

import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';

class SubscriptionLocalDataSource {
  SubscriptionLocalDataSource(this._preferencesService);

  static const _subscriptionKey = 'subscription_state';

  final PreferencesService _preferencesService;

  Future<EntitlementStatus> getStatus() async {
    final raw = _preferencesService.getString(_subscriptionKey);
    if (raw == null || raw.isEmpty) {
      return const EntitlementStatus.free();
    }

    final map = jsonDecode(raw) as Map<String, dynamic>;
    return EntitlementStatus(
      isActive: map['isActive'] as bool? ?? false,
      householdSeats: map['householdSeats'] as int? ?? 1,
      activeMembersLimit: map['activeMembersLimit'] as int? ?? 3,
      plan: HouseholdPlan.values.firstWhere(
        (value) => value.name == map['plan'],
        orElse: () => HouseholdPlan.monthly,
      ),
    );
  }

  List<PaywallPlan> defaultPlans() {
    return const <PaywallPlan>[
      PaywallPlan(
        id: 'household_monthly',
        title: 'Household monthly',
        priceLabel: '\$3.99/mo',
        description: 'Up to 6 accounts, 12 circle members, Kept Shelf, rituals',
        isAnnual: false,
      ),
      PaywallPlan(
        id: 'household_yearly',
        title: 'Household yearly',
        priceLabel: '\$29/yr',
        description: 'Best value for close family circles',
        isAnnual: true,
      ),
    ];
  }

  Future<EntitlementStatus> purchase(String planId) async {
    final isAnnual = planId.contains('year');
    final status = EntitlementStatus(
      isActive: true,
      householdSeats: 6,
      activeMembersLimit: 12,
      plan: isAnnual ? HouseholdPlan.yearly : HouseholdPlan.monthly,
    );
    await _saveStatus(status);
    return status;
  }

  Future<EntitlementStatus> restore() {
    return getStatus();
  }

  Future<void> _saveStatus(EntitlementStatus status) async {
    await _preferencesService.setString(
      _subscriptionKey,
      jsonEncode(<String, dynamic>{
        'isActive': status.isActive,
        'householdSeats': status.householdSeats,
        'activeMembersLimit': status.activeMembersLimit,
        'plan': status.plan.name,
      }),
    );
  }
}
