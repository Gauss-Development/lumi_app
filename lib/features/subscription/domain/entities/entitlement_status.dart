import 'package:equatable/equatable.dart';

enum HouseholdPlan { free, monthly, yearly }

class EntitlementStatus extends Equatable {
  const EntitlementStatus({
    required this.isActive,
    required this.householdSeats,
    required this.activeMembersLimit,
    required this.plan,
  });

  const EntitlementStatus.free()
    : isActive = false,
      householdSeats = 1,
      activeMembersLimit = 3,
      plan = HouseholdPlan.free;

  const EntitlementStatus.household({required this.plan})
    : isActive = true,
      householdSeats = 6,
      activeMembersLimit = 12;

  final bool isActive;
  final int householdSeats;
  final int activeMembersLimit;
  final HouseholdPlan plan;

  @override
  List<Object?> get props => <Object?>[
    isActive,
    householdSeats,
    activeMembersLimit,
    plan,
  ];
}

class PaywallPlan extends Equatable {
  const PaywallPlan({
    required this.id,
    required this.title,
    required this.priceLabel,
    required this.description,
    required this.isAnnual,
  });

  final String id;
  final String title;
  final String priceLabel;
  final String description;
  final bool isAnnual;

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    priceLabel,
    description,
    isAnnual,
  ];
}
