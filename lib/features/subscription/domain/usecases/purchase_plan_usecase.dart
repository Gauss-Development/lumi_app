import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/repositories/subscription_repository.dart';

class PurchasePlanUseCase {
  const PurchasePlanUseCase(this._repository);

  final SubscriptionRepository _repository;

  Future<Either<Failure, EntitlementStatus>> call(String planId) {
    return _repository.purchasePlan(planId);
  }
}
