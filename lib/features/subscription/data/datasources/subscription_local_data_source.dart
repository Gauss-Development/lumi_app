import 'dart:convert';

import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';

class SubscriptionLocalDataSource {
  SubscriptionLocalDataSource(this._preferencesService);

  static const _subscriptionKey = 'subscription_state';

  final PreferencesService _preferencesService;

  Future<EntitlementStatus> getStatus() async {
    final raw = _preferencesService.getString(_key);
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

  Future<void> saveStatus(EntitlementStatus status) async {
    await _preferencesService.setString(
      _key,
      jsonEncode(<String, dynamic>{
        'isActive': status.isActive,
        'householdSeats': status.householdSeats,
        'activeMembersLimit': status.activeMembersLimit,
        'plan': status.plan.name,
      }),
    );
  }

  String get _key => _preferencesService.userScopedKey(_subscriptionKey);
}
