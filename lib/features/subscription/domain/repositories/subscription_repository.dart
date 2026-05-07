import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, EntitlementStatus>> getEntitlementStatus();

  Future<Either<Failure, List<PaywallPlan>>> fetchPaywallPlans();

  Future<Either<Failure, EntitlementStatus>> purchasePlan(String planId);

  Future<Either<Failure, EntitlementStatus>> restorePurchases();
}
